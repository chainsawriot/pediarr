require(httr)

pediaextract <- function(wikititle, lang = 'en') {
    wikiapi <- paste0("https://", lang, ".wikipedia.org/w/api.php")
    res <- GET(wikiapi, query = list(format = 'json', action = 'query', prop = 'extracts', titles = wikititle, exintro = '', explaintext = ''))
    return(content(res)$query$page[[1]]$extract)
}

pediaextracts("Hong_Kong")
pediaextracts("Hong Kong") # smart enough to replace space with underscore
pediaextracts("Hong_Kong", "es")

res <- GET("https://en.wikipedia.org/w/api.php", query = list(format = 'json', action = 'opensearch', search = 'Hong Kong', limit = '20', namespace = '0'))
unlist(content(res)[[2]])
unlist(content(res)[[3]])

pediasearch <- function(searchstring, lang = 'en', extract = FALSE, limit = 20, namespace = '0') {
    wikiapi <- paste0("https://", lang, ".wikipedia.org/w/api.php")
    res <- GET(wikiapi, query = list(format = 'json', action = 'opensearch', search = searchstring, limit = limit, namespace = namespace))
    if (extract) {
        return(list(title = unlist(content(res)[[2]]), extract = unlist(content(res)[[3]])))
    } else {
        return(unlist(content(res)[[2]]))
    }
}

pediasearch("ukulele")
ukuleleextracts <- sapply(pediasearch("ukulele"), pediaextract) # it is not a good practice
pediasearch("ukulele", extract = TRUE)

pediasearch("Python")
