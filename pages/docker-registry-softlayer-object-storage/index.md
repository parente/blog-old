Title: Run a Docker Registry Backed by IBM SoftLayer Object Storage
Date: 2014-06-22

A [Docker registry](https://docs.docker.com/reference/api/registry_api/) stores the images and the graph for a set of repositories. The shiny, new [Docker Hub](https://hub.docker.com/) uses one to store all of the wonderful repositories created by the Docker community. You too can run a registry by spinning up an instance of the official [Docker registry image](https://registry.hub.docker.com/_/registry/). In fact, it's trivial to get a registry running using host local disk:

```bash
me@local$ mkdir -p /mnt/registry
me@local$ sudo docker run -d -p 5000:5000 -v /mnt/registry:/tmp/registry registry
```

Such a standalone registry can prove useful, say, in quickly deploying containers on a cloud private network. Of course, for serious applications, you'll want more robust storage than local disk, especially on virtual hosts. Thankfully, the registry project defines an interface for storage drivers and even ships with one for [S3](https://github.com/dotcloud/docker-registry/blob/master/docker_registry/drivers/s3.py) and 

In this post, I'll show you how to configure the [OpenStack Swift registry storage driver](https://github.com/bacongobbler/docker-registry-driver-swift) so that it works with [IBM SoftLayer Object Storage](https://sldn.softlayer.com/reference/objectstorageapi). At the end of the post, you'll have a registry container running on a SoftLayer VM and persisting Docker repositories in SoftLayer Object Storage. I won't cover adding authentication to your registry, but the result can still prove useful in a secure environment.

In the first three sections, I'll describe how to setup object storage and deploy a VM using the SoftLayer Control panel. [Skip to building the `registry-swift` image](#build) if you are already familiar with SoftLayer and can't wait to get to the interesting Docker bits.

## Open the Control Panel

Start by visiting the [SoftLayer Control Panel](https://control.softlayer.com/) and logging-in using your account credentials. If you don't have a SoftLayer account and want to try the steps in this tutorial, you can get a public cloud instance [free for 30 days](https://www.softlayer.com/promo/freeCloud) to run the registry. However, you'll need to pay for object storage.

## Setup Object Storage

If you haven't already, order object storage by clicking the *Storage* drop down, selecting *Object Storage*, and then clicking *Order Object Storage*. Review and accept the storage rates. 

When notified that object storage is available for your account, return to the object storage page and select a data center to host the content of your registry. On the data center page, click the *View Credentials* link and note the private authentication endpoint URL, username, and API key for your account. You'll need them to configure the Docker registry.

Finally, click the *Add Container* link. Give your container the name *docker-registry* and click OK.

## Provision a VM

Next visit the *Devices* drop down, select *Device List*, and click the *Order Devices* link. Pick an hourly virtual server instance and configure it as follows:

1. Select any data center you wish.
2. Choose the Ubuntu 14.04 minimal install (64-bit).
3. Click *Continue Your Order*.
4. Put the following URL in the *Provision scripts* URL box. It installs the latest stable version of Docker from the Docker, Inc. apt-get repository when SoftLayer provisions your VM.
    * https://gist.githubusercontent.com/parente/025dcb2b9400a12d1a9f/raw/d12e88d9c38d71d6123516526eea45c06a7a3d9f/install_latest_docker.sh
5. Choose a public SSH key to add to your VM. (If you don't have one in your account, you can use root password generated when you order your VM for this experiment.)
6. Give your server any host and domain name you wish. (You'll be using its public IP address.)
7. Read and accept the *Terms and Conditions*.
8. Click *Finalize Your Order*.

When your VM is ready, get its public IP address from the *Devices &rarr; Device List*. If you configured it with a public key, use the corresponding private key to SSH into it as the root user. If not, use the generated root password also shown in the *Device List* entry for your instance.

```bash
me@local$ ssh -i ~/.ssh/mykey.pem root@208.43.1.1
```

<div id='build'></div>

## Build a `registry-swift` Image

The official registry container image does not include the Swift storage driver. Nor does it include an option in the sample configuration to override the driver's `swift_auth_version` from its default value of `2`. You need both to work with SoftLayer Object Storage. You can get both by building your own image starting from the official registry image.

On your VM, create a `Dockerfile` and fill it with the following commands.

```bash
# start from a registry release known to work
FROM registry:0.7.3
# get the swift driver for the registry
RUN pip install docker-registry-driver-swift==0.0.1
# SoftLayer uses v1 auth and the sample config doesn't have an option 
# for it so inject one
RUN sed -i '91i\    swift_auth_version: _env:OS_AUTH_VERSION' /docker-registry/config/config_sample.yml
```

Build the Dockerfile like so, replacing `parente` with your Docker username.

```bash
root@vm$ docker build -t parente/registry-swift:0.7.3 .
```

## Run a `registry-swift` Container

With the image in hand, you're ready to launch an instance. Doing so requires that you set quite a few options which I explain after the command below:

```bash
root@vm$ docker run -it -d \
    -e SETTINGS_FLAVOR=swift \
    -e OS_AUTH_URL='https://dal05.objectstorage.service.networklayer.com/auth/v1.0' \
    -e OS_AUTH_VERSION=1 \
    -e OS_USERNAME='my_master_account:my_account' \
    -e OS_PASSWORD='my_api_key' \
    -e OS_CONTAINER='docker-registry' \
    -e GUNICORN_WORKERS=8 \
    -p 127.0.0.1:5000:5000 \
    parente/registry:0.7.3
```

* Set `SETTINGS_FLAVOR=swift` to use the Swift storage driver. 
* Set `OS_AUTH_URL` to the private object storage authentication endpoint you noted earlier.
* Set `OS_AUTH_VERSION=1` to match the version used by SoftLayer.
* Set `OS_USERNAME` to the object storage username you noted earlier.
* Set `OS_PASSWORD` to the object Ssorage API key you noted earlier.`
* Set `OS_CONTAINER=docker-registry`, the name of the object storage container you created earlier.
* Optionally, set `GUNICORN_WORKERS` to the number of Flask workers you want the registry to run, overriding the default of `4`.
* Set the interface and port on which the registry should listen. Above, I've set it to listen on localhost only for demo purposes. You could, for example, set it to listen on the private IP of the VM (i.e., `-p 10.108.66.125:5000:5000`) or even all interfaces to allow public access (i.e., `-p 5000:5000`).
* Finally, remember to change the `parente` to match the username name you used when building your image. 

## Push to Test

With the registry running, you can now test it by pushing something to it. Since you have the registry image you just built on hand, you can use that. First, tag it with the registry IP and port as a prefix, again replacing `parente` with your username.

```bash
root@vm$ docker tag parente/registry-swift:0.7.3 127.0.0.1:5000/parente/registry-swift:0.7.3
```

Now push it.

```bash
root@vm$ docker push 127.0.0.1:5000/parente/registry-swift:0.7.3
```

If all goes well, you should should see the results of the push in the `docker-registry` container in the *Object Storage* control panel. Because the registry stores all Docker repository data and metadata in the storage layer, you can kill, restart, and migrate your registry Docker container at will. 

## Going Further

Since the registry runs in a Docker container, you can easily run multiple instances for your many projects, each one configured to persist in a separate object storage container. You might also try running multiple instances configured with the same storage container name, say for better scalability, though I have not tested what happens in concurrent overwrite scenarios in such a configuration. (Please let me know if you do.) Finally, you can front your registry with a web proxy supporting basic auth to enable select users to push to your registry.