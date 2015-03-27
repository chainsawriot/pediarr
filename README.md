# pediarr

R interface to Wikipedia API

# Package Installation

```r
if(!require("devtools")){
    install.packages("devtools")
    library("devtools")
}
install_github("chainsawriot/pediarr")
```r

## Features

* Search Wikipedia

```r
pediasearch("ukulele")
pediasearch("ukulele", extract = TRUE, limit = 1)

pediasearch("Python")
pediasearch("Python", namespace = 14) # search for categories
pediasearch("Dynamically typed programming languages", namespace = 14, limit = 1)
```

* Retrieve extract of Wikipedia article (Full text in the future)

```r
pediaextract("Hong_Kong")
pediaextract("Hong Kong") # smart enough to replace space with underscore
pediaextract("Hong_Kong", lang="es")

sapply(pediasearch("ukulele"), pediaextract) # it is not a good practice, use pediasearch("ukulele", extract = TRUE)
```

* List out members of Wikipedia category

```r
pediacategory("Category:Dynamically typed programming languages")
pediacategory("Category:Dynamically typed programming languages", cmtype = 'page') # ignore subcat and files
```
