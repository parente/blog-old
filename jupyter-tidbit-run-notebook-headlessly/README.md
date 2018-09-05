### Summary

You can use [nbconvert](https://github.com/jupyter/nbconvert) to execute a notebook from the command line (aka headlessly) and store the results in a new notebook file, an HTML file, a PDF, etc. Tools based on nbconvert, like [papermill](https://github.com/nteract/papermill) and [nbflow](https://github.com/jhamrick/nbflow), take this capability a step further and let you easily parameterize and chain notebooks.

### Example

[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gist/parente/67a348b3af9513e512ed700e8f9e5f3c/master?filepath=demo.ipynb)

The command below executes the notebook named `run_me.ipynb` and outputs a new notebook file named `you_ran_me.ipynb` with all cell outputs captured. nbconvert executes the `run_me.ipynb` notebook using the kernel the notebook document declares in its metadata, `python3` in this example.

```bash
jupyter nbconvert --to notebook --execute run_me.ipynb --output you_ran_me
```

### Why is this useful?

You can take a notebook you developed in Jupyter Notebook, JupyterLab, nteract, etc., execute it using a scheduler or workflow tool like cron, Jenkins, Airflow, etc., and capture the same rich output in a notebook document as if you ran it manually. See [Scheduling Notebooks at Netflix](https://medium.com/netflix-techblog/scheduling-notebooks-348e6c14cfd6) for inspiration.