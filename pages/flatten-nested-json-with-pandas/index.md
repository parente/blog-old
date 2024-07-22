---
title: Flatten Nested JSON with Pandas
date: 2016-06-09
excerpt: I believe the pandas library takes the expression "batteries included" to a whole new level (in a good way). Recent evidence: the pandas.io.json.json_normalize function. It turns an array of nested JSON objects into a flat DataFrame with dotted-namespace column names. It may not seem like much, but I've found it invaluable when working with responses from RESTful APIs.
template: notebook.mako
---

<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>I believe the <a href="http://pandas.pydata.org">pandas</a> library takes the expression "batteries included" to a whole new level (in a good way). Recent evidence: the <a href="http://pandas.pydata.org/pandas-docs/stable/generated/pandas.io.json.json_normalize.html">pandas.io.json.json_normalize</a> function. It turns an array of nested JSON objects into a flat DataFrame with dotted-namespace column names. It may not seem like much, but I've found it invaluable when working with responses from RESTful APIs.</p>
<p>Let me demonstrate. According to the <a href="https://developer.gitter.im/docs/messages-resource">Gitter API docs</a>, the <code>/rooms/:roomid/chatMessages</code> resource has a variety of nested objects and arrays. I'll fetch fifty messages from the <code>jupyter/notebook</code> room using <a href="http://docs.python-requests.org/en/master/">requests</a> and then use pandas to do a bit of counting.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[1]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="kn">import</span> <span class="nn">pandas</span> <span class="k">as</span> <span class="nn">pd</span>
<span class="kn">import</span> <span class="nn">requests</span>
</pre></div>

    </div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>I need an API token to get the messages. I've obscured mine here. You can get your own from the <a href="https://developer.gitter.im/docs/welcome">Gitter Developer page</a> and plug it in as the  bearer token.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[2]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">headers</span> <span class="o">=</span> <span class="p">{</span>
    <span class="s1">&#39;Authorization&#39;</span><span class="p">:</span> <span class="s1">&#39;Bearer XXXXXXXXXXXXXXXXXXXXXXXXXXXXX&#39;</span><span class="p">,</span>
    <span class="s1">&#39;Content-Type&#39;</span><span class="p">:</span> <span class="s1">&#39;application/json&#39;</span>
<span class="p">}</span>
</pre></div>

    </div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>I also need the Gitter <code>roomid</code> for <code>jupyter/notebook</code>. I looked it up out-of-band and pasted it into the URL below to avoid muddying this post with additional steps.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[3]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">resp</span> <span class="o">=</span> <span class="n">requests</span><span class="o">.</span><span class="n">get</span><span class="p">(</span><span class="s1">&#39;https://api.gitter.im/v1/rooms/554d218a15522ed4b3e02126/chatMessages&#39;</span><span class="p">,</span> 
                    <span class="n">headers</span><span class="o">=</span><span class="n">headers</span><span class="p">)</span>
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
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">resp</span><span class="o">.</span><span class="n">raise_for_status</span><span class="p">()</span>
</pre></div>

    </div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>When I look at the first entry in the JSON response, I see that it contains a few keys with array and object values (e.g., <code>fromUser</code>, <code>mentions</code>, <code>meta</code>, etc.)</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[5]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">resp</span><span class="o">.</span><span class="n">json</span><span class="p">()[</span><span class="mi">0</span><span class="p">]</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[5]:</div>

<div class="output_text output_subarea output_execute_result">
<pre>{&#39;fromUser&#39;: {&#39;avatarUrlMedium&#39;: &#39;https://avatars0.githubusercontent.com/u/19606573?v=3&amp;s=128&#39;,
  &#39;avatarUrlSmall&#39;: &#39;https://avatars0.githubusercontent.com/u/19606573?v=3&amp;s=60&#39;,
  &#39;displayName&#39;: &#39;tomVeloso&#39;,
  &#39;gv&#39;: &#39;3&#39;,
  &#39;id&#39;: &#39;574810c4c43b8c6019753f42&#39;,
  &#39;url&#39;: &#39;/tomVeloso&#39;,
  &#39;username&#39;: &#39;tomVeloso&#39;,
  &#39;v&#39;: 1},
 &#39;html&#39;: &#39;&lt;span data-link-type=&#34;mention&#34; data-screen-name=&#34;minrk&#34; class=&#34;mention&#34;&gt;@minrk&lt;/span&gt;  I tried with the above but seam does not work in the sense that the nothing is cleared from the output cell.&#39;,
 &#39;id&#39;: &#39;5755a171e8163f872c4e6a84&#39;,
 &#39;issues&#39;: [],
 &#39;mentions&#39;: [{&#39;screenName&#39;: &#39;minrk&#39;,
   &#39;userId&#39;: &#39;529c6cc9ed5ab0b3bf04d9eb&#39;,
   &#39;userIds&#39;: []}],
 &#39;meta&#39;: [],
 &#39;readBy&#39;: 22,
 &#39;sent&#39;: &#39;2016-06-06T16:14:41.516Z&#39;,
 &#39;text&#39;: &#39;@minrk  I tried with the above but seam does not work in the sense that the nothing is cleared from the output cell.&#39;,
 &#39;unread&#39;: False,
 &#39;urls&#39;: [],
 &#39;v&#39;: 1}</pre>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>Here's what happens when I pass the full list of messages to the <code>json_normalize</code> function.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[6]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">msgs</span> <span class="o">=</span> <span class="n">pd</span><span class="o">.</span><span class="n">io</span><span class="o">.</span><span class="n">json</span><span class="o">.</span><span class="n">json_normalize</span><span class="p">(</span><span class="n">resp</span><span class="o">.</span><span class="n">json</span><span class="p">())</span>
</pre></div>

    </div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>Notice how the properties of the <code>fromUser</code> nested object become column headers with a <code>fromUser.</code> prefix.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[7]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">msgs</span><span class="o">.</span><span class="n">dtypes</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[7]:</div>

<div class="output_text output_subarea output_execute_result">
<pre>editedAt                     object
fromUser.avatarUrlMedium     object
fromUser.avatarUrlSmall      object
fromUser.displayName         object
fromUser.gv                  object
fromUser.id                  object
fromUser.url                 object
fromUser.username            object
fromUser.v                  float64
html                         object
id                           object
issues                       object
mentions                     object
meta                         object
readBy                        int64
sent                         object
text                         object
unread                         bool
urls                         object
v                             int64
dtype: object</pre>
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
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">msgs</span><span class="o">.</span><span class="n">head</span><span class="p">(</span><span class="mi">2</span><span class="p">)</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[8]:</div>

<div class="output_html rendered_html output_subarea output_execute_result">
<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>editedAt</th>
      <th>fromUser.avatarUrlMedium</th>
      <th>fromUser.avatarUrlSmall</th>
      <th>fromUser.displayName</th>
      <th>fromUser.gv</th>
      <th>fromUser.id</th>
      <th>fromUser.url</th>
      <th>fromUser.username</th>
      <th>fromUser.v</th>
      <th>html</th>
      <th>id</th>
      <th>issues</th>
      <th>mentions</th>
      <th>meta</th>
      <th>readBy</th>
      <th>sent</th>
      <th>text</th>
      <th>unread</th>
      <th>urls</th>
      <th>v</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>NaN</td>
      <td>https://avatars0.githubusercontent.com/u/19606...</td>
      <td>https://avatars0.githubusercontent.com/u/19606...</td>
      <td>tomVeloso</td>
      <td>3</td>
      <td>574810c4c43b8c6019753f42</td>
      <td>/tomVeloso</td>
      <td>tomVeloso</td>
      <td>1</td>
      <td>&lt;span data-link-type="mention" data-screen-nam...</td>
      <td>5755a171e8163f872c4e6a84</td>
      <td>[]</td>
      <td>[{'screenName': 'minrk', 'userIds': [], 'userI...</td>
      <td>[]</td>
      <td>22</td>
      <td>2016-06-06T16:14:41.516Z</td>
      <td>@minrk  I tried with the above but seam does n...</td>
      <td>False</td>
      <td>[]</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>NaN</td>
      <td>https://avatars1.githubusercontent.com/u/15192...</td>
      <td>https://avatars1.githubusercontent.com/u/15192...</td>
      <td>Min RK</td>
      <td>3</td>
      <td>529c6cc9ed5ab0b3bf04d9eb</td>
      <td>/minrk</td>
      <td>minrk</td>
      <td>12</td>
      <td>clear_output is a function, you must call it.</td>
      <td>5755b9bf75a601a158b0415d</td>
      <td>[]</td>
      <td>[]</td>
      <td>[]</td>
      <td>22</td>
      <td>2016-06-06T17:58:23.862Z</td>
      <td>clear_output is a function, you must call it.</td>
      <td>False</td>
      <td>[]</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>Also notice how nested arrays are left untouched as rich Python objects stored in columns. For example, here's the first ten values in the <code>mentions</code> column.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[9]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">msgs</span><span class="o">.</span><span class="n">mentions</span><span class="o">.</span><span class="n">head</span><span class="p">(</span><span class="mi">10</span><span class="p">)</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[9]:</div>

<div class="output_text output_subarea output_execute_result">
<pre>0    [{&#39;screenName&#39;: &#39;minrk&#39;, &#39;userIds&#39;: [], &#39;userI...
1                                                   []
2    [{&#39;screenName&#39;: &#39;minrk&#39;, &#39;userIds&#39;: [], &#39;userI...
3    [{&#39;screenName&#39;: &#39;minrk&#39;, &#39;userIds&#39;: [], &#39;userI...
4    [{&#39;screenName&#39;: &#39;epifanio&#39;, &#39;userIds&#39;: [], &#39;us...
5                                                   []
6    [{&#39;screenName&#39;: &#39;sccolbert&#39;, &#39;userIds&#39;: [], &#39;u...
7    [{&#39;screenName&#39;: &#39;jasongrout&#39;, &#39;userIds&#39;: [], &#39;...
8    [{&#39;screenName&#39;: &#39;minrk&#39;, &#39;userIds&#39;: [], &#39;userI...
9                                                   []
Name: mentions, dtype: object</pre>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>I can leave these lists as column values and <code>apply</code> functions to them. For example, I can compute the frequency of mentions per message easily with the data in this form.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[10]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">msgs</span><span class="o">.</span><span class="n">mentions</span><span class="o">.</span><span class="n">apply</span><span class="p">(</span><span class="k">lambda</span> <span class="n">mentions</span><span class="p">:</span> <span class="nb">len</span><span class="p">(</span><span class="n">mentions</span><span class="p">))</span><span class="o">.</span><span class="n">value_counts</span><span class="p">()</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[10]:</div>

<div class="output_text output_subarea output_execute_result">
<pre>0    36
1    12
4     1
3     1
Name: mentions, dtype: int64</pre>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>Alternatively, I can apply the <code>json_normalize</code> function to the <code>mentions</code> key in each entry in the original API response to get another DataFrame.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[11]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">mentions</span> <span class="o">=</span> <span class="n">pd</span><span class="o">.</span><span class="n">io</span><span class="o">.</span><span class="n">json</span><span class="o">.</span><span class="n">json_normalize</span><span class="p">(</span><span class="n">resp</span><span class="o">.</span><span class="n">json</span><span class="p">(),</span> <span class="n">record_path</span><span class="o">=</span><span class="s1">&#39;mentions&#39;</span><span class="p">)</span>
<span class="n">mentions</span><span class="o">.</span><span class="n">head</span><span class="p">()</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[11]:</div>

<div class="output_html rendered_html output_subarea output_execute_result">
<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>announcement</th>
      <th>group</th>
      <th>screenName</th>
      <th>userId</th>
      <th>userIds</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>minrk</td>
      <td>529c6cc9ed5ab0b3bf04d9eb</td>
      <td>[]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>minrk</td>
      <td>529c6cc9ed5ab0b3bf04d9eb</td>
      <td>[]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>minrk</td>
      <td>529c6cc9ed5ab0b3bf04d9eb</td>
      <td>[]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>all</td>
      <td>NaN</td>
      <td>[]</td>
    </tr>
    <tr>
      <th>4</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>minrk</td>
      <td>529c6cc9ed5ab0b3bf04d9eb</td>
      <td>[]</td>
    </tr>
  </tbody>
</table>
</div>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>I can compute the distribution of mentions per username more easily with this DataFrame than with the original, for example.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[12]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">mentions</span><span class="o">.</span><span class="n">screenName</span><span class="o">.</span><span class="n">value_counts</span><span class="p">()</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[12]:</div>

<div class="output_text output_subarea output_execute_result">
<pre>minrk          7
jasongrout     3
epifanio       2
all            2
blink1073      1
sccolbert      1
afshin         1
mingsterism    1
ellisonbg      1
Name: screenName, dtype: int64</pre>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>I can also apply the <code>json_normalize</code> function to <code>mentions</code> while retaining other metadata from the original response, such as the message <code>id</code>.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[13]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">mentions_with_id</span> <span class="o">=</span> <span class="n">pd</span><span class="o">.</span><span class="n">io</span><span class="o">.</span><span class="n">json</span><span class="o">.</span><span class="n">json_normalize</span><span class="p">(</span><span class="n">resp</span><span class="o">.</span><span class="n">json</span><span class="p">(),</span> <span class="n">record_path</span><span class="o">=</span><span class="s1">&#39;mentions&#39;</span><span class="p">,</span> <span class="n">meta</span><span class="o">=</span><span class="s1">&#39;id&#39;</span><span class="p">,</span>
                                     <span class="n">record_prefix</span><span class="o">=</span><span class="s1">&#39;mentions.&#39;</span><span class="p">)</span>
<span class="n">mentions_with_id</span><span class="o">.</span><span class="n">head</span><span class="p">()</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[13]:</div>

<div class="output_html rendered_html output_subarea output_execute_result">
<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>mentions.announcement</th>
      <th>mentions.group</th>
      <th>mentions.screenName</th>
      <th>mentions.userId</th>
      <th>mentions.userIds</th>
      <th>id</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>minrk</td>
      <td>529c6cc9ed5ab0b3bf04d9eb</td>
      <td>[]</td>
      <td>5755a171e8163f872c4e6a84</td>
    </tr>
    <tr>
      <th>1</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>minrk</td>
      <td>529c6cc9ed5ab0b3bf04d9eb</td>
      <td>[]</td>
      <td>5755bf7a17856dc5179ac226</td>
    </tr>
    <tr>
      <th>2</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>minrk</td>
      <td>529c6cc9ed5ab0b3bf04d9eb</td>
      <td>[]</td>
      <td>5755d43d92fc7c915f57444d</td>
    </tr>
    <tr>
      <th>3</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>all</td>
      <td>NaN</td>
      <td>[]</td>
      <td>5755d43d92fc7c915f57444d</td>
    </tr>
    <tr>
      <th>4</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>minrk</td>
      <td>529c6cc9ed5ab0b3bf04d9eb</td>
      <td>[]</td>
      <td>5755d43d92fc7c915f57444d</td>
    </tr>
  </tbody>
</table>
</div>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>With the message <code>id</code> intact, I can merge the <code>mentions</code> and <code>msgs</code> DataFrames. Here, I do an <code>inner</code> merge to create rows for messages that have at least one mention.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[14]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">mention_msgs</span> <span class="o">=</span> <span class="n">pd</span><span class="o">.</span><span class="n">merge</span><span class="p">(</span><span class="n">mentions_with_id</span><span class="p">,</span> <span class="n">msgs</span><span class="p">,</span> <span class="n">how</span><span class="o">=</span><span class="s1">&#39;inner&#39;</span><span class="p">,</span> <span class="n">on</span><span class="o">=</span><span class="s1">&#39;id&#39;</span><span class="p">)</span>
</pre></div>

    </div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>With the merged DataFrame, I can readily compute the distribution of sender-receiver username pairs, for example.</p>

</div>
</div>
</div>
<div class="cell border-box-sizing code_cell rendered">
<div class="input">
<div class="prompt input_prompt">In&nbsp;[15]:</div>
<div class="inner_cell">
    <div class="input_area">
<div class=" highlight hl-ipython3"><pre><span></span><span class="n">mention_msgs</span><span class="o">.</span><span class="n">apply</span><span class="p">(</span><span class="k">lambda</span> <span class="n">df</span><span class="p">:</span> <span class="p">(</span><span class="n">df</span><span class="p">[</span><span class="s1">&#39;fromUser.username&#39;</span><span class="p">],</span> <span class="n">df</span><span class="p">[</span><span class="s1">&#39;mentions.screenName&#39;</span><span class="p">]),</span> <span class="n">axis</span><span class="o">=</span><span class="mi">1</span><span class="p">)</span><span class="o">.</span><span class="n">value_counts</span><span class="p">()</span>
</pre></div>

    </div>

</div>
</div>

<div class="output_wrapper">
<div class="output">

<div class="output_area">

    <div class="prompt output_prompt">Out[15]:</div>

<div class="output_text output_subarea output_execute_result">
<pre>(mingsterism, minrk)       3
(epifanio, minrk)          2
(sccolbert, jasongrout)    1
(epifanio, all)            1
(afshin, jasongrout)       1
(jasongrout, afshin)       1
(jasongrout, ellisonbg)    1
(epifanio, jasongrout)     1
(jasongrout, blink1073)    1
(tomVeloso, minrk)         1
(fperez, minrk)            1
(JamiesHQ, all)            1
(minrk, epifanio)          1
(jasongrout, sccolbert)    1
(jasongrout, epifanio)     1
(minrk, mingsterism)       1
dtype: int64</pre>
</div>

</div>

</div>
</div>

</div>
<div class="cell border-box-sizing text_cell rendered"><div class="prompt input_prompt">
</div><div class="inner_cell">
<div class="text_cell_render border-box-sizing rendered_html">
<p>See the <a href="http://pandas.pydata.org/pandas-docs/stable/generated/pandas.io.json.json_normalize.html">pandas documentation</a> for complete information about the <code>json_normalize</code> function. You can also <a href="https://github.com/parente/blog/blob/master/pages/flatten-nested-json-with-pandas/index.ipynb">download this post as a Jupyter Notebook</a> and run it yourself.</p>

</div>
</div>
</div>
