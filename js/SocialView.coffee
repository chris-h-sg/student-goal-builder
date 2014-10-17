define [
  "text!html/social.html"
], (template) ->

  class SocialView extends Marionette.ItemView
    template: template
    className: "buttons"


    serializeData: ->
      "store-url": "STORE_URL"


    onRender: ->
      # Facebook like button
      ((d, s, id) ->
        if d.getElementById(id) then return
        js = undefined
        firstChild = $('body').children()[0]
        js = d.createElement(s)
        js.id = id
        js.src = "http://connect.facebook.net/en_US/sdk.js#xfbml=1&appId=1524621471109098&version=v2.0"
        firstChild.parentNode.insertBefore js, firstChild
      ) document, "script", "facebook-jssdk"
      # Twitter
      window.twttr = ((d, s, id) ->
        if d.getElementById(id) then return
        firstChild = $('body').children()[0]
        js = d.createElement(s)
        js.id = id
        js.src = "https://platform.twitter.com/widgets.js"
        firstChild.parentNode.insertBefore js, firstChild
        window.twttr or (t =
          _e: []
          ready: (f) ->
            t._e.push f
            return
        )
      )(document, "script", "twitter-wjs")
      # Google+
      ((d, s, id) ->
        if d.getElementById(id) then return
        js = undefined
        firstChild = $('body').children()[0]
        js = d.createElement(s)
        js.id = id
        js.src = "https://apis.google.com/js/platform.js"
        firstChild.parentNode.insertBefore js, firstChild
      ) document, "script", "google-plus"