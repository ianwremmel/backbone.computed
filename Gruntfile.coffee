module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-mocha-cli'
  grunt.loadNpmTasks 'grunt-umd'

  grunt.initConfig
    pkg:
      grunt.file.readJSON 'package.json'

    umd:
      dist:
        src: 'lib/backbone.computed.js'
        dest: 'dist/backbone.computed.js'
        objectToExport: 'Backbone'
        globalAlias: 'root'
        deps:
          default: ['Backbone', '_']
          amd: ['backbone', 'underscore']
          cjs: ['backbone', 'underscore']

    mochacli:
      dist: 'test/test.coffee'
      options:
        compilers:[
          'coffee:coffee-script'
        ]

  grunt.registerTask 'default', [
    'umd'
  ]

  grunt.registerTask 'test', [
    'mochacli'
  ]
