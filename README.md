### Summary

[Many modern web browsers](https://caniuse.com/#feat=speech-synthesis) provide a speech synthesis API for JavaScript.
You can write and invoke a function to have your notebook speak when it finishes executing certain cells, whether 
you're running it in JupyterLab (>=0.34) or classic Jupyter Notebook.

```python
def speak(text):
    from IPython.display import Javascript as js, clear_output
    # Escape single quotes
    text = text.replace("'", r"\'")
    display(js('''
    if(window.speechSynthesis) {{
        var synth = window.speechSynthesis;
        synth.speak(new window.SpeechSynthesisUtterance('{text}'));
    }}
    '''.format(text=text)))
    # Clear the JS so that the notebook doesn't speak again when reopened/refreshed
    clear_output(False)
```

### Example

* [![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gist/parente/41a13f4c8fa6165d345cc7703be291a3/master?filepath=demo.ipynb) (Jupyter Notebook)
* [![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gist/parente/41a13f4c8fa6165d345cc7703be291a3/master?urlpath=lab/tree/demo.ipynb) (JupyterLab)

When I open the `demo.ipynb` notebook below and `Run All` cells, I hear the notebook speak aloud when it finishes
executing the first and second loops.

### Why is this useful?

You can add notifications at select locations in your notebook to report execution progress even while you're not
looking at the notebook

### Alternatives

You can also use the `%%javascript` cell magic to achieve the same net effect in Jupyter Notebook. 

```javascript
%%javascript
if(window.speechSynthesis) {{
    var synth = window.speechSynthesis;
    synth.speak(new window.SpeechSynthesisUtterance('All done!'));
    setTimeout(this.clear_output.bind(this), 0);
}}
```

However, the same code doesn't properly clear the JS from the notebook document in JupyterLab, 
and the notebook speaks immediately when opened unless you clear the cell output manually.

The [jupyter_contrib_nbextensions project](https://github.com/ipython-contrib/jupyter_contrib_nbextensions/) 
includes a [notify](https://jupyter-contrib-nbextensions.readthedocs.io/en/latest/nbextensions/notify/readme.html) 
extension for Jupyter Notebook which can show desktop popups and play a sounds when unattended notebooks become
idle.
