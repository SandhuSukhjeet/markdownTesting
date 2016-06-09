# Introduction to Markdown

   * Markdown is a way to style the text on the web. We use the Markdown syntax and styling format for comments, and all forms of writing on GitHub platform. It is easy to learn and easy to use, method of creating and styling the web documents. More so, this document is a Markdown file.

   * <a name="atomref"> </a>To create a Markdown file, we can use any text editor, which supports Markdown files, which are files that have .md as their extension. One such text editor is [Atom](README.md#atom). We can see the preview of the file in Atom as in to check how it will look online after rendering by selecting Packages -> Markdown Preview -> Toggle Preview, or by keyboard shortcut of `^⇧M` (control + shift + M).

   * In a Markdown file we can make the words/lines of text to be *italic* by enclosing the text with a `*` (Asterisk) or by an `_` (Underscore) symbol at the beginning and at the end (As: `*italic*` or `_italic_`). We can make it **bold** by enclosing the text with two `**` or two `__` both at the beginning and at the end (As: `**bold**` or `__bold__`).

   * We can have the headers in the file with heading size ranging from H1 to H6 as in HTML format.

   * Representing H1 tag to be #HEADING1, H2 as ##HEADING, to H6 as ######HEADING6, which is to add # symbol at the beginning of the heading. This can be changed by increasing or decreasing the number of # symbol at the beginning of heading to range from H1 to H6.

   * We can add images to the file by specifying it in the format: `![Alternate text](Path or Link to the image "Optional name for the image")`. eg: `![ExampleImage](/abc/example/image.png "Example image")`.

   * We can add links by following ways:
     * We can specify a link and Markdown will automatically represent it as a clickable link. eg: http://www.google.com

     * We can render a text to link to a URL. eg: Click on  [google](http://www.google.com) for homepage. This is done by `[text](URL)`, which here was "Click on `[google](http://www.google.com)` for homepage."

* There is a special rendering and syntax support by GitHub called GitHub Flavored Markdown(GHFM), which supports many new features only on GitHub platform, such as `@userName` mentions, relative links to files, code syntax highlighting and many more. To put this through, in a normal markdown file if you want to give a block of code, you can write the code inside three \`\`\` (backticks) both at starting and ending of the code. This would just bring a block of code without any specific syntax and color scheme.

\`\`\`  
code line 1  
code line 2  
\`\`\`  

\`\`\`coding language  
code line 1  
code line 2  
\`\`\`  

Where as in the GHFM, we can give color scheme and syntax when we specify the three backticks followed by the language.  

```
let a: Int?
var b = 45 * (23 + 45)
let c = "this is a string with \(value)"
This is a block of code without any syntax and color scheme.
```  


```swift
let a: Int?
var b = 45 * (23 + 45)
let c = "this is a string with \(value)"
This is a block of code with Swift syntax and color scheme.
```

* We can have a reference to a file and it's contents from another markdown file by relative links, such as if you have two files A.md and B.md both in the same directory. The file B has topics listed in it as Topic1, Topic2 and Topic3. We can refer to file B from A, as \[fileB](B.md) and to refer to a particular topic in file b, we can say \[first topic](B.md#topic1). A working example can be found in this file above, if you can click on [  Atom](Introduction to Markdown.md#atomref) reference it takes you to system setup file, and clicking on reference in that file bring you here. To refer to a file in another directory, you can give path from parent directory.  

* For learning in detail on Markdown file and format, visit the following links:

   * [What is Markdown](http://whatismarkdown.com)
   * [Daring Fireball Page](http://daringfireball.net/projects/markdown/syntax)  
   * Step by step [markdown tutorial](http://www.markdowntutorial.com) with live workable examples.
   * How to use [relative links](https://github.com/blog/1395-relative-links-in-markup-files) in Markdown.
   * [Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
   * [Mastering Markdown](https://guides.github.com/features/mastering-markdown/)
