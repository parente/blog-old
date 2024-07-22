---
title: Jupyter Tidbit: Display handles
date: 2018-11-03
excerpt: IPython's display() function can return a DisplayHandle object. You can use a DisplayHandle to update the output of one cell from any other cell in a Jupyter Notebook.
author_comment: This post originates from a <a href="https://gist.github.com/parente/5cab90125191d523e76fcb398f30da05">gist</a> that supports comments, forks, and execution in <a href="https://mybinder.org/v2/gist/parente/5cab90125191d523e76fcb398f30da05/master">binder</a>.
template: notebook.mako
---

### Summary

IPython's `display()` function can return a `DisplayHandle` object. You can use a `DisplayHandle` to update the output of one cell from any other cell in a Jupyter Notebook.

### Example

[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gist/parente/5cab90125191d523e76fcb398f30da05/master?filepath=display_handle.ipynb)

The `display_handle.ipynb` notebook below calls `display(display_id=True)` to get a display handle instance. It then uses the `DisplayHandle.display` method to show some initial, static Markdown. Later, in a different cell, it calls `DisplayHandle.update` in a loop to show a range of emoji characters.

### Why is this useful?

You can use display handles to redraw matplotlib plots, re-render DataFrame tables, print log file updates, etc. from code executed anywhere in the notebook.

<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<h4 class="embedFilename"><i class="fa fa-file" aria-hidden="true"></i> display_handle.ipynb</h4>
</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[&nbsp;]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="kn">import</span> <span class="nn">itertools</span>
<span class="kn">import</span> <span class="nn">time</span>

<span class="kn">from</span> <span class="nn">IPython.display</span> <span class="k">import</span> <span class="n">Markdown</span>

</pre></div>

    </div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>Make a display handle.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[&nbsp;]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">dh</span> <span class="o">=</span> <span class="n">display</span><span class="p">(</span><span class="n">display_id</span><span class="o">=</span><span class="kc">True</span><span class="p">)</span>
</pre></div>

    </div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>Show some Markdown (or plain text, or a plot, or ...)</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[&nbsp;]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">display</span><span class="p">(</span><span class="n">Markdown</span><span class="p">(</span><span class="s1">&#39;# Display Update Fun&#39;</span><span class="p">))</span>
<span class="n">dh</span><span class="o">.</span><span class="n">display</span><span class="p">(</span><span class="n">Markdown</span><span class="p">(</span><span class="s1">&#39;&#39;</span><span class="p">))</span>
</pre></div>

    </div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>Update the display above.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[&nbsp;]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="k">for</span> <span class="n">i</span> <span class="ow">in</span> <span class="n">itertools</span><span class="o">.</span><span class="n">cycle</span><span class="p">(</span><span class="nb">range</span><span class="p">(</span><span class="mh">0x1F600</span><span class="p">,</span> <span class="mh">0x1F650</span><span class="p">)):</span>
    <span class="n">dh</span><span class="o">.</span><span class="n">update</span><span class="p">(</span><span class="n">Markdown</span><span class="p">(</span><span class="n">f</span><span class="s1">&#39;## &amp;#</span><span class="si">{i}</span><span class="s1">; {hex(i)}&#39;</span><span class="p">))</span>
    <span class="n">time</span><span class="o">.</span><span class="n">sleep</span><span class="p">(</span><span class="mf">0.5</span><span class="p">)</span>
</pre></div>

    </div>

</div>
</div>

</div>
