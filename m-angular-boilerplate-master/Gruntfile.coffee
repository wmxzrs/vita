"use strict"
module.exports = (grunt) ->
  require("time-grunt") grunt
  rewrite = require 'connect-modrewrite'

  fs = require 'fs'
  if fs.existsSync('app/index.html')
    indexFile = 'index.html'
  else
    indexFile = 'index.php'

  # Project configuration.
  grunt.config.init
    buildEnv: grunt.option("buildEnv") or "prod"
    repoName: grunt.option("repoName")
    pkg: grunt.file.readJSON("package.json")
    config: grunt.file.readJSON("grunt.json")
    bump:
      options:
        files: "<%= config.bump.options.files %>"
        commit: true
        commitFiles: "<%= config.bump.options.commitFiles %>"
        commitMessage: "Release v%VERSION%"
        createTag: false
        tagName: "v%VERSION%"
        tagMessage: "Version %VERSION%"
        push: false

    changelog:
      options:
        dest: "CHANGELOG.md"
        template: "changelog.tpl"

    clean:
      build: [
        "dist/"
        ".tmp/"
      ]
      tmp: [".tmp/"]

    concat:
      dev:
        src: [
          "app/js/config.js"
          "app/config/**/*.js"
          "app/js/app.js"
          "app/js/coffee/**/*.js"
        ]
        dest: "app/js/app.js"

      prod:
        src: [
          ".tmp/js/config.js"
          ".tmp/config/**/*.js"
          "app/js/app.js"
          "app/js/coffee/**/*.js"
        ]
        dest: ".tmp/js/app.js"

      template:
        src: [
          ".tmp/concat/js/scripts.min.js"
          ".tmp/js/templates.js"
        ]
        dest: ".tmp/concat/js/scripts.min.js"

    copy:
      init:
        files: [
          {
            expand: true
            cwd: 'app/'
            src: ['htaccess.dist']
            dest: 'app/'
            rename: (dest, src) ->
              dest + '.htaccess'
          }
          {
            expand: true
            cwd: 'app/config/'
            src: ['config.coffee.dist']
            dest: 'app/config/'
            rename: (dest, src) ->
              dest + 'config.coffee'
          }
          {
            expand: true
            cwd: 'app/js/'
            src: ['local.js.dist']
            dest: 'app/js/'
            rename: (dest, src) ->
              dest + 'local.js'
          }
        ]
      tmp:
        files: [
          expand: true
          cwd: "app/"
          src: ["**"]
          dest: ".tmp/"
        ]

      config:
        files:[
          {
            expand: true
            cwd: ".tmp/config/"
            src: ["config.coffee.<%= buildEnv %>"]
            dest: ".tmp/config/"
            rename: (dest, src) ->
              dest + "config.coffee"
          }
        ]

      build:
        files: [
          {
            expand: true
            cwd: ".tmp/"
            src: [
              "index.*"
              "*.html"
              "js/lib/*.js"
              "image/**"
              "fonts/*"
            ]
            dest: "dist/"
          }
          {
            expand: true
            cwd: ".tmp/"
            src: [
              "htaccess.dist"
            ]
            dest: "dist/"
            rename: (dest, src) ->
              dest + ".htaccess"
          }
          {
            expand: true
            cwd: "app/components/font-awesome/"
            src: ["fonts/*"]
            dest: "dist/"
          }
          {
            expand: true
            cwd: "app/components/bootstrap/dist/"
            src: ["fonts/*"]
            dest: "dist/"
          }
          {
            expand: true
            cwd: "app/components/zeroclipboard/"
            src: ["ZeroClipboard.swf"]
            dest: "dist/asset/"
          }
        ]
      source:
        files: [
          {
            expand: true
            cwd: ".tmp/concat/"
            src: [
              "js/scripts.min.js"
            ]
            dest: "dist/"
          }
        ]

    html2js:
      partials:
        src: ["app/partials/**/*.html"]
        dest: ".tmp/js/templates.js"
        module: "templates"
        options:
          base: "app/"

    jshint:
      files: [
        "app/js/**/*.js"
        "!app/components/**"
      ]
      options:
        jshintrc: ".jshintrc"

    less:
      dev:
        options:
          syncImport: true
        files:
          "app/css/styles.css": ["app/css/less/build.less"]

    lesslint:
      src: ["app/css/less/**.less"]

    manifest:
      build:
        options:
          basePath: "dist/"
          timestamp: true

        src: ["**/**.**"]
        dest: "dist/manifest.appcache"

    "regex-replace":
      strict:
        src: [".tmp/concat/js/scripts.min.js"]
        actions: [
          name: "use strict"
          search: "\\'use strict\\';"
          replace: ""
          flags: "gmi"
        ]

      manifest:
        src: [".tmp/index.*"]
        actions: [
          name: "manifest"
          search: "<html>"
          replace: "<html manifest=\"manifest.appcache\">"
        ]

      templates:
        src: [".tmp/concat/js/scripts.min.js"]
        actions: [
          name: "templates"
          search: /Config.name,\s\[/
          replace: "Config.name, ['templates',"
          flags: "gmi"
        ]

      travis:
        src: ['dist/index.html']
        actions: [
          name: "travis"
          search: /<base href="\/">/
          replace: '<base href="\/<%= repoName %>\/">'
        ]

      sourceMap:
        src: ['dist/js/scripts.min.map']
        actions: [
          name: "sourceMap"
          search: /"sources":\["([^"]*)"\]/
          replace: '"sources":["scripts.min.js"]'
        ]

    karma:
      unit:
        configFile: "karma.unit.conf.js"

      e2e:
        configFile: "karma.e2e.conf.js"

    coffee:
      configProd:
        files:
          ".tmp/js/config.js": [
            ".tmp/config/config.coffee"
            ".tmp/config/**/*.coffee"
          ]
      configDev:
        files:
          "app/js/config.js": [
            "app/config/config.coffee"
            "app/config/**/*.coffee"
          ]
      scripts:
        files:
          "app/js/app.js": [
            "app/js/coffee/config.coffee"
            "app/js/coffee/m-util.coffee"
            "app/js/coffee/directives/m-directive.coffee"
            "app/js/coffee/main.coffee"
            "app/js/coffee/**/*.coffee"
          ]
          "test/unit/CtrlSpec.js": ["test/coffee/unit/*.coffee"]

    coffeelint:
      app: ["app/js/coffee/**/*.coffee"]
      tests:
        files:
          src: ["test/coffee/**/*.coffee"]

        options:
          no_trailing_whitespace:
            level: "error"

    watch:
      scripts:
        files: [
          "app/config/**/*.*"
          "app/js/coffee/**/*.*"
          "test/coffee/**/*.*"
        ]
        tasks: ["do-watch"]
        options:
          debounceDelay: 300
          atBegin: true

      styles:
        files: ["app/css/less/**/*.less"]
        tasks: ["less:dev"]
        options:
          atBegin: true

      livereload:
        options:
          livereload: true

        files: [
          "app/js/*.js"
          "app/css/styles.css"
          "app/index.*"
          "app/partials/**/*.html"
        ]
    # Static file server
    connect:
      server:
        options:
          port: 8000
          hostname: '127.0.0.1'
          livereload: true
          keepalive: true
          open: true
          useAvailablePort: true
          base:
            path: 'app'
            options:
              index: indexFile
              setHeaders: (res, path, stat) ->
                if /\.php$/.test path
                  res.setHeader 'Content-Type', 'text/html; charset=UTF-8'
          # http://danburzo.ro/grunt/chapters/server/
          middleware: (connect, options, middlewares) ->
            # mod-rewrite behavior
            rules = [
              "!\\.html|\\.js|\\.css|\\.svg|\\.jp(e?)g|\\.png|\\.gif|\\.woff2|\\.ttf$ /#{indexFile}"
            ]
            middlewares.unshift rewrite(rules)

            return middlewares

    # Concurrent tasks
    concurrent:
      dev:
        tasks: ['connect', 'watch']
        options:
          logConcurrentOutput: true

    ngdocs:
      options:
        dest: 'app/docs'
        scripts: ['dist/js/scripts.min.0.js']
        styles: ['dist/css/styles.min.0.css']
      all: ['app/js/app.js']

    "git-rev-parse":
      build:
        options:
          prop: "buildCommitId"
          number: "8"

    ngAnnotate:
      dist:
        files:
          '.tmp/concat/js/scripts.min.js': '.tmp/concat/js/scripts.min.js'

    filerev:
      options:
        encoding: 'utf8'
        algorithm: 'md5'
        length: 8
      images:
        src: [
          # do not process subfolder of image/, in case for dynamic img urls,
          # which will not be replaced correctly.
          # you can put dynamic usage images to subfolders
          'dist/image/*.{jpg,jpeg,gif,png,webp}'
          'dist/js/scripts.*.js'
          'dist/css/styles.*.css'
        ]

    useminPrepare:
      html: '.tmp/index.*'

    # Cache busting: Replace js/css/image references in tpls
    usemin:
      html: ['dist/index.*', 'dist/js/scripts.min.*.js', 'dist/css/styles.min.*.css']
      options:
        # add 'dist/css' here is for the case url('../image/xx.png')
        assetsDirs: ['dist', 'dist/css']

    uglify:
      options:
        sourceMap: "prod" != (grunt.option("buildEnv") or "prod")

  # Additional task plugins
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-cssmin"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-less"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-conventional-changelog"
  grunt.loadNpmTasks "grunt-bump"
  grunt.loadNpmTasks "grunt-html2js"
  grunt.loadNpmTasks "grunt-lesslint"
  grunt.loadNpmTasks "grunt-manifest"
  grunt.loadNpmTasks "grunt-regex-replace"
  grunt.loadNpmTasks "grunt-karma"
  grunt.loadNpmTasks "grunt-coffeelint"
  grunt.loadNpmTasks "grunt-concurrent"
  grunt.loadNpmTasks "grunt-ngdocs"
  grunt.loadNpmTasks "grunt-usemin"
  grunt.loadNpmTasks "grunt-ng-annotate"
  grunt.loadNpmTasks "grunt-filerev"

  grunt.registerTask "init", [
    "copy:init"
  ]

  grunt.registerTask "start", [
    "concurrent:dev"
  ]

  grunt.registerTask "test", [
    "coffeelint"
    "lesslint"
  ]

  grunt.registerTask "do-watch", [
    "coffee:configDev"
    "coffee:scripts"
    "coffeelint"
    "concat:dev"
    #"ngdocs"
  ]

  grunt.registerTask 'do-usemin', [
    'useminPrepare'
    'concat:generated'
    'concat:template'
    "regex-replace:strict"
    "regex-replace:templates"
    'ngAnnotate'
    'cssmin:generated'
    'uglify:generated'
    "regex-replace:manifest"
    "copy:build"
    "regex-replace:sourceMap"
    'filerev'
    'usemin'
    'copy:source'
  ]

  grunt.registerTask "build", [
    #    'test',
    "clean:build"
    "less:dev"
    "copy:tmp"
    "copy:config"
    "coffee:configProd"
    "coffee:scripts"
    "concat:prod"
    "html2js"
    "do-usemin"
    "clean:tmp"
    "manifest"
    "changelog"
    "do-watch" # revert local files
  ]
  return
