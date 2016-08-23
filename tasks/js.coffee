# TODO: Find a way to have index.coffee update on watch

gulp       = require "gulp"
gulpif     = require "gulp-if"
coffee     = require "gulp-coffee"
concat     = require "gulp-concat"
sizereport = require "gulp-sizereport"
livereload = require "gulp-livereload"
uglify     = require "gulp-uglify"

h     = require "./helper"
paths = require "./paths"


# Compile all coffeescripts into javascript
gulp.task "js", (cb) ->

  gulp.src "#{paths.js.coffee}/**/*.coffee"
    .pipe coffee(bare: true)
    .pipe gulp.dest(paths.js.src)

  # Concat and minify all javascript files
  js_files = ("#{paths.js.src}/#{file_name}.js" for file_name in require("#{paths.js.coffee}/index.coffee"))

  gulp.src js_files
    # Concat all the Javascript files
    .pipe concat("index.js")

    # Optimize the javascript
    .pipe gulpif(global.production, uglify())

    .pipe gulp.dest(paths.wordpress.theme.dest)

    # Generate a size report
    .pipe sizereport(gzip: true, total: false)

    # Livereload hook
    .pipe livereload()

  # Internet explorer javascript
  gulp.src ["#{paths.js.src}/ie.js"]
    .pipe gulpif(global.production, uglify())
    .pipe gulp.dest(paths.wordpress.theme.dest)


gulp.task "js_minify", ->

  # TODO: List file sizes
  gulp.src "#{paths.js.src}/*.js"
    .pipe uglify()
    .pipe gulp.dest("#{paths.js.src}/../min")

