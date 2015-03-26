require(httr)

langapi <- function(lang) {
    return(paste0("https://", lang, ".wikipedia.org/w/api.php"))
}

pediaextract <- function(wikititle, lang = 'en') {
    res <- GET(langapi(lang), query = list(format = 'json', action = 'query', prop = 'extracts', titles = wikititle, exintro = '', explaintext = ''))
    return(content(res)$query$page[[1]]$extract)
}

#pediaextracts("Hong_Kong")
#pediaextracts("Hong Kong") # smart enough to replace space with underscore
#pediaextracts("Hong_Kong", "es")

#res <- GET("https://en.wikipedia.org/w/api.php", query = list(format = 'json', action = 'opensearch', search = 'Hong Kong', limit = '20', namespace = '0'))
#unlist(content(res)[[2]])
#unlist(content(res)[[3]])

pediasearch <- function(searchstring, lang = 'en', extract = FALSE, limit = 20, namespace = '0') {
    res <- GET(langapi(lang), query = list(format = 'json', action = 'opensearch', search = searchstring, limit = limit, namespace = namespace))
    if (extract) {
        return(list(title = unlist(content(res)[[2]]), extract = unlist(content(res)[[3]])))
    } else {
        return(unlist(content(res)[[2]]))
    }
}

#pediasearch("ukulele")
#ukuleleextracts <- sapply(pediasearch("ukulele"), pediaextract) # it is not a good practice
#pediasearch("ukulele", extract = TRUE)

#pediasearch("Python")
#pediasearch("Python", namespace = "14") # search for categories
#pediasearch("Dynamically typed programming languages", namespace = 14, limit = 1) # search for categories


pediacategory <- function(wikicategory, lang = 'en', limit = 500, cmtype = 'page|subcat|file') {
    res <- GET(langapi(lang), query = list(format = 'json', action = 'query', list = 'categorymembers', cmtitle = wikicategory, cmtype = cmtype, cmlimit = limit, cmprop = 'title'))
    return(sapply(content(res)$query$categorymembers, function(x) x$title))
}

#pediacategory("Category:Dynamically typed programming languages")

#alldyn <- sapply(pediacategory("Category:Dynamically typed programming languages", cmtype = 'page'), pediaextract)
#saveRDS(alldyn, "~/alldyn.rds")
