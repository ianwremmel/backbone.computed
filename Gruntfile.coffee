module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-mocha-cli'

  grunt.initConfig
    pkg:
      grunt.file.readJSON 'package.json'

    mochacli:
      dist: 'test/test.coffee'
      options:
        compilers:[
          'coffee:coffee-script'
        ]

  grunt.registerTask 'test', [
    'mochacli'
  ]
