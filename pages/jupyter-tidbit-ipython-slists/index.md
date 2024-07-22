---
title: Jupyter Tidbit: IPython's ! returns an SList
date: 2018-09-15
excerpt: IPython shell assignment (the ! operator) evaluates a command using the local shell (e.g., bash) and returns a string list (IPython.utils.text.SList). An SList is a list-like object containing "chunks" of stdout and stderr, properties for accessing those chunks in different forms, and convenience methods for operating on them.
author_comment: This post originates from a <a href="https://gist.github.com/parente/b6ee0efe141822dfa18b6feeda0a45e5">gist</a> that supports comments, forks, and execution in <a href="https://mybinder.org/v2/gist/parente/b6ee0efe141822dfa18b6feeda0a45e5/master">binder</a>.
template: notebook.mako
---

### Summary

IPython _shell assignment_ (the `!` operator) evaluates a command using the local shell (e.g., `bash`) and returns a _string list_ (`IPython.utils.text.SList`). An `SList` is a list-like object containing "chunks" of stdout and stderr, properties for accessing those chunks in different forms, and convenience methods for operating on them.

### Example

[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gist/parente/b6ee0efe141822dfa18b6feeda0a45e5/master?filepath=SList.ipynb)

The `SList.ipynb` notebook below uses `SList` properties to access the output of a shell command as a list-like of strings, a newline-separated string, a space-separated string, and a list of `pathlib.Path` objects. The notebook then uses the `SList.fields()` and `SList.grep()` methods to extract columns from and search command output.

### Why is this useful?

You can take advantage of the properties and methods of an `SList` to transform shell output into forms more amenable to further operations in Python.

### For more information

