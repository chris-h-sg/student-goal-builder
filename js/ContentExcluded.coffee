define [
  "text!html/content-excluded.html"
], (template) ->

  class ContentExcluded extends Marionette.ItemView
    tagName: "li"
    className: "list-group-item list-group-item-warning"
    template: template

    serializeData: ->
      data = super
      data.singular = data.excluded is 1
      return data


    getText: -> ""
    hasChecked: -> false
    updateText: ->
    clearAll: ->
    useGlobals: ->