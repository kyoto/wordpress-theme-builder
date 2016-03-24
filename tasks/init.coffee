gulp        = require "gulp"
bower       = require "gulp-bower"
del         = require "del"
runSequence = require "run-sequence"
util        = require "util"
watch       = require "gulp-watch"


h     = require "./helper"
paths = require "./paths"


gulp.task "init", (cb) ->
  runSequence(
    "bower",
    "wordpress-init",
    "default",
    cb
  )


gulp.task "bower", ->
  # Set up bower to obtain css/javascript libraries
  bower().pipe gulp.dest("#{paths.base}/bower_components")


gulp.task "clean", (cb) ->
  # Clear out all folders in the theme
  del.sync([
    "#{paths.wordpress.theme.dest}/**/*"
    "#{paths.wordpress.theme.dest}"
  ], force: true)

  cb()


gulp.task "default", ->
  gulp.start "clean"
  gulp.start "app", "images", "js", "css"


gulp.task "watch", ->
  gulp.start "default"

  livereload.listen()

  watch paths.images.src, -> gulp.start "images"
  watch paths.js.coffee,  -> gulp.start "js"
  watch paths.css.sass,   -> gulp.start "css"
