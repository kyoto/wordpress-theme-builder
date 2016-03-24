gulp  = require "gulp"
bower = require "gulp-bower"
del   = require "del"
fs    = require "fs"
util  = require "util"
watch = require "gulp-watch"

h     = require "./helper"
paths = require "./paths"


gulp.task "init", ->
  #TODO: generate the base assets folder

  # Initialize the wordpress instance
  gulp.start "wordpress-init"

  # Set up bower to obtain css/javascript libraries
  bower().pipe gulp.dest("#{paths.base}/bower_components")

  # Copy over themes directory if it doesnt exist
  unless fs.exists(paths.wordpress.theme.src)
    gulp.src "#{paths.base}/theme-default/**/*"
      .pipe gulp.dest(paths.wordpress.theme.src)


gulp.task "clean", (cb) ->
  # Clear out all folders in the theme
  del.sync([
    "#{paths.wordpress.theme.dest}/**/*"
    "#{paths.wordpress.theme.dest}"
  ], force: true)

  cb()


gulp.task "default", ->
  gulp.start "clean"
  gulp.start "app", "images", "js", "css", "wordpress"


gulp.task "watch", ->
  gulp.start "default"

  livereload.listen()

  watch paths.images.src, -> gulp.start "images"
  watch paths.js.coffee,  -> gulp.start "js"
  watch paths.css.sass,   -> gulp.start "css"
