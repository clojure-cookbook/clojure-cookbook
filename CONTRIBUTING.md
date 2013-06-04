# Contributing to Clojure Cookbook

Our goal with *Clojure Cookbook* is to build the best possible cookbook chock full of excellent Clojure recipes. To do this we need the help of the whole community. From typos and factual corrections, to ideas for recipes, to whole recipes themselves, your experience is what we need to build the best *Clojure Cookbook*.

This document describes how you can contribute and what you'll receive if you do.

## Valuable Contributions

Nearly any knowledge or bit of information you could contribute to the cookbook is valuable, but here are some concrete ideas:

* Suggest an idea by making a change to our [Ideas Page](#)
* Correct a typo in an existing recipe.
* Proofread and provide feedback on existing recipes.
* Write a recipe yourself (find more details in the [Recipes](#Recipes) section below.)

*While major contributions such as a whole recipe require a [license assignment](#licensing), typos, factual corrections and ideas do not.*


## Credits & Rewards

Any contribution, big or small, will net you a digital copy of the book and your name and GitHub handle immortalized in a contributors list in the book (think of the glory it will bring your family). 

### Write a recipe

Contributors who write an entire recipe will be listed as the author of that recipe.

### Write 5+ recipes

Make a substantial contribution to the book (five or more recipes) and we will send you a signed physical copy of the book once it hits the presses.

## Recipes

One of the most helpful contributions you could make to the cookbook is a complete recipe. This section provides an overview of what a recipe looks like, where to draw ideas for recipes from and how to properly license your content so that it may be published in the final book.

### The format

The general format for any cookbook recipes is **Problem**, **Solution** and **Discussion**. The length of a recipe is generally one to two pages, but there is no hard rule on length (big or small.) Simple examples may only warrant half a page, and more complex examples might push three or four pages. If you're in doubt, inquire early.

#### Problem Statement

A problem statement is a short description of the problem the recipe provides a solution too.

**Appropriate examples**:

```
You need to generate a lazy sequence covering a range of dates and/or times.
```

```
You want to create a list data structure in your source code.
```

Or, a longer example:

```
Normally, maps are strictly one value per key; if you +assoc+ an
existing key, the old value is replaced.

Sometimes it is useful to have a map-like interface (a "multimap")
which is capable of storing _multiple_ values for the same key. There
is no such capability built in to Clojure.

So, how would you design a multimap data structure, backed by a normal
map?
```

#### Solution

The solution to a problem briefly introduces the approach and contains the code for the actual *solution* to the problem.

**The solution to a problem should *discuss* the solution as little as possible** – leave this for the Discussion section.

See the following recipes for representative examples:

* [Performing Find and Replace on Strings](primitive-data/strings/find-and-replace/find-and-replace.asciidoc)
* [Performing Fuzzy Comparison](primitive-data/math/fuzzy-comparison/fuzzy-comparison.asciidoc)
* [Adding or Removing Items from Sets](composite-data/sets/adding-and-removing/adding-and-removing.asciidoc)


### Style

**TODO (Luke?)**: You vs. I, etc.

### Source code

**TODO (Luke)**: exposition about when include source code would be necessary, how to do it, and an example.

### Licensing

**TODO (Luke?)**:
Every sizable contribution needs to be accompanied by a `LICENSE` file indicating the content is licensed under THE_LICENSE_TYPE_IT_NEEDS_TO_BE. Here is an example of what that would look like:

```text
yadda, yadda license
```

### Ideas

You'll find a list of ideas under the [ideas tag](https://github.com/levand/clojure-cookbook/issues?labels=idea&milestone=&page=1&state=open) of our GitHub Issues page. Feel free to submit your own ideas with a title like: `Idea: recipe covering http-kit` or `Idea: Creating a leiningen plugin`. 

To get you started, here is a rough list of the chapters we hope to cover in the final book:

* **Primitive Data** – strings, numbers, dates, etc.
* **Composite Data** – plural data and the manipulation thereof
* **Databases and Persistence** – ...
* **Local IO** – reading/writing to the console, file manipulation, etc.
* **Network IO** – ... 
* **Distributed Computing** – …
* **GUI applications** – …
* **Packaging and Deployment** – ...
* **Testing and Profiling** – …
* **Web Applications** – …
* **ClojureScript** – …

This is by no means a final list, but it should serve to give a general idea the shape of the book.