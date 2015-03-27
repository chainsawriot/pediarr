require(httr)

langapi <- function(lang) {
    return(paste0("https://", lang, ".wikipedia.org/w/api.php"))
}

pediaextract <- function(wikititle, lang = 'en') {
    res <- GET(langapi(lang), query = list(format = 'json', action = 'query', prop = 'extracts', titles = wikititle, exintro = '', explaintext = ''))
    return(content(res)$query$page[[1]]$extract)
}

pediasearch <- function(searchstring, lang = 'en', extract = FALSE, limit = 20, namespace = 0) {
    if (namespace != 0 & extract) {
        warning("Extract is only available for namespace = 0")
        extract <- FALSE
    }
    res <- GET(langapi(lang), query = list(format = 'json', action = 'opensearch', search = searchstring, limit = limit, namespace = namespace))
    if (extract) {
        extracts <- unlist(content(res)[[3]])
        names(extracts) <- unlist(content(res)[[2]])
        return(extracts)
    } else {
        return(unlist(content(res)[[2]]))
    }
}

pediacategory <- function(wikicategory, lang = 'en', limit = 500, cmtype = 'page|subcat|file') {
    res <- GET(langapi(lang), query = list(format = 'json', action = 'query', list = 'categorymembers', cmtitle = wikicategory, cmtype = cmtype, cmlimit = limit, cmprop = 'title'))
    return(sapply(content(res)$query$categorymembers, function(x) x$title))
}
