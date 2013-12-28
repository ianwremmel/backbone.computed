module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.registerTask 'build', [
    'clean'
    'jshint'
    'browserify'
  ]

  grunt.registerTask 'test', [
    'build'
    'mochacli'
  ]

  grunt.registerTask 'default', ['test']

  grunt.initConfig
    pkg:
      grunt.file.readJSON 'package.json'

    clean:
      dist: [
        'dist'
      ]

    jshint:
      options:
        reporter: require('jshint-stylish')
        jshintrc: '.jshintrc'
      src: [
        'lib'
      ]

    browserify:
      dist:
        src: 'lib/backbone.computed.js'
        dest: 'dist/backbone.computed.js'
        options:
          # TODO place common libraries here (lodash, jquery, etc), to prevent
          # them being included in the output file. It will be up to the
          # library's consumer to supply these dependencies.
          external: [
            'backbone'
            'underscore'
          ]
          # The library will be available as backbone.computed
          standalone: 'backbone.computed'

    mochacli:
      options:
        compilers:[
          'coffee:coffee-script'
        ]
      spec: 'test/test.coffee'