See the [IPython documentation about Shell Assignment](https://ipython.readthedocs.io/en/stable/interactive/python-ipython-diff.html#shell-assignment) for examples of executing shell commands with optional Python values as inputs. See the [IPython documentation about String Lists](https://ipython.readthedocs.io/en/stable/interactive/shell.html?highlight=slist#string-lists) for additional demontrations of the utility of `SLists`.

<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<h4 class="embedFilename"><i class="fa fa-file" aria-hidden="true"></i> SList.ipynb</h4>
</div>
</div>
</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>Start with a simple <code>ls</code> command.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[1]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">ls</span> <span class="o">=</span> <span class="err">!</span><span class="n">ls</span>
</pre></div>

    </div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>Note that the return type is not a simple <code>list</code>.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[2]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="nb">type</span><span class="p">(</span><span class="n">ls</span><span class="p">)</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[2]:</div>

<div class="output_text output_subarea output_execute_result">
<pre>IPython.utils.text.SList</pre>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>It is an <code>SList</code>, a list-like object that contains "chunks" of <code>stdout</code> and <code>stderr</code>, properties for accessing those chunks in different forms, and convenience methods for operating on them.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[3]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">ls</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[3]:</div>

<div class="output_text output_subarea output_execute_result">
<pre>[&#39;conda-bld&#39;, &#39;README.md&#39;, &#39;requirements.txt&#39;, &#39;SList.ipynb&#39;]</pre>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>There are many ways to refer to the output from an <code>SList</code> as a list-like of strings.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[4]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">ls</span> <span class="o">==</span> <span class="n">ls</span><span class="o">.</span><span class="n">get_list</span><span class="p">()</span> <span class="o">==</span> <span class="n">ls</span><span class="o">.</span><span class="n">list</span> <span class="o">==</span> <span class="n">ls</span><span class="o">.</span><span class="n">l</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[4]:</div>

<div class="output_text output_subarea output_execute_result">
<pre>True</pre>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>Some properties also return the output as a newline delimited string.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[5]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="nb">print</span><span class="p">(</span><span class="n">ls</span><span class="o">.</span><span class="n">nlstr</span><span class="p">)</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt"></div>

<div class="output_subarea output_stream output_stdout output_text">
<pre>conda-bld
README.md
requirements.txt
SList.ipynb
</pre>
</div>
</div>

</div>
</div>

</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[6]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">ls</span><span class="o">.</span><span class="n">get_nlstr</span><span class="p">()</span> <span class="o">==</span> <span class="n">ls</span><span class="o">.</span><span class="n">nlstr</span> <span class="o">==</span> <span class="n">ls</span><span class="o">.</span><span class="n">n</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[6]:</div>

<div class="output_text output_subarea output_execute_result">
<pre>True</pre>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>Other properties return the output as a space separated string.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[7]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="nb">print</span><span class="p">(</span><span class="n">ls</span><span class="o">.</span><span class="n">spstr</span><span class="p">)</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt"></div>

<div class="output_subarea output_stream output_stdout output_text">
<pre>conda-bld README.md requirements.txt SList.ipynb
</pre>
</div>
</div>

</div>
</div>

</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[8]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">ls</span><span class="o">.</span><span class="n">get_spstr</span><span class="p">()</span> <span class="o">==</span> <span class="n">ls</span><span class="o">.</span><span class="n">spstr</span> <span class="o">==</span> <span class="n">ls</span><span class="o">.</span><span class="n">s</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[8]:</div>

<div class="output_text output_subarea output_execute_result">
<pre>True</pre>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>Still other properties return the output as a list of <code>pathlib.Path</code> instances.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[9]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">ls</span><span class="o">.</span><span class="n">paths</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[9]:</div>

<div class="output_text output_subarea output_execute_result">
<pre>[PosixPath(&#39;conda-bld&#39;),
 PosixPath(&#39;README.md&#39;),
 PosixPath(&#39;requirements.txt&#39;),
 PosixPath(&#39;SList.ipynb&#39;)]</pre>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[10]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">ls</span><span class="o">.</span><span class="n">get_paths</span><span class="p">()</span> <span class="o">==</span> <span class="n">ls</span><span class="o">.</span><span class="n">paths</span> <span class="o">==</span> <span class="n">ls</span><span class="o">.</span><span class="n">p</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[10]:</div>

<div class="output_text output_subarea output_execute_result">
<pre>True</pre>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[11]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="kn">import</span> <span class="nn">pathlib</span>
<span class="nb">isinstance</span><span class="p">(</span><span class="n">ls</span><span class="o">.</span><span class="n">paths</span><span class="p">[</span><span class="mi">0</span><span class="p">],</span> <span class="n">pathlib</span><span class="o">.</span><span class="n">Path</span><span class="p">)</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[11]:</div>

<div class="output_text output_subarea output_execute_result">
<pre>True</pre>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>These are convenient for performing further path operations in Python.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[12]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="p">[</span><span class="n">p</span><span class="o">.</span><span class="n">is_dir</span><span class="p">()</span> <span class="k">for</span> <span class="n">p</span> <span class="ow">in</span> <span class="n">ls</span><span class="o">.</span><span class="n">paths</span><span class="p">]</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[12]:</div>

<div class="output_text output_subarea output_execute_result">
<pre>[True, False, False, False]</pre>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p><code>SList</code> objects expose a <code>fields()</code> method.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[13]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">df</span> <span class="o">=</span> <span class="err">!</span><span class="n">df</span> <span class="o">-</span><span class="n">h</span>
</pre></div>

    </div>

</div>
</div>

</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[14]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">df</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[14]:</div>

<div class="output_text output_subarea output_execute_result">
<pre>[&#39;Filesystem      Size  Used Avail Use% Mounted on&#39;,
 &#39;overlay         981G  577G  404G  59% /&#39;,
 &#39;tmpfs            26G     0   26G   0% /dev&#39;,
 &#39;tmpfs            26G     0   26G   0% /sys/fs/cgroup&#39;,
 &#39;/dev/sda1       981G  577G  404G  59% /etc/hosts&#39;,
 &#39;shm              64M     0   64M   0% /dev/shm&#39;,
 &#39;tmpfs            26G     0   26G   0% /sys/firmware&#39;]</pre>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p><code>fields</code> splits the output into whitespace delimited columns and returns the values of columns, specified by their indices, as space-separated strings.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[15]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">df</span><span class="o">.</span><span class="n">fields</span><span class="p">(</span><span class="mi">0</span><span class="p">,</span><span class="mi">4</span><span class="p">)</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[15]:</div>

<div class="output_text output_subarea output_execute_result">
<pre>[&#39;Filesystem Use%&#39;,
 &#39;overlay 59%&#39;,
 &#39;tmpfs 0%&#39;,
 &#39;tmpfs 0%&#39;,
 &#39;/dev/sda1 59%&#39;,
 &#39;shm 0%&#39;,
 &#39;tmpfs 0%&#39;]</pre>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p><code>SList</code> objects also expose a <code>grep()</code> method. <code>grep</code> evaluates a regular expression or callable against all elements of the <code>SList</code> or a whitespace delimited column in each element.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[16]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">df</span><span class="o">.</span><span class="n">grep</span><span class="p">(</span><span class="s1">&#39;dev&#39;</span><span class="p">,</span> <span class="n">field</span><span class="o">=</span><span class="mi">5</span><span class="p">)</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[16]:</div>

<div class="output_text output_subarea output_execute_result">
<pre>[&#39;tmpfs            26G     0   26G   0% /dev&#39;,
 &#39;shm              64M     0   64M   0% /dev/shm&#39;]</pre>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p><code>grep(prune=True)</code> turns the grep into a filtering operation instead of a matching operation.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[17]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">hosts</span> <span class="o">=</span> <span class="err">!</span><span class="n">cat</span> <span class="o">/</span><span class="n">etc</span><span class="o">/</span><span class="n">hosts</span>
</pre></div>

    </div>

</div>
</div>

</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[18]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="nb">print</span><span class="p">(</span><span class="n">hosts</span><span class="o">.</span><span class="n">n</span><span class="p">)</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt"></div>

<div class="output_subarea output_stream output_stdout output_text">
<pre># Kubernetes-managed hosts file.
127.0.0.1	localhost
::1	localhost ip6-localhost ip6-loopback
fe00::0	ip6-localnet
fe00::0	ip6-mcastprefix
fe00::1	ip6-allnodes
fe00::2	ip6-allrouters
10.12.9.251	jupyter-3675d82eae802db2c011037033d614a5-2dlwedcif3
</pre>
</div>
</div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>The return value of <code>grep</code> (and <code>fields</code>) is another <code>SList</code> supporting all of the features noted above.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[19]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="nb">print</span><span class="p">(</span><span class="n">hosts</span><span class="o">.</span><span class="n">grep</span><span class="p">(</span><span class="s1">&#39;ip6&#39;</span><span class="p">,</span> <span class="n">prune</span><span class="o">=</span><span class="kc">True</span><span class="p">)</span><span class="o">.</span><span class="n">n</span><span class="p">)</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt"></div>

<div class="output_subarea output_stream output_stdout output_text">
<pre># Kubernetes-managed hosts file.
127.0.0.1	localhost
10.12.9.251	jupyter-3675d82eae802db2c011037033d614a5-2dlwedcif3
</pre>
</div>
</div>

</div>
</div>

</div>
