#' @import XML
#' @importFrom httr GET content
NULL

# helper function
langapi <- function(lang) {
    return(paste0("https://", lang, ".wikipedia.org/w/api.php"))
}

#' Retrieve the extract of Wikipedia article
#'
#' Retrieve the first section (extract) of Wikipedia articles
#' 
#' @param wikititles A character string or Charactor vector of Wikipedia article titles
#' @param lang Language of Wikipedia to query, default = 'en'
#' @return data.frame of extracts
#' @examples
#' pediaextract("Hong_Kong")
#' pediaextract("Hong Kong") # smart enough to replace space with underscore
#' pediaextract("Hong_Kong", lang="es")
#' pediaextract(c("R.E.M.", "Nirvana (band)", "Pearl Jam"))
#' @export
pediaextract <- function(wikititles, lang = 'en') {
    res <- GET(langapi(lang), query = list(format = 'json', action = 'query', prop = 'extracts', titles = paste(wikititles,collapse = "|"), exintro = '', explaintext = '', exlimit = 'max'))
    #return(content(res))
    return(as.data.frame(t(sapply(content(res)$query$pages, function(x) c(x$title, x$extract))), stringsAsFactors = FALSE))
}

#' Retrieve the full text of Wikipedia article
#'
#' Retrieve the full text of Wikipedia article
#' 
#' @param wikititle Character string of Wikipedia article title
#' @param lang language of Wikipedia to query, default = 'en'
#' @param format character string of either 'text', 'wikimarkup' or 'html', default 'text'
#' @return Character string of Wikipedia full text
#' @examples
#' pediafulltext("Albert Einstein") # very messy
#' pediafulltext("Hong Kong", format = 'html')
#' pediafulltext("Hong Kong", lang="es", format = 'wikimarkup')
#' @export
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

#' Search for Wikipedia articles
#'
#' Retrieve the titles of Wikipedia items based on search string
#' 
#' @param searchstring A character string of search string
#' @param lang Language of Wikipedia to query, default = 'en'
#' @param extract Boolean, to retrieve the extracts or not, only available when namespace = 0
#' @param limit integer, number of items to return
#' @param namespace integer, namespace to search for, common namespace: 0 = articles, 14 = categories
#' @return vector of wikipedia titles or vector of extracts
#' @examples
#' pediasearch("ukulele")
#' pediasearch("ukulele", extract = TRUE, limit = 1)
#' pediasearch("Python")
#' pediasearch("Python", namespace = 14) # search for categories
#' pediasearch("Dynamically typed programming languages", namespace = 14, limit = 1)
#' @export
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

#' List out members of Wikipedia category
#'
#' List out members of Wikipedia category
#' 
#' @param wikicategory A character string of Wikipedia category
#' @param lang Language of Wikipedia to query, default = 'en'
#' @param limit integer, number of items to return
#' @param cmtype A character string represents member type to be list out, default is pages, subcategories and files
#' @return vector of wikipedia titles
#' @examples
#' pediacategory("Category:Dynamically typed programming languages")
#' pediacategory("Category:Dynamically typed programming languages", cmtype = 'page') # ignore subcat and files
#' @export
pediacategory <- function(wikicategory, lang = 'en', limit = 500, cmtype = 'page|subcat|file') {
    res <- GET(langapi(lang), query = list(format = 'json', action = 'query', list = 'categorymembers', cmtitle = wikicategory, cmtype = cmtype, cmlimit = limit, cmprop = 'title'))
    return(sapply(content(res)$query$categorymembers, function(x) x$title))
}

#' Retrieve the wikipedia title in other language
#'
#' Retrieve the wikipedia title in other language
#' 
#' @param wikititle A character string of Wikipedia title to query
#' @param lang Language of Wikipedia to query, default = 'en'
#' @param limit integer, number of items to return
#' @param lllang A character string represents the language of returned title. If NULL, all languages will be returned
#' @return data.frame of wikipedia titles
#' @examples
#' pedialang("Albert Einstein")
#' pedialang("John_McCarthy_(computer_scientist)", lllang = "zh")
#' pedialang("Alanu Turing", lang = 'co', lllang = 'ko')
#' @export
pedialang <- function(wikititle, lang = 'en', limit = 50, lllang = NULL) {
    if (is.null(lllang)) {
        res <- GET(langapi(lang), query = list(format = 'json', action = 'query', prop = 'langlinks', titles = wikititle, lllimit = limit))
    } else {
        res <- GET(langapi(lang), query = list(format = 'json', action = 'query', prop = 'langlinks', titles = wikititle, lllimit = limit, lllang = lllang))
    }
    return(as.data.frame(t(sapply(content(res)$query$pages[[1]]$langlinks, function(g) { c(g[1], g[2])} )), stringsAsFactors = FALSE))
}
