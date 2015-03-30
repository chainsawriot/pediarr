# pediarr

R interface to Wikipedia API

# Package Installation

```r
if(!require("devtools")){
    install.packages("devtools")
    library("devtools")
}
install_github("chainsawriot/pediarr")
```

## Features

* Search Wikipedia

```r
pediasearch("ukulele")
pediasearch("ukulele", extract = TRUE, limit = 1)

pediasearch("Python")
pediasearch("Python", namespace = 14) # search for categories
pediasearch("Dynamically typed programming languages", namespace = 14, limit = 1)
```

* Retrieve extract(s) of Wikipedia article

```r
pediaextract("Hong_Kong")
pediaextract("Hong Kong") # smart enough to replace space with underscore
pediaextract("Hong_Kong", lang="es")

sapply(pediasearch("ukulele"), pediaextract) # it is not a good practice, use pediasearch("ukulele", extract = TRUE)

# Multiple extracts from one query
pediaextract(c("R.E.M.", "Nirvana (band)", "Pearl Jam"))
```

* Experimental: retrieve the full text of Wikipedia article

```r
fulltext <- pediafulltext("Albert Einstein", format = 'text') # extremely messy, need to cleanup
wikitext <- pediafulltext("Albert Einstein", format = 'wikimarkup')
htmltext <- pediafulltext("Albert Einstein", format = 'html')
```

* List out members of Wikipedia category

```r
pediacategory("Category:Dynamically typed programming languages")
pediacategory("Category:Dynamically typed programming languages", cmtype = 'page') # ignore subcat and files
```

* Retrieve the wikipedia title in other language

```r
pedialang("Albert Einstein")
pedialang("米", lang = "ja", lllang = "de")
pedialang("앨런_튜링", lang = "ko", lllang = "en")
pedialang("John_McCarthy_(computer_scientist)", lllang = "zh")
```