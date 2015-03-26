require(httr)
r <- GET("https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&explaintext=&titles=Rice")

content(r)$query$page[[1]]$extract

jx <- GET("https://ja.wikipedia.org/w/api.php", query = list(format = 'json', action = 'query', prop = 'extracts', titles = '米', exintro = '', explaintext = ''))

content(jx)$query$page[[1]]$extract
