gulp        = require "gulp"
bower       = require "gulp-bower"
del         = require "del"
runSequence = require "run-sequence"
util        = require "util"
watch       = require "gulp-watch"

h           = require "./helper"
paths       = require "./paths"


# Initializes WordPress Theme Builder
gulp.task "init", (cb) ->
  runSequence(
    "bower",
    "wordpress-init",
    "default",
    cb
  )


# Set up bower to obtain css/javascript libraries
gulp.task "bower", ->
  bower().pipe gulp.dest("#{paths.base}/bower_components")


# Clean up WordPress Theme Builder
gulp.task "clean", (cb) ->
  # Clear out all folders in the theme
  del.sync([
    "#{paths.wordpress.theme.dest}/**/*"
    "#{paths.wordpress.theme.dest}"
  ], force: true)

  cb()


# Default function of WordPress Theme Builder
gulp.task "default", ->
  gulp.start "clean"
  gulp.start "app", "images", "js", "css"


# Watch function of WordPress Theme Builder
gulp.task "watch", ->
  gulp.start "default"

  # Livereload listener
  livereload.listen()

  watch paths.images.src, -> gulp.start "images"
  watch paths.js.coffee,  -> gulp.start "js"
  watch paths.css.sass,   -> gulp.start "css"
