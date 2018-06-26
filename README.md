
<!-- README.md is generated from README.Rmd. Please edit that file -->
reviewer
========

![reviewer hex sticker](inst/figures/reviewer.png "Package hex sticker")

The goal of reviewer is to provide an RStudio addin that will allow a user to review the track-changes elements in a Microsoft Word .docx file and then convert thereviewed document to markdown. The addin uses Pandoc, which must be installed.

Installation
------------

You can install the released version of reviewer from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("adam-gruer/reviewer")
```

Example
-------

This is a basic example which shows you how to solve a common problem:

    reviewer()
