
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
  # TODO: Disabling bower for the time being. Will have to come back and properly install this
  # bower().pipe gulp.dest("#{config.base}/bower_components")


# Clean up WordPress Theme Builder
gulp.task "clean", (cb) ->
  helper.out "Running Clean task"
  # Clear out all folders in the theme
  del.sync([
    "#{config.wordpress.theme.dest}/**/*"
    "#{config.wordpress.theme.dest}"
  ], force: true)

  cb()


# Default function of WordPress Theme Builder
gulp.task "default", (cb) ->
  helper.out "Running Default task"

  gulp.start "clean", "app", "php", "images", "js", "css"


# Watch function of WordPress Theme Builder
gulp.task "watch", ->
  helper.out "Running Watch task"

  gulp.start "default"

  # Livereload listener
  liveReload.listen()

  watch config.php.src,    -> gulp.start "php"
  watch config.css.sass,   -> gulp.start "css"
  watch config.images.src, -> gulp.start "images"
  watch config.js.coffee,  -> gulp.start "js"
