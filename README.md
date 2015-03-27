# pediarr

R interface to Wikipedia API

## Features

* Search Wikipedia

```r
pediasearch("ukulele")
pediasearch("ukulele", extract = TRUE)

pediasearch("Python")
pediasearch("Python", namespace = "14") # search for categories
pediasearch("Dynamically typed programming languages", namespace = 14, limit = 1)
```

* Retrieve extract of Wikipedia article (Full text in the future)

```r
pediaextracts("Hong_Kong")
pediaextracts("Hong Kong") # smart enough to replace space with underscore
pediaextracts("Hong_Kong", lang="es")

ukuleleextracts <- sapply(pediasearch("ukulele"), pediaextract) # it is not a good practice
```

* List out members of Wikipedia category

```r
pediacategory("Category:Dynamically typed programming languages")
pediacategory("Category:Dynamically typed programming languages", cmtype = 'page') # ignore subcat and files
```
