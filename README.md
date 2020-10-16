
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datastamp

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Codecov test
coverage](https://codecov.io/gh/teunbrand/datastamp/branch/master/graph/badge.svg)](https://codecov.io/gh/teunbrand/datastamp?branch=master)
[![Travis build
status](https://travis-ci.com/teunbrand/datastamp.svg?branch=master)](https://travis-ci.com/teunbrand/datastamp)
<!-- badges: end -->

The goal of datastamp is to make it easy to attach some metadata to R
objects. This can be convenient if you want to make `.RData` or `.rds`
objects self-documenting, by attaching time of creation or the path to
the script used to generate the data.

The package has basic functionality but isn’t fine-tuned to handle any
type of data one might want to document in R.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("teunbrand/datastamp")
```

## Example

This is a basic example which shows you how you would use the datastamp
package at the end of an analysis.

``` r
# Library statements
library(datastamp)

# Declare files
input_file  <- system.file("extdata", "loremipsum.txt", package = "datastamp")
output_file <- tempfile("important_results", fileext = ".rds")

# Load data
data <- readLines(input_file)

# Start very complicated analysis
result <- toupper(data)

# Saving results
saveRDS(
  stamp(result, origin_files = input_file),  # <-- Here be a datastamp!
  file = output_file
)
```

So, imagine parking the project above for six months and you forgot some
of the circumstances under which these files were created. Or, someone
else send you this datastamped data, but you are unclear on the details.
The datastamp package attaches some metadata to the R object that might
help you remember.

``` r
old_data <- readRDS(output_file)

# Who created this?
info_user(old_data)
#>           user effective_user 
#>   "t.vd.brand"   "t.vd.brand"

# When was this object timestamped?
info_time(old_data)
#> [1] "2020-10-16 16:30:24 CEST"

# What script was used to generate the results?
info_script(old_data)
#> [1] "/DATA/users/t.vd.brand/packages/01_active/datastamp/README.Rmd"

# What raw files went into these results?
info_files(old_data)
#> [1] "/home/t.vd.brand/R/x86_64-pc-linux-gnu-library/3.6/datastamp/extdata/loremipsum.txt"
```

## How does it work?

When an object is stamped, a ‘datastamp’ attribute is attached to the
object.

``` r
# Printing atomic vectors report the datastamp attribute.
(old_data)
#> [1] "LOREM IPSUM DOLOR SIT AMET, PARTURIENT PELLENTESQUE, PRETIUM AUCTOR LEO. ID HENDRERIT IN AC, VEL, DUIS AT, LEO. TEMPOR A IMPERDIET ADIPISCING VESTIBULUM APTENT SED LOREM CURSUS DUI, ODIO TORTOR. VOLUTPAT IPSUM FAUCIBUS PLACERAT, SAPIEN APTENT IN INTERDUM QUIS FERMENTUM. LOREM, EU ANTE VIVERRA, TINCIDUNT BIBENDUM EROS A LAOREET JUSTO MAECENAS. COMMODO ETIAM LOBORTIS HABITANT CONVALLIS FACILISIS SENECTUS LIGULA. FELIS MONTES VENENATIS HABITANT QUIS EROS NULLAM FINIBUS, AMET MATTIS EGESTAS. PENATIBUS QUISQUE NUNC, SED ID TURPIS IPSUM SED. VEHICULA A AC VEL MAECENAS BLANDIT SIT VENENATIS IN."                                                                                                                                                                                                                          
#> [2] "NULLA, AENEAN CONGUE SED DIAM, SIT FACILISI DUI QUIS. TEMPUS LOREM ERAT URNA EU AUGUE VEL. VOLUTPAT IN, QUIS SED MAURIS NIBH DICTUMST ADIPISCING FINIBUS ULLAMCORPER. ERAT VOLUTPAT PRETIUM SED. EGET EROS TURPIS PELLENTESQUE PHARETRA MASSA ALIQUAM! UT SED MONTES CONSECTETUR SUSPENDISSE ARCU NON PELLENTESQUE DUI ULLAMCORPER EGESTAS MONTES? VITAE TORQUENT PELLENTESQUE TEMPOR, NISL PORTTITOR, ET PER. VESTIBULUM, SUSPENDISSE JUSTO IN. SED CURABITUR, NEC NON ALIQUET PULVINAR! QUIS UT EGET EST LOREM NOSTRA MOLESTIE NEQUE. UT TORQUENT PRAESENT APTENT EU AMET JUSTO ET LOBORTIS ODIO LACINIA."                                                                                                                                                                                                                                 
#> [3] "FRINGILLA EU BLANDIT PHARETRA IN. CRAS FAUCIBUS FUSCE QUIS NON LEO VEL POTENTI UT ODIO IACULIS. EROS VULPUTATE, LIGULA VULPUTATE ET INTEGER CUM MASSA IN. ALIQUAM ERAT BIBENDUM MONTES ALIQUET? MAXIMUS HIMENAEOS UT RIDICULUS NON MAURIS LIBERO. NISI A IN, EGESTAS DUIS APTENT EROS. FEUGIAT LIGULA IN MALESUADA LACINIA SED CRAS, NON EGET POSUERE LIGULA FAMES IN. CONSEQUAT SEMPER VITAE AC LAOREET, PHARETRA HABITANT PENATIBUS. PORTA NASCETUR SUSPENDISSE NON VITAE PHASELLUS ID, VEL INTERDUM EGET PLATEA URNA. A ALIQUET EST NATOQUE VEL FAUCIBUS ALIQUAM, HIMENAEOS, LACUS IN A. CURAE IN ELEMENTUM SEM VESTIBULUM CUBILIA PURUS IMPERDIET QUISQUE, SED ACCUMSAN! TORQUENT TORTOR COMMODO MATTIS NOSTRA A COMMODO NEC COMMODO AENEAN. LIGULA DUIS LOREM MAURIS, MAURIS. MAECENAS ANTE AT POSUERE, TURPIS ALIQUAM CUBILIA ALIQUAM."
#> [4] "NATOQUE EFFICITUR ACCUMSAN, AUCTOR. QUIS INTEGER ERAT AC VARIUS TURPIS ALIQUAM SCELERISQUE. LAOREET PELLENTESQUE AT RISUS AT DICTUMST UT JUSTO. DONEC VEL FUSCE VEL SED CRAS CURAE VENENATIS COMMODO DONEC QUISQUE UT MI IN. ET, ENIM FACILISIS, PROIN CONSEQUAT IN NUNC ORCI. SED AC HAC MALESUADA RIDICULUS A NAM EU VELIT VIVERRA TEMPOR CURABITUR. SEM EUISMOD NULLA LIBERO TACITI. PULVINAR AMET PELLENTESQUE NON LIBERO SEM EFFICITUR DIAM. INTERDUM ALIQUAM QUIS FUSCE MAURIS VITAE VIVERRA PER PHASELLUS AD."                                                                                                                                                                                                                                                                                                                        
#> [5] "UT MOLESTIE AC ET PULVINAR APTENT AUGUE, AUCTOR. AUCTOR SUSPENDISSE A TRISTIQUE TEMPOR CONDIMENTUM. IACULIS IN PRAESENT SAPIEN VITAE MI DICTUMST. PER, VEL EGESTAS VITAE NEC CONVALLIS EGESTAS VIVAMUS SED IPSUM POSUERE! NOSTRA PENATIBUS AT FAMES, SOLLICITUDIN VELIT ELEMENTUM LIBERO ALIQUAM PHASELLUS PORTA. AT SED MAURIS NAM NON EFFICITUR EFFICITUR LAOREET SED ET. NULLA UT, QUAM LOREM DONEC SIT IPSUM DICTUMST ET. TORTOR LACUS QUIS HENDRERIT HENDRERIT VEL DOLOR, CURAE EFFICITUR. CURAE EROS, UT NON HIMENAEOS MALESUADA DONEC. PELLENTESQUE CONSECTETUR CONSEQUAT RUTRUM A PLACERAT. FRINGILLA DIAM AD ERAT. ELEMENTUM FELIS, AC EUISMOD VEL AD LOBORTIS DICTUM."                                                                                                                                                             
#> attr(,"datastamp")
#> [datastamp] with script, time, system, session and files

# You can explicitly retrieve the stamp with `get_stamp()`
stamp <- get_stamp(old_data)
(names(stamp))
#> [1] "script"  "time"    "system"  "session" "files"

# The stamp itself is also a list, so you can retrieve information by name
stamp$time
#> [1] "2020-10-16 16:30:24 CEST"
```

If you think some parts of the datastamp aren’t necessary to include you
can either set a global option or explicitly pass `FALSE` as argument
for that part.

``` r
# Via argument
(get_stamp(stamp(1:5, session = FALSE)))
#> [datastamp] with script, time and system

# Via global options
options("datastamp.time" = FALSE)
(get_stamp(stamp(1:5)))
#> [datastamp] with script, system and session
```

## Caveats

In interactive use, the current script can not be guessed with 100%
accuracy, but it does a decent job in reporting ‘console’ or the
currently active document in RStudio. This does not necessarily need to
be the document where the data is stamped: if you have lengthy runtime
on a chunk that contains `stamp()` and you switch document-tabs for
example. It should pretty much do the right thing in non-interactive use
though.

For the ‘origin\_files’ argument, the stamping checks whether the files
exist and reports the path with `normalizePath()`, which I think
resolves symbolic links into absolute paths.
