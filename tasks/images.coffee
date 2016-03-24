
gulp.task "images", ->
  gulp.src paths.images.src
    # Optimize images
    .pipe gulpif(production, imagemin(progressive: true))
    .pipe gulp.dest(paths.images.dest)


gulp.task "optimize_uploads", ->

  # Optimize uploaded images
  gulp.src "#{paths.wordpress.images.src}**/*"
    # Backup the images
    .pipe gulp.dest(paths.wordpress.images.backup)
    .pipe imagemin(progressive: true)
    .pipe gulp.dest(paths.wordpress.images.src)
