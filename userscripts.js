/* ==UserStyle==
@name            Remove garbage
@match           https://*.youtube.com/*
@match           https://*.onepiece.fandom.com/*
@match           https://*.twitter.com/*
@match           https://*.x.com/*
==/UserStyle== */

.ytp-button.ytp-remote-button { display: none !important }
#sbSkipIconControlBarImage { opacity: 0 !important; width: 6px !important }
#WikiaAdInContentPlaceHolder .popular-pages { display: none !important }
.WikiaRail .render-wiki-recommendations-right-rail { display: none !important }
a[href="/i/verified-choose"] { display: none !important }
div[aria-label="Trending"] div div:has(aside[aria-label="Get Verified"]) { display: none !important }
div[aria-label="Trending"] div div:has(aside[aria-label="Subscribe to Premium"]) { display: none !important }

// ==UserScript==
// @name         Youtube shorts redirect
// @match        *://*.youtube.com/*
// ==/UserScript==

let oldHref = document.location.href

if (window.location.href.indexOf("youtube.com/shorts") > -1) {
    window.location.replace(window.location.toString().replace("/shorts/", "/watch?v="))
}

window.onload = function() {
    const bodyList = document.querySelector("body")
    const observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (oldHref != document.location.href) {
                oldHref = document.location.href
                if (window.location.href.indexOf("youtube.com/shorts") > -1) {
                    window.location.replace(window.location.toString().replace("/shorts/", "/watch?v="))
                }
            }
        })
    })
    observer.observe(bodyList, {
        childList: true,
        subtree: true
    })
}

// ==UserScript==
// @name            BetterTTV
// @match           https://*.twitch.tv/*
// @match           https://*.youtube.com/*
// ==/UserScript==

(function betterTTV() {
    const script = document.createElement("script")
    script.type = "text/javascript"
    script.src = "https://cdn.betterttv.net/betterttv.js"
    const head = document.getElementsByTagName("head")[0]
    if (!head) return
    head.appendChild(script)
})()
