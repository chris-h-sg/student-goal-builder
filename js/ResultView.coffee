define [
  "text!html/result.html"
], (template) ->

  class ResultView extends Marionette.ItemView
    template: template
    className: "form-inline"

    ui:
      name: "#student-name"
      gender: "[name=gender]"
      textarea: "textarea"
      charCount: ".char-count"
      clear: ".clear"


    events:
      "click .select-text": -> @ui.textarea.select()
      "input @ui.name": "updateGlobals"
      "change @ui.name": "updateGlobals"
      "click @ui.gender": "updateGlobals"
      "click @ui.clear": "clearAll"


    updateGlobals: ->
      @trigger "updateglobals"


    clearAll: ->
      @ui.name.val ""
      @ui.gender.prop "checked", false
      @setText ""
      @trigger "clearall"


    getGlobalValues: ->
      return name: @ui.name.val(), gender: @ui.gender.filter(":checked").val()


    setText: (text) ->
      @ui.textarea.val text
      @ui.charCount.text text.length