gulp       = require "gulp"
gulpif     = require "gulp-if"
imagemin   = require "gulp-imagemin"
livereload = require "gulp-livereload"

h          = require "./helper"
paths      = require "./paths"


gulp.task "images", ->
  gulp.src "#{paths.images.src}/**/*"

    # Optimize images using imagemin
    .pipe gulpif(production, imagemin(progressive: true))

    .pipe gulp.dest(paths.images.dest)

    # Livereload hook
    .pipe livereload()


# Optimizes all files uploaded files
gulp.task "images_optimize_uploads", ->

  # Optimize uploaded images
  gulp.src "#{paths.wordpress.images.src}/**/*"

    # Make a backup of the uploads
    .pipe gulp.dest("#{paths.wordpress.base}/wp-content/uploads_backup")

    # Optimize images using
    .pipe imagemin(progressive: true)

    # TODO: get the uploads directory from the wp-config file
    .pipe gulp.dest("#{paths.wordpress.base}/wp-content/uploads")
