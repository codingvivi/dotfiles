config.load_autoconfig()
config.set("colors.webpage.preferred_color_scheme", "dark")
config.set("qt.args", ["--force-dark-mode"])

config.bind(";v", "hint links spawn mpv {hint-url}")
config.bind("j", "scroll-page 0 0.5", mode="normal")
config.bind("k", "scroll-page 0 -0.5", mode="normal")
config.bind("h", "tab-prev", mode="normal")
config.bind("l", "tab-next", mode="normal")
config.bind("ge", "scroll-to-perc 100", mode="normal")
config.unbind("G", mode="normal")

c.url.searchengines = {
    "DEFAULT": "https://google.com/search?hl=en&q={}",
    "!a": "https://www.amazon.com/s?k={}",
    "!d": "https://duckduckgo.com/?ia=web&q={}",
    "!dd": "https://thefreedictionary.com/{}",
    "!e": "https://www.ebay.com/sch/i.html?_nkw={}",
    "!fb": "https://www.facebook.com/s.php?q={}",
    "!gh": "https://github.com/search?o=desc&q={}&s=stars",
    "!gist": "https://gist.github.com/search?q={}",
    "!gi": "https://www.google.com/search?tbm=isch&q={}&tbs=imgo:1",
    "!gn": "https://news.google.com/search?q={}",
    "!ig": "https://www.instagram.com/explore/tags/{}",
    "!m": "https://www.google.com/maps/search/{}",
    "!p": "https://pry.sh/{}",
    "!r": "https://www.reddit.com/search?q={}",
    "!sd": "https://slickdeals.net/newsearch.php?q={}&searcharea=deals&searchin=first",
    "!t": "https://www.thesaurus.com/browse/{}",
    "!tw": "https://twitter.com/search?q={}",
    "!w": "https://en.wikipedia.org/wiki/{}",
    "!yelp": "https://www.yelp.com/search?find_desc={}",
    "!yt": "https://www.youtube.com/results?search_query={}",
}
