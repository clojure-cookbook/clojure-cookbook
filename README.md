# Clojure Cookbook Contribution Hub

We're building a book, and we want your help!

*Clojure Cookbook* is set to be O'Reilly's next book in the [Cookbook Series](http://shop.oreilly.com/category/series/cookbooks.do). The book will detail a large number of Clojure recipes – pairs of problems and solutions – covering a wide number of common topics.


## Contributing

The goal behind the *Clojure Cookbook* is to build the **best** cookbook we can. We plan to do this by leveraging the breadth of experience across the entire community. We hope the rest of the community will rise to the occasion and contribute their best Clojure recipes.

Every author of an accepted contribution will receive a *free digital copy of the book* and abundant credit in the book. Authors of five or more recipes will receive a signed physical copy of the book (and major kudos!) Write a whole chapter and we might have to see if we can get your name on the cover :wink:.

**No contribution is too small**. We welcome anything from typo fixes or ideas for recipes all the way to complete recipes and anything in between. You can find more information on how to contribute in our [CONTRIBUTING.md](CONTRIBUTING.md) document.

### Preview and Verify Changes

We have a script to setup asciidoc and source-highlight on Mac OS X to allow previewing/proofreading in a browser.  Linux should be similar after asciidoc and source-highlight are installed with the appropriate package manager. Using asciidoc html5 output with your browser makes it very easy to review changes. Please verify changes before submitting a pull request.

* Setup asciidoc, source-highlight and language specific mappings
```
./setup_os_x_asciidoc_support.sh
```

* Run asciidoc
```
asciidoc -b html5 conventions.asciidoc
```

* Preview it
```
open conventions.html
```

#### Test all AsciiDoc
To verify the asciidoc files are without error/warning, run the following:
```
./test_all_asciidoc.sh
```
The only output should be the file detail.

#### Fixing Asciidoc Warnings/Errors

The only acceptable warning is related to structure of the book sections. It's ok to ignore this one.
```
asciidoc: WARNING: conventions.asciidoc: line 1: section title out of sequence: expected level 1, got level 2
```

Please correct all others or ask for guidance if the error message is unclear.
A common one is related to callouts like "<1>" at the end of a line of code.
```
asciidoc: WARNING: formatting-strings.asciidoc: line 57: no callouts refer to list item 1
```

To prevent this warning, the callout must be commented using the language appropriate comment character(s). This also keeps the code runnable in the REPL when pasted.

Clojure Example:
```
(defn foo [] "bar" ) <1>
```
requires a semicolon before the callout reference
```
(defn foo [] "bar" ) ; <1>
```

Console Example:
```
Username: <1>
```
should be
```
Username: #<1>
```

#### Trusted Contributors

The following users are trusted contributors (push access) that have proven themselves through excellent judgement and outstanding contributions to the book. We support and strongly encourage these users to make corrections and improvements to the book at will (recipes aside.)

* @jcromartie

## Who we are

We are Luke Vanderhart ([@levand](http://github.com/levand)) and Ryan Neufeld ([@rkneufeld](http://github.com/rkneufeld)), developers, authors, conference speakers and (at the moment), teachers. For this book-building adventure we will be your guides; we'll be collecting and editing your contributions, interfacing with the publisher (O'Reilly) and writing a solid chunk of the book ourselves.

## License

<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/3.0/deed.en_US"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-nd/3.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">This draft of Clojure Cookbook</span> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/3.0/deed.en_US">Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License</a>.


Please see the [contribution guide](CONTRIBUTING.md) for how this works for accepting pull requests.

Also, please note that because this is a *No Derivatives* license, you may *not* use this repository as a basis for creating your own book based on this one. Technically speaking, this book is open source in the "free as in beer" sense, rather than "free as in speech."

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/clojure-cookbook/clojure-cookbook/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
