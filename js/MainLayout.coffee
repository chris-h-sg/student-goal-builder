define [
  "text!html/layout.html"
], (template) ->

  class MainLayout extends Marionette.LayoutView
    template: template

    regions:
      top: "#top-nav"
      content: "#content"
      result: "#result"