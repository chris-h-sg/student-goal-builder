define [
  "lib/handlebars.min"
  "lib/marionette"
  "lib/bootstrap.min"
  "cs!MainLayout"
  "cs!Categories"
  "cs!TopNavView"
  "cs!ContentView"
  "cs!ResultView"
  "cs!Controller"
  "text!../data/texts.json"
], (Handlebars, Marionette, Bootstrap, MainLayout, Categories, TopNavView, ContentView, ResultView, Controller, texts) ->
  # Each block below does a specific configuration change. The application is started at the bottom.


  # Allow empty templates in Marionette views, but not undefined ones to better detect errors.
  ((original) ->
    Marionette.Renderer.render = (template) ->
      if template?.length is 0 then return -> ""
      return original.apply this, arguments
  )(Marionette.Renderer.render)


  # Configure Marionette to load templates from strings rather than attempting
  # to find them by ID inside the DOM
  Marionette.TemplateCache::loadTemplate = (templateId) ->
    template = templateId
    if not template or template.length is 0
      msg = "Could not find template: '" + templateId + "'"
      err = new Error(msg)
      err.name = "NoTemplateError"
      throw err
    return templateId


  Marionette.TemplateCache::compileTemplate = (rawTemplate) ->
    return Handlebars.compile rawTemplate


    # Set up and start the frontend
  app = new Marionette.Application()
  app.addRegions mainRegion: "body"

  app.addInitializer ->
    layout = new MainLayout()
    @mainRegion.show layout

    cats = new Categories JSON.parse(texts), parse: true
    content = new ContentView collection: cats
    result = new ResultView()

    layout.top.show new TopNavView collection: cats
    layout.content.show content
    layout.result.show result

    new Controller content: content, result: result

  app.start()