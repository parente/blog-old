### Summary

You can launch a temporary [Jupyter Notebook](https://github.com/jupyter/notebook) server in the cloud with any pip or conda packaged libraries preinstalled using the [GitHub Gist](https://gist.github.com) and [Binder](https://mybinder.org) web UIs.

1. Visit [https://gist.github.com/](https://gist.github.com/).
2. Click *New Gist* in the top right
3. Enter `requirements.txt` as the filename (or `environment.yaml` if you prefer conda). 
4. Add libraries you wish to use in your notebook server (e.g., `pandas`, `altair`).
5. Click *Create Public Gist*.
6. Visit [https://mybinder.org/](https://mybinder.org/).
7. Select *Gist* from the dropdown.
8. Enter your gist `username/gistid`.
9. Click *Launch*.

### Example

When I add the `requirements.txt` file below to a new gist, enter `parente/3675d82eae802db2c011037033d614a5` into the binder web UI, and click the launch, here's the result:

[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gist/parente/3675d82eae802db2c011037033d614a5/master)
<h4 class="embedFilename"><i class="fa fa-file" aria-hidden="true"></i> requirements.txt</h4>
```
pandas
altair
```