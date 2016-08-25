gulp       = require "gulp"
gulpif     = require "gulp-if"
htmlclean  = require "gulp-htmlclean"
livereload = require "gulp-livereload"

helper     = require "./helper"
paths      = require "./paths"


gulp.task "app", ->

  # Include any arbitrary wordpress files
  gulp.src paths.app.src

    # Remove all the white-space in any PHP and SVG
    .pipe gulpif(global.production, htmlclean())
    .pipe gulp.dest(paths.app.dest)

    # Livereload hook
    .pipe livereload()
