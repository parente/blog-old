---
title: Jupyter Tidbit: %run your ipynb file
date: 2018-08-21
excerpt: The %run magic provided by IPython not only supports the execution of regular Python scripts, it also runs Jupyter Notebook files (.ipynb).
author_comment: This post originates from a <a href="https://gist.github.com/parente/8932dac5a430dba4c17f49af16568da7">gist</a> that supports comments, forks, and execution in <a href="https://mybinder.org/v2/gist/parente/8932dac5a430dba4c17f49af16568da7/master">binder</a>.
template: notebook.mako
legacy: true
---

<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<h3 id="Summary">Summary<a class="anchor-link" href="#Summary">&#182;</a></h3><p>The <code>%run</code> magic provided by IPython not only supports the execution of regular Python scripts, it also runs Jupyter Notebook files (.ipynb).</p>
<h3 id="Example">Example<a class="anchor-link" href="#Example">&#182;</a></h3><p><a href="https://mybinder.org/v2/gist/parente/8932dac5a430dba4c17f49af16568da7/master"><img src="https://mybinder.org/badge.svg" alt="Binder"></a></p>
<p>The <code>run_demo.ipynb</code> notebook below uses <code>%run</code> to execute all of the cells in <code>reusable_stuff.ipynb</code>. Once it does, both globals defined in <code>reusable_stuff</code> are available in <code>run_demo</code> for use.</p>
<h3 id="Why-is-this-useful?">Why is this useful?<a class="anchor-link" href="#Why-is-this-useful?">&#182;</a></h3><p>You can maintain a handy notebook of useful recipes that you can than <code>%run</code> to reuse in other notebooks. Just remember that this setup can <em>decrease</em> the reproducibility of your work unless you provide your recipe notebook alongside any notebook that uses it when you share.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<h4 class="embedFilename"><i class="fa fa-file" aria-hidden="true"></i> reusable_stuff.ipynb</h4>
</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[1]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="k">def</span> <span class="nf">super_useful_thing</span><span class="p">():</span>
    <span class="k">return</span> <span class="s1">&#39;not really&#39;</span>
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
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">x</span> <span class="o">=</span> <span class="s1">&#39;from reusable stuff&#39;</span>
</pre></div>

    </div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<h4 class="embedFilename"><i class="fa fa-file" aria-hidden="true"></i> run_demo.ipynb</h4>
</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[10]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">x</span> <span class="o">=</span> <span class="mi">1</span>
</pre></div>

    </div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>Execute the cells in <code>reusable_stuff.ipynb</code> in the current kernel namespace.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[11]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="o">%</span><span class="n">run</span> <span class="n">reusable_stuff</span><span class="o">.</span><span class="n">ipynb</span>
</pre></div>

    </div>

</div>
</div>

</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[12]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">super_useful_thing</span><span class="p">()</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[12]:</div>

<div class="output_text output_subarea output_execute_result">
<pre>&#39;not really&#39;</pre>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[13]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">x</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[13]:</div>

<div class="output_text output_subarea output_execute_result">
<pre>&#39;from reusable stuff&#39;</pre>
</div>

</div>

</div>
</div>

</div>
