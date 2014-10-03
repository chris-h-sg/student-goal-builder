define [
], ->

  class Item extends Backbone.Model

    parse: (data) ->
      if data?.content
        data.content = new Categories data.content, parse: true, level: (data.level ? 0) + 1, excluded: data.excluded
      data.short ?= data.text.toLowerCase().replace /[\s|\/]+/g, '-'
      return data


  class Categories extends Backbone.Collection

    initialize: (data, options) ->
      options.level ?= 0


    model: (data, options) ->
      return new Item _.extend(data, level: options.level), options


    parse: (data, options) ->
      if options.excluded > 0
        data.push text: 'EXCLUDED', excluded: options.excluded
      return data