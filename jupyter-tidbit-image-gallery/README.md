### Summary

JupyterLab and Jupyter Notebook can display HTML-embedded images in notebook documents. You can use
the `IPython.display.HTML` class to structure these images into a basic image gallery.

### Example

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gist/parente/691d150c934b89ce744b5d54103d7f1e/master?filepath=gallery.ipynb)

The notebook below defines a `gallery()` function that accepts a list of image URLs, local image
file paths, or bytes in memory. The function displays the images from left-to-right, top-to-bottom
in the notebook. An optional `max_height` parameter scales all images to the same height to create
more regular looking rows.

The notebook includes two demos of the function output.

### Why is this useful?

You may find a gallery view useful when you need to visually scan a large set of images. The
horizontal layout helps reduce notebook scrolling. The fixed height option lets you pack more images
on the screen at once and spot coarse differences.
