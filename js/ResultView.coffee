define [
  "text!html/result.html"
  "lib/countable"
], (template, Countable) ->

  class ResultView extends Marionette.ItemView
    template: template
    className: "form-inline"

    ui:
      name: "#student-name"
      gender: "[name=gender]"
      textarea: "textarea"
      charCount: ".chars .count"
      wordCount: ".words .count"
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
      Countable.once @ui.textarea[0], (counter) =>
        @ui.charCount.text counter.all
        @ui.wordCount.text counter.words