define [
  "text!html/content-excluded.html"
], (template) ->

  class ContentExcluded extends Marionette.ItemView
    tagName: "li"
    className: "list-group-item list-group-item-warning"
    template: template

    getText: -> ""
    hasChecked: -> false
    updateText: ->
    clearAll: ->
    useGlobals: ->