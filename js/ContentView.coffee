define [
  "text!html/content-category.html"
  "text!html/content-item.html"
], (catTemplate, itemTemplate) ->

  class ContentLeaf extends Marionette.ItemView
    tagName: "li"
    className: "list-group-item leaf"
    template: itemTemplate

    ui:
      checkbox: "input"

    events:
      "click span": ->
        @ui.checkbox.prop "checked", !@ui.checkbox.is(":checked")
        @updateText()
      "click input": "updateText"


    updateText: ->
      @trigger "updatetext"


    getText: ->
      return if @ui.checkbox.is(":checked") then @model.get "text" else ""


    clearAll: ->
      @ui.checkbox.prop "checked", false



  class BranchMixin
    getChildView: (item) ->
      return if item.has "content" then ContentChild else ContentLeaf


    childEvents:
      "updatetext": -> @trigger "updatetext"


    childViewOptions: (model, index) ->
      parentId: _.result this, 'id'
      isExpanded: @isExpanded and index is 0


    getText: ->
      text = ""
      @children.each (child) ->
        if text.length > 0 then text += " "
        text += child.getText()
      return $.trim text


    clearAll: ->
      @children.each (child) ->
        child.clearAll()



  class ContentChild extends Marionette.CompositeView
    tagName: "div"
    className: -> if @isAccordion() then "panel panel-default list-group-item" else "list-group-item"
    id: -> @model.get "short"
    template: catTemplate
    childViewContainer: ".children"

    ui:
      container: ".collapse"


    initialize: (options) ->
      @parentId = options.parentId
      @isExpanded = options.isExpanded
      @collection = @model.get "content"


    isAccordion: ->
      return @model.get("level") in [0, 1]


    serializeData: ->
      return _.extend super,
        isAccordion: @isAccordion(),
        parentId: @parentId + if @model.get("level") > 0 then "-children" else ""
        isExpanded: @isExpanded


    expand: ->
      @ui.container.collapse 'toggle'
      if 0 is @model.get "level" then @children.first()?.expand()



  class ContentView extends Marionette.CollectionView
    tagName: "div"
    id: "all-items"
    isExpanded: true



  _.extend ContentChild::, BranchMixin::
  _.extend ContentView::, BranchMixin::


  return ContentView