define [
  "cs!ContentLeaf"
  "text!html/content-category.html"
], (ContentLeaf, template) ->

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


    useGlobals: (globals) ->
      @children.each (child) ->
        child.useGlobals globals



  class ContentChild extends Marionette.CompositeView
    tagName: "div"
    className: -> if @isAccordion() then "panel panel-default list-group-item" else "list-group-item"
    id: -> @model.get "short"
    template: template
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