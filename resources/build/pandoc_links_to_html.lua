-- Simple LUA function to be used by Pandoc when converting Markdown to HTML
function Link(el)
  el.target = string.gsub(el.target, "%.md", ".html")
  el.target = string.gsub(el.target, "README.html", "Table-of-Contents.html")
  return el
end
