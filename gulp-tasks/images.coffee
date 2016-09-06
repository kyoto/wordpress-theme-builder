# Optimizes all image files that are part of the theme
gulp.task "images", ->
  helper.out "Running Images task"

  gulp.src "#{config.images.src}/**/*"
    # Optimize images using imageMin
    .pipe gulpIf(args.production, imageMin(progressive: true))

    .pipe gulp.dest(config.images.dest)

    # Live reload hook
    .pipe liveReload()


# Optimizes all uploaded image files
gulp.task "images-optimize-uploads", ->
  timestamp = dateFormat(new Date(), "yyyymmddhMMss")

  gulp.src "#{config.wordpress.folder}/wp-content/uploads/**/*"

    # Make a backup of the current uploads folder
    .pipe gulp.dest("#{config.wordpress.folder}/wp-content/uploads-#{timestamp}")

    # Optimize images using
    .pipe imageMin(progressive: true)

    # TODO: get the uploads directory from the wp-config file
    .pipe gulp.dest("#{config.wordpress.folder}/wp-content/uploads")
