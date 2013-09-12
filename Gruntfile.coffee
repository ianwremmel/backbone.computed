module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-uglify'

  grunt.loadNpmTasks 'grunt-mocha-cli'
  grunt.loadNpmTasks 'grunt-umd'

  grunt.initConfig
    pkg:
      grunt.file.readJSON 'package.json'

    clean:
      dist: [
        'dist'
      ]
      tmp: [
        '.tmp'
      ]

    jshint:
      options:
        jshintrc: '.jshintrc'
      lib:
        files:
          src: 'lib'


    umd:
      dist:
        src: 'lib/backbone.computed.js'
        dest: '.tmp/backbone.computed.js'
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

    copy:
      dist:
        dest: 'dist/backbone.computed.js'
        src: '.tmp/backbone.computed.js'

    uglify:
      dist:
        options:
          sourceMap: 'dist/backbone.computed.map'
          mangle: false
        files:
          'dist/backbone.computed.min.js': '.tmp/backbone.computed.js'


  grunt.registerTask 'default', [
    'clean:dist'
    'jshint:lib'
    'umd'
    'mochacli'
    'copy'
    'uglify'
    'clean:tmp'
  ]

  grunt.registerTask 'test', [
    'clean:dist'
    'umd'
    'mochacli'
    'clean:tmp'
  ]
