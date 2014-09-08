d = document
z = d.createElement('scr' + 'ipt')
b = d.body
l = d.location

try
  throw(0) if !b
  z.setAttribute('src', l.protocol + "//%%hostname%%/users/%%secret_key%%/open_articles/new.js")
  b.appendChild(z)
catch e
  alert('Please wait until the page has loaded.')
