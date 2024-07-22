---
title: Jupyter Tidbit: Run and say "done!"
date: 2018-08-27
excerpt: Many modern web browsers provide a speech synthesis API for JavaScript.You can write and invoke a function to have your notebook speak when it finishes executing certain cells, whether you're running it in JupyterLab (>=0.34) or classic Jupyter Notebook.
author_comment: This post originates from a <a href="https://gist.github.com/parente/41a13f4c8fa6165d345cc7703be291a3">gist</a> that supports comments, forks, and execution in <a href="https://mybinder.org/v2/gist/parente/41a13f4c8fa6165d345cc7703be291a3/master?filepath=demo.ipynb">binder</a>.
template: notebook.mako
---

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

- [![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gist/parente/41a13f4c8fa6165d345cc7703be291a3/master?filepath=demo.ipynb) (Jupyter Notebook)
- [![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gist/parente/41a13f4c8fa6165d345cc7703be291a3/master?urlpath=lab/tree/demo.ipynb) (JupyterLab)

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

<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<h4 class="embedFilename"><i class="fa fa-file" aria-hidden="true"></i> demo.ipynb</h4>
</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[1]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="k">def</span> <span class="nf">speak</span><span class="p">(</span><span class="n">text</span><span class="p">):</span>
    <span class="kn">from</span> <span class="nn">IPython.display</span> <span class="k">import</span> <span class="n">Javascript</span> <span class="k">as</span> <span class="n">js</span><span class="p">,</span> <span class="n">clear_output</span>
    <span class="c1"># Escape single quotes</span>
    <span class="n">text</span> <span class="o">=</span> <span class="n">text</span><span class="o">.</span><span class="n">replace</span><span class="p">(</span><span class="s2">&quot;&#39;&quot;</span><span class="p">,</span> <span class="sa">r</span><span class="s2">&quot;\&#39;&quot;</span><span class="p">)</span>
    <span class="n">display</span><span class="p">(</span><span class="n">js</span><span class="p">(</span><span class="n">f</span><span class="s1">&#39;&#39;&#39;</span>
<span class="s1">    if(window.speechSynthesis) {{</span>
<span class="s1">        var synth = window.speechSynthesis;</span>
<span class="s1">        synth.speak(new window.SpeechSynthesisUtterance(&#39;</span><span class="si">{text}</span><span class="s1">&#39;));</span>
<span class="s1">    }}</span>
<span class="s1">    &#39;&#39;&#39;</span><span class="p">))</span>
    <span class="c1"># Clear the JS so that the notebook doesn&#39;t speak again when reopened/refreshed</span>
    <span class="n">clear_output</span><span class="p">(</span><span class="kc">False</span><span class="p">)</span>
</pre></div>

    </div>

</div>
</div>

</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[2]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="k">for</span> <span class="n">i</span> <span class="ow">in</span> <span class="nb">range</span><span class="p">(</span><span class="nb">int</span><span class="p">(</span><span class="mf">1e8</span><span class="p">)):</span> <span class="k">pass</span>
<span class="n">speak</span><span class="p">(</span><span class="s2">&quot;I&#39;m done with the first loop.&quot;</span><span class="p">)</span>
</pre></div>

    </div>

</div>
</div>

</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[3]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="k">for</span> <span class="n">i</span> <span class="ow">in</span> <span class="nb">range</span><span class="p">(</span><span class="nb">int</span><span class="p">(</span><span class="mf">1e8</span><span class="p">)):</span> <span class="k">pass</span>
</pre></div>

    </div>

</div>
</div>

</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[4]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">speak</span><span class="p">(</span><span class="s2">&quot;Now I&#39;m really done!&quot;</span><span class="p">)</span>
</pre></div>

    </div>

</div>
</div>

</div>
