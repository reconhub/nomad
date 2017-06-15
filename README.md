# nomad

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)

Pack up R to take away

![](https://media.giphy.com/media/AdDvHL64m5qbS/giphy.gif)

This is a fairly thin wrapper around some of the functions in [`provisionr`](https://github.com/richfitz/provisionr) but aimed at making it easy to create an internally consistent set of R packages, along with R itself, Rstudio, and on windows Rtools and git.  Non-CRAN packages are supported.  Configuration is via a simple yml file; see [`inst/nomad.yml`](inst/nomad.yml) for an annoted example.
