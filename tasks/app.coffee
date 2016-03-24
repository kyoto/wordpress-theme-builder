gulp       = require "gulp"
gulpif     = require "gulp-if"
htmlclean  = require "gulp-htmlclean"
livereload = require "gulp-livereload"

h     = require "./helper"
paths = require "./paths"


gulp.task "app", ->

  # Include any arbitrary wordpress files
  gulp.src paths.app.src
    .pipe gulpif(global.production, htmlclean())
    .pipe gulp.dest(paths.app.dest)
    .pipe livereload()
