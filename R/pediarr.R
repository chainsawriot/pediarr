#require(XML)
#require(httr)

langapi <- function(lang) {
    return(paste0("https://", lang, ".wikipedia.org/w/api.php"))
}

# the result return is not in the order of the supplied wikititles.

pediaextract <- function(wikititles, lang = 'en') {
    res <- GET(langapi(lang), query = list(format = 'json', action = 'query', prop = 'extracts', titles = paste(wikititles,collapse = "|"), exintro = '', explaintext = '', exlimit = 'max'))
    #return(content(res))
    return(as.data.frame(t(sapply(content(res)$query$pages, function(x) c(x$title, x$extract))), stringsAsFactors = FALSE))
}

pediafulltext <- function(wikititle, lang = 'en', format = 'text') {
    if (format == 'wikimarkup') {
        res <- GET(langapi(lang), query = list(format = 'json', action = 'query', prop = 'revisions', titles = wikititle, rvprop = 'content', rvlimit = 1))
        return(content(res)$query$pages[[1]]$revisions[[1]][[3]])
    } else if (format == 'html') {
        res <- GET(langapi(lang), query = list(format = 'json', action = 'parse', page = wikititle, prop = 'text'))
        return(content(res)$parse$text[[1]])
    } else if (format == 'text') {
        res <- GET(langapi(lang), query = list(format = 'json', action = 'parse', page = wikititle, prop = 'text'))
        return(paste(xpathSApply(htmlParse(content(res)$parse$text[[1]], asText = TRUE), "//text()[not(ancestor::script)][not(ancestor::style)][not(ancestor::noscript)][not(ancestor::form)]", xmlValue), collapse = " "))
    } else {
        stop("Incorrect format argument, format can only be: text, html or wikimarkup")
    }
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

pedialang <- function(wikititle, lang = 'en', limit = 50, lllang = NULL) {
    if (is.null(lllang)) {
        res <- GET(langapi(lang), query = list(format = 'json', action = 'query', prop = 'langlinks', titles = wikititle, lllimit = limit))
    } else {
        res <- GET(langapi(lang), query = list(format = 'json', action = 'query', prop = 'langlinks', titles = wikititle, lllimit = limit, lllang = lllang))
    }
    return(as.data.frame(t(sapply(content(res)$query$pages[[1]]$langlinks, function(g) { c(g[1], g[2])} )), stringsAsFactors = FALSE))
}
