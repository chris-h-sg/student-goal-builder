define [
  "cs!ContentExcluded"
  "cs!ContentLeaf"
  "text!html/content-category.html"
], (ContentExcluded, ContentLeaf, template) ->

  class BranchMixin
    getChildView: (item) ->
      return if item.has "content" then ContentChild else if item.get("excluded") > 0 then ContentExcluded else ContentLeaf


    childEvents:
      "updatetext": -> @textUpdated?(); @trigger "updatetext"


    childViewOptions: (model, index) ->
      parentId: _.result this, 'id'
      isExpanded: @isExpanded and index is 0


    getText: ->
      text = ""
      @children.each (child) ->
        childText = child.getText()
        if childText?.length > 0
          if text.length > 0 then text += " "
          text += childText
      return $.trim text


    clearAll: ->
      @$el.removeClass "panel-info"
      @children.each (child) ->
        child.clearAll()


    hasChecked: ->
      @children.some (child) -> child.hasChecked()


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
      title: "> .panel-title"
      container: "> .collapse"


    events:
      "shown.bs.collapse @ui.container": ->
        top = @ui.title.offset().top
        if top < document.body.scrollTop
          $('body').animate { scrollTop: top - $("#top-nav").height() - 5 }, 0
        return false


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


    textUpdated: ->
      if @hasChecked() then @$el.addClass "panel-info" else @$el.removeClass "panel-info"



  class ContentTree extends Marionette.CollectionView
    tagName: "div"
    id: "all-items"
    isExpanded: true



  _.extend ContentChild::, BranchMixin::
  _.extend ContentTree::, BranchMixin::


  return ContentTree