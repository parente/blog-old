title: Control Read/Write Access to Your Private Docker Registry
date: 2015-02-07

Last year, I wrote a post on how to run a [private Docker registry backed by SoftLayer Object Storage](docker-registry-softlayer-object-storage). Soon after, my team and I started using such a registry at work behind an nginx proxy requiring basic authentication. This setup, [documented in numerous places on the web](https://www.google.com/webhp?#q=docker%20registry%20nginx), sufficed for the last six months: it let our team to push and pull images while denying anonymous access.

Recently, we needed to grant some users pull-only access to our registry while retaining full push-pull access ourselves. I could not locate a recipe for such a setup on the web, and struggled a bit to find the appropriate incantation in nginx. In the end, I landed on a solution using [subrequests](http://nginx.org/en/docs/http/ngx_http_auth_request_module.html) and [conditional status codes](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html) to grant some users read-write access, others read-only access, and anonymous users no access at all. The trick is to determine which HTTP methods to allow based on a portion of the authenticated username.

I've posted a [complete nginx.conf](https://gist.github.com/parente/c8900ec8877c9afd38e5) implementing this scheme. You can grab it and go, or keep reading for an explanation of the configuration and an outline of how to use it.

## Understanding It

The following snippets show the sections of the `nginx.conf` file used to implement the authorization mechanism.

<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/gist-embed/2.0/gist-embed.min.js"></script>

<div data-gist-id="c8900ec8877c9afd38e5" data-gist-line="27-36"></div>

The snippet above enables basic auth over all `docker-registry` upstream endpoints by default. It authenticates users based on credentials in the `/etc/users/registry_users` file created with the [htpasswd](http://httpd.apache.org/docs/2.4/programs/htpasswd.html) utility. It then delegates to the `/_auth` location for further checks.

<div data-gist-id="c8900ec8877c9afd38e5" data-gist-line="37-49"></div>

The `/_auth` location tests the value of the `$remote_user` (i.e., the authenticated username) and the `$request_method`.

1. If the username starts with `admin` or `admin-`, the subrequest handler responds with a status code of 200. This response allows any client request to proceed to the registry via the original handler (`location /`). A match on this condition effectively grants **full read-write access** to the registry.
2. If the username does not start with the `admin` prefix, but the HTTP request method is `GET` or `HEAD`, the subrequest handler responds with 200 status. This response allows the client request to proceed to the upstream registry. A match on this condition effectively grants **read-only access** to the registry.
3. In any other case, the subrequest handler responds with a `403 Forbidden`. The original request handler aborts further processing and returns the 403 response to the client. A match on this condition **prohibits the client request** from reaching the registry. In effect, this condition prevents all anonymous user access and prevents anything but `GET` and `HEAD` access (i.e., read-only access) by non-admin users.

<div data-gist-id="c8900ec8877c9afd38e5" data-gist-line="51-58"></div>

The Docker client requires the ability to `POST` to the `/v1/users` endpoint during login. The above location definition protects `/v1/users` with basic authentication, but allows any authenticated user to `POST` here to complete the Docker login process.

## Using It

To use this config, follow these general steps:

1. Grab the [complete config template](https://gist.github.com/parente/c8900ec8877c9afd38e5).
2. Modify the `server_name` value at least.
3. Pull the [registry](https://registry.hub.docker.com/u/library/registry/) and [nginx](https://registry.hub.docker.com/_/nginx/) images from Docker Hub.
4. Use `htpasswd` to create a users file.
5. Run a registry container and link the configured nginx container to it.

A simple deployment might look like something like the following. Of course, you'll want to configure [more robust storage](docker-registry-softlayer-object-storage/) for the registry if you start to use it in earnest.

```bash
$ docker pull registry:0.9.1
$ docker pull nginx:2.7

$ htpasswd -c registry_users janedoe
New password: ******
Re-type new password: ******
Adding password for user janedoe

$ htpasswd registry_users admin-parente
New password: ******
Re-type new password: ******
Adding password for user admin-parente

$ docker run -itd \
    --user www-data \
    --name registry \
    --volume /tmp \
    -e SETTINGS_FLAVOR=local \
    -e GUNICORN_WORKERS=4 \
    registry:0.9.1

$ docker run -itd \
    -p 443:443 \
    --name proxy \
    --link registry:registry \
    -v /host/path/to/nginx.conf:/etc/nginx.conf \
    -v /host/path/to/registry_users:/etc/nginx/registry_users \
    -v /host/path/to/ssl_cert:/etc/nginx/server.crt \
    -v /host/path/to/ssl_key:/etc/nginx/server.key \
    nginx:1.7
```