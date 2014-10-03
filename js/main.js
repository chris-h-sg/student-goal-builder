/* Configuration for RequireJS, sets folder paths and dependencies for non-AMD modules. */
require({
    paths: {
        'lib': '../lib',
        'html': '../html',
        text: '../lib/text',
        cs: '../lib/cs',
        'coffee-script': '../lib/coffee-script',
        'backbone': '../lib/backbone',
        'jquery': '../lib/jquery',
        'underscore': '../lib/lodash'
    },
    shim: {
        'lib/bootstrap.min.js': ['jquery'],
        'cs!startup': [
            'lib/marionette'
        ]
    }
}, [ 'cs!startup' ]);