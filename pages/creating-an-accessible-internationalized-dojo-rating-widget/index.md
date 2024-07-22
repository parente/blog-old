---
title: Creating an Accessible Dojo Rating Widget
date: 2009-08-28
---

The widgets in the [Dojo toolkit](http://dojotoolkit.org/), called Dijits, support keyboard navigation, remain visible in high-contrast mode, contain [WAI-ARIA](http://www.w3.org/TR/wai-aria/) markup for assistive technologies, and enable internationalization. This combination of techniques makes Dijits accessible to a wide range of users with disabilities and native locales.

As a developer, you can mimic the techniques used by the Diijit authors to ensure your own widgets are usable by as many people as possible. This tutorial instructs you on how to create such a Dojo widget. The rating widget developed here supports mouse and keyboard input, can be used with CSS turned off, reports its value and bounds via WAI-ARIA to assistive technologies, and has text that can be translated.

For reference, the final, working widget appears in the iframe immediately below this paragraph. Use the Tab key to focus on widget. Then use the arrow keys to change its value.

<iframe src="http://s3.amazonaws.com/mindtrove/mindtrove/examples/rating-demo.html" style="width: 450px; height: 150px;"></iframe>

## Creating a Dev Environment

First, we need to create our development environment. In a web accessible location, create a project folder. Create subdirectories named examples, images, nls, and templates. These will hold the example page for the widget, images used by the widget, translations of the widget strings, and the widget template respectively. Under nls make another folder called es which will hold a sample Spanish translation for the widget.

The final layout of the folders on disk should be the following:

```
project/
  - examples/
  - templates/
  - nls/
    - es/
```

## Creating a Test Page

Now create a file named rating-demo.html in the project/examples/ folder with the content below. This file is the page you will use to test the rating widget. The header of this page includes Dojo from a CDN, registers the info.mindtrove code module, and imports the rating widget. The header also defines styles which the rating widget will use to draw lit and unlit stars in the rating widget. The body of the page has a span tag with declarative markup for the Dojo parser that creates a rating widget with a maximum value of five on page load.

```xml
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Rating Widget Demo</title>
      <link rel="stylesheet" href="http://o.aolcdn.com/dojo/1.5/dojo/resources/dojo.css" />
      <style type="text/css">
      body {
          font-family: sans-serif;
      }
      .ratingOffIcon {
          background-image: url('../images/gray-star.png');
          background-repeat: no-repeat;
          width: 32px;
          height: 32px;
      }
      .ratingOnIcon {
          background-image: url('../images/red-star.png');
          background-repeat: no-repeat;
          width: 32px;
          height: 32px;
       }
    </style>
      <script type="text/javascript">
        djConfig={
          parseOnLoad: true,
          isDebug: false,
          baseUrl: "../../",
          modulePaths: {'info.mindtrove': "mindtrove"}
        };
    </script>
    <script type="text/javascript" src="http://o.aolcdn.com/dojo/1.5/dojo/dojo.xd.js"></script>
    <script type="text/javascript">
      dojo.require("info.mindtrove.Rating");
    </script>
  </head>
  <body>
    <label>Rate this tutorial:
      <span dojoType="info.mindtrove.Rating" maximumValue="5"></span>
    </label>
    <ul>
      <li>Tab to focus on the widget</li>
      <li>Up/right to increase</li>
      <li>Down/left to decrease</li>
      <li>Home to set minimum value</li>
      <li>End to set maximum value</li>
    </ul>
  </body>
</html>
```

## Writing the Language Bundles

Now create a file named rating.js in project/nls/. This file will contain the default translation of human readable text in the rating widget. Insert the following bundle object definition into the file:

```javascript
{
  starsSingular: '${0} star',
  starsPlural: '${0} stars'
}
```

The widget will replace the variables, ${0}, at runtime with a number of stars. The variable is part of the template so that the position of the number with respect to the noun can change depending on the language. (If the strings contained more than one replaceable segment of text, you would use named variables like ${numberOfStars} instead of positional ones to support arbitrary orderings.)

Create another message bundle file named rating.js in the project/nls/es folder and insert the text below. You'll use the Spanish translation in this file to test the internationalization of the rating widget later.

```javascript
{
  starsSingular: '${0} estrella',
  starsPlural: '${0} estrellas'
}
```

<p>Next create a file named <em>Rating.html</em> in <em>project/templates/</em>. This file serves as the starting template for your widget. When Dojo parses the test page, it replaces the <em>span</em> element having attribute <em>dojoType="info.mindtrove.Rating"</em> with the content of the template. Insert the HTML below into the template file:</p>

```javascript
<span
  dojoAttachPoint="box"
  tabindex="0"
  role="slider"
  aria-valuetext="${currentText}"
  aria-valuemin="0"
  aria-valuemax="${maximumValue}"
  aria-valuenow="${currentValue}"
></span>
```

<p>The rating widget template contains just one <em>span</em> element with quite a few attributes. The purpose of each of these attributes is given below:</p>

<dl>
  <dt>dojoAttachPoint="box"</dt>
  <dd>Includes a reference to the <em>span</em> element under the variable name <em>box</em> in the JavaScript widget instance.</dd>
  <dt>tabindex="0"</dt>
  <dd>Tells the browser to include the widget in the <em>Tab</em> key cycle so that it can receive keyboard focus.</dd>
  <dt>role="slider"</dt>
  <dd>Used by assistive technologies as a hint about how users can interact with the control.</dd>
  <dt>aria-valuenow="${currentValue}"</dt>
  <dd>Used by assistive technologies as the current value of the widget.</dd>
  <dt>aria-valuemin="0"</dt>
  <dd>A hint to assistive technologies about the minimum value allowed by the widget.</dd>
  <dt>aria-valuemax="${maximumValue}"</dt>
  <dd>A hint to assistive technologies about the maximum value allowed by the widget.</dd>
  <dt>aria-valuetext="${currentText}"</dt>
  <dd>Used by assistive technologies as a human readable label for the current value.</dd>
</dl>

<p>Some of the attributes values are template variables of the form <em>${x}</em> where <em>x</em> is the name of an instance variable in the rating widget JavaScript class. Dojo replaces these placeholders when it renders the template into the page. For example, Dojo replaces <em>${maximumValue}</em> with the value of <em>this.maximumValue</em> in the JavaScript class at the time of rendering.</p>

<h2>Writing the Widget Class</h2>

<p>Now create a file named <em>Rating.js</em> in the <em>project/</em> folder. Add the following lines at the top of the file to define this module and import other modules the widget will use.</p>

```javascript
dojo.provide("info.mindtrove.Rating");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dojo.string");
dojo.require("dojo.i18n");
dojo.requireLocalization("info.mindtrove", "rating");
```

<p>Under these lines, define an empty shell for the <em>Rating</em> class as shown below. This class derives from the base classes <em>_Widget</em> and <em>_Templated</em> so that it will follow the standard Dijit lifecycle for initialization and destruction.</p>

```javascript
dojo.declare('info.mindtrove.Rating', [dijit._Widget, dijit._Templated], {
  // properties and methods will go here
};
```

<h3>Defining the Widget Properties</h3>

<p>Next define the public properties of the widget and their default values by adding the following code inside the class definition:</p>

```javascript
    // maximum rating value
    maximumValue: 5,
    // initial value
    currentValue: 0,
    // CSS class name to apply to an unlit star
    offIcon: 'ratingOffIcon',
    // CSS class name to apply to a lit star
    onIcon: 'ratingOnIcon',
```

<p>The property values provide defaults for the attributes set on the <em>span</em> element representing the rating widget in your test page. For example, you did not specify the initial value, so it defaults to zero according to these properties.</p>

<h3>Addressing the Template</h3>

<p>Add the following line under the last property in the class to connect the widget class with its template file:</p>

```javascript
templatePath: dojo.moduleUrl('info.mindtrove', 'templates/Rating.html'),
```

<p>The <em>_Templated</em> base classes uses the <em>templatePath</em> variable to locate the template file for this widget. The parameters to the <em>dojo.moduleUrl</em> function are the name of the module containing the widget and the relative path from the module root to the template.</p>

<h3>Loading the Message Bundle</h3>

<p>Continue by adding a method named <em>constructor</em> to the class. Dojo invokes this method when instantiating your class, but after all of the base class constructors run. The code in this method stores a reference to the message bundle object for the user's locale in an instance variable.</p>

```javascript
    constructor: function() {
        this.labels = dojo.i18n.getLocalization('info.mindtrove', 'rating');
    },
```

<h3>Rendering the Template</h3>

<p>Next define a <em>postMixInProperties</em> method in the class. Dojo invokes this method after setting the widget properties to the values specified in the declarative widget markup and just before rendering the widget template for the first time. All of the variables used in the template must be defined as instance variables before this method returns else Dojo will raise an exception. As it happens, all of the variables in the rating widget template are defined by the public properties of the class except for <em>currentText</em>. This method defines that missing instance variable by loading the translated value description from the active message bundle and interpolating the current rating value integer. Because the current text changes at runtime, the rating widget factors this logic out into a separate, reusable method named <em>_getDescription</em>.</p>

```javascript
    postMixInProperties: function() {
        this.currentText = this._getDescription();
    },
    _getDescription: function() {
        if(this.currentValue == 1) {
            var template = this.labels.starsSingular;
        } else {
            var template = this.labels.starsPlural;
        }
        return dojo.string.substitute(template, [this.currentValue]);
    },
```

<h3>Inserting the Stars</h3>

<p>Add another method called <em>postCreate</em>. Dojo invokes this method after rendering the template and inserting it into the DOM. The code in this method creates the initial set of stars in the widget as a set of <em>span</em> elements with CSS background images. The code applies CSS classes to these nodes according to the initial widget value: the <em>onIcon</em> class if less the the current value or <em>offIcon</em> class if greater than or equal to the current value.</p>

<p>The code creates an additional <em>span</em> node per star containing a text representation of the star: (*) if the star is on or ( ) if the star is off. These span nodes are hidden by default with CSS, but will appear if the user disables stylesheets. Finally, this method attaches <em>onclick</em> handlers to each star for mouse interaction and connects a <em>onkeypress</em> listener to the parent widget node for keyboard support.</p>

```javascript
    postCreate: function() {
        // build stars using DOM methods
        for(var i = 0; i &lt; this.maximumValue; i++) {
            // create span to hold star image
            var span = document.createElement('span');
            // style it to display properly
            dojo.style(span, {'display' : 'inline-block',
                              'cursor' : 'pointer'});
            // listen for mouse clicks on the span with the value it
            // represents in the closure
            this.connect(span, 'onclick',
                         dojo.hitch(this, this._onClick, i+1));
            // create a text node that will go in the span if styles are turned
            // off for accessibility
            var text = document.createElement('span');
            dojo.style(text, {'display' : 'none'});
            span.appendChild(text);
            // show the correct star and text
            if(i >= this.currentValue) {
                dojo.addClass(span, this.offIcon);
                text.innerHTML = '( )';
            } else {
                dojo.addClass(span, this.onIcon);
                text.innerHTML = '(*)';
            }
            this.box.appendChild(span);
        }
        // add keyboard handler
        this.connect(this.box, 'onkeypress', this._onKeyDown);
    },
```

<h3>Updating the User Interface</h3>

<p>Now create an <em>_update</em> method. This method refreshes the star icons and WAI-ARIA properties as the user changes the rating value. The method swaps the star on and off CSS classes depending on the current value. It uses the <em>dijit.setWaiState</em> functions to set the current numeric value and human readable description of the value on the widget for assistive technologies.</p>

```javascript
    _update: function() {
        // update visuals
        for(var i=0,c=0; i &lt; this.maximumValue; i++,c++) {
            var span = this.box.childNodes[c];
            var text = span.firstChild;
            if(i &gt;= this.currentValue) {
                // turn stars off if greater than or equal to current
                dojo.removeClass(span, this.onIcon);
                dojo.addClass(span, this.offIcon)
                text.innerHTML = '( )';
            } else {
                // turn stars on if less than current
                dojo.removeClass(span, this.offIcon);
                dojo.addClass(span, this.onIcon);
                text.innerHTML = '(*)';
            }
        }
        // update aria
        this.currentText = this._getDescription();
        dijit.setWaiState(this.box, 'valuenow', this.currentValue);
        dijit.setWaiState(this.box, 'valuetext', this.currentText);
    },
```

<h3>Listening for Events</h3>

<p>Finally, define the <em>_onClick</em> and <em>_onKeyDown</em> event handlers. The mouse handler updates the current value to match the star clicked and then refreshes the user interface. The keyboard handler watches for presses of the arrow keys, the <em>Home</em> key, and the <em>End</em> key. When the user presses one of these keys, it updates the current value appropriately and refreshes the UI.</p>

```javascript
    _onClick: function(value, event) {
        this.currentValue = value;
        this._update();
    },

    _onKeyDown: function(event) {
        switch(event.keyCode) {
        case dojo.keys.UP_ARROW:
        case dojo.keys.RIGHT_ARROW:
            this.currentValue += 1
            this.currentValue = Math.min(this.currentValue, this.maximumValue);
            dojo.stopEvent(event);
            break;
        case dojo.keys.DOWN_ARROW:
        case dojo.keys.LEFT_ARROW:
            this.currentValue -= 1
            this.currentValue = Math.max(this.currentValue, 0);
            dojo.stopEvent(event);
            break;
        case dojo.keys.HOME:
            this.currentValue = 0;
            dojo.stopEvent(event);
            break;
        case dojo.keys.END:
            this.currentValue = this.maximumValue;
            dojo.stopEvent(event);
            break;
        }
        // refresh the display
        this._update();
    }
```

<h2>Testing the Widget</h2>

<p>The widget is now ready for testing. This tutorial assumes you will use Firefox 3 because it currently has excellent support for WAI-ARIA and works well with various assistive technologies. Visit the test page you created earlier in Firefox to start using the rating widget.</p>

<h3>Mouse and Keboard Interaction</h3>

<p>Click a star to change the current rating value. Alternatively, give the widget keyboard focus by tabbing to it and then use <em>Right/Up Arrow</em> to increase the value or <em>Down/Left Arrow</em> to decrease it. Press <em>Home</em> to set the rating to the minimum value and <em>End</em> to set it to its maximum.</p>

<p>In Firefox, but not necessarily other browsers, hover the mouse pointer over the widget to see the human readable description in a popup.</p>

<h3>No Stylesheets</h3>

<p>Disable CSS by selecting <em>View &gt; Page Style &gt; No Style</em> in Firefox. Notice that the star graphics disappear, but are replaced by a text equivalent for the widget. The widget still responds to mouse and keyboard input as before.</p>

<h3>NVDA or Orca Speech</h3>

<p>If you're running Windows, grab a copy of the <a href="http://www.nvda-project.org">NVDA screen reader</a> and run it to test your WAI-ARIA markup. Alternatively, download an evaluation version of <a href="http://www.freedomscientific.com/fs_products/software_jaws.asp">JAWS</a> or <a href="http://www.gwmicro.com/Window-Eyes/">WindowEyes</a> for Windows. If you're running the GNOME desktop, run the <a href="http://live.gnome.org/Orca">Orca screen reader</a> instead. (Sorry Mac users: you're currently out of luck as <a href="http://accessgarage.wordpress.com/2008/08/21/firefox-and-os-xs-voiceover-reading-the-magic-8-ball/">VoiceOver does not support WAI-ARIA markup yet</a>.)</p>

<p>After starting your screen reader of choice, switch to Firefox and tab into the rating widget test page. When the gadget receives focus, your screen reader announces its label and value. Use the arrow keys to change the rating value. The screen reader reports the new value.</p>

<p>WAI-ARIA is a relatively new standard. Assistive technologies and browser vendors are still working hard to define best practices for exposing and reporting accessibility metadata. In the meantime, there are some <a href="http://www.paciellogroup.com/blog/?p=68">discrepancies</a> in its treatment. For example, Orca reads the <em>aria-valuenow</em> property on the rating widget as a floating point number instead of announcing the <em>aria-textnow</em> value. NVDA, on the other hand, speaks both the <em>title</em> and <em>aria-textnow</em> values even though they are equivalent.</p>

<h3>Spanish Locale</h3>

<p>Open another tab in Firefox by selecting <em>File &gt; New Tab</em>. Enter <em>about:config</em> in the URL bar. Locate the property named <em>general.useragent.locale</em> and change its value to <em>es</em>. This change forces Firefox to report the locale as <em>es</em> to Dojo as it would for Spanish users.</p>

<p>Switch back to the tab showing the test page and refresh it. Hover the mouse over the widget to see the Spanish description or listen to it in your screen reader. The description now includes the word <em>estrella(s)</em> instead of <em>star(s)</em>.</p>

<p>After testing, don't forget to change the Firefox locale back to its default using <em>about:config</em> again.</p>

<h2>Source Code</h2>

<p>The source code for the completed widget and an example page including it are <a href="https://github.com/parente/dojo-a11y-rating">available on GitHub</a>.</p>

<h2>References</h2>
<ul>
        <li><a href="http://www.w3.org/TR/wai-aria/">WAI-ARIA 1.0 Specification</a></li>
        <li><a href="http://dojotoolkit.org/reference-guide/">The Dojo Reference Guide</a></li>
        <li><a href="http://wiki.codetalks.org/wiki/index.php/Set_of_ARIA_Test_Cases">Code Talks WAI-ARIA test cases</a></li>
</ul>

<h2>Changelog</h2>
<ul>
        <li>10/14/09: Updated to Dojo 1.3.2 for Safari 4 / IE8 support. Removed strange minimum value and fixed at zero.</li>
  <li>12/21/10: Updated to use Dojo 1.5 from CDN. Point to GitHub for complete code.</li>
</ul>
