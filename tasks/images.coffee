gulp       = require "gulp"
gulpif     = require "gulp-if"
imagemin   = require "gulp-imagemin"
livereload = require "gulp-livereload"


h     = require "./helper"
paths = require "./paths"


gulp.task "images", ->
  gulp.src "#{paths.images.src}/**/*"
    # Optimize images
    .pipe gulpif(production, imagemin(progressive: true))
    .pipe gulp.dest(paths.images.dest)
    .pipe livereload()


gulp.task "images_optimize_uploads", ->

  # Optimize uploaded images
  gulp.src "#{paths.wordpress.images.src}/**/*"

    # Make a backup of the uploads
    .pipe gulp.dest("#{paths.wordpress.base}/backup/wp-content/uploads_backup")

    # Optimize images
    .pipe imagemin(progressive: true)
    .pipe gulp.dest("#{paths.wordpress.base}/backup/wp-content/uploads")
