url_base = "<%= request.protocol %><%= request.host %>:<%= request.port %>"
url      = "#{ url_base }/users/<%= @user.bookmark_key %>/open_articles"

form = document.createElement("form")
form.setAttribute("method", "post")
form.setAttribute("action", url)

formText = document.createElement("textarea")
formText.setAttribute("name", "article[raw_html]")
formText.value = document.documentElement.outerHTML
form.appendChild(formText)

formUrl = document.createElement("input")
formUrl.setAttribute("name", "article[url]")
formUrl.setAttribute("type", "text")
formUrl.value = window.location.href
form.appendChild(formUrl)

formSubmit = document.createElement("input")
formSubmit.setAttribute("type", "submit")
formSubmit.setAttribute("value", "Submit")
form.appendChild(formSubmit)

form.submit()
