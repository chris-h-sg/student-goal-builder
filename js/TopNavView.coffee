define [
], ->

  class TopNavItem extends Marionette.ItemView
    tagName: "li"
    className: ""
    template: "<a href='\#{{short}}-children' data-toggle='collapse' data-parent='#all-items'>{{text}}</a>"



  class TopNavView extends Marionette.CollectionView
    tagName: "ul"
    className: "nav navbar-nav"
    childView: TopNavItem
