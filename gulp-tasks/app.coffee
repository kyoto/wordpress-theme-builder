gulp.task "app", ->
  # Include any WordPress files
  gulp.src config.app.src

    # Remove all the white-space in any PHP and SVG
    .pipe gulpIf(args.production, htmlClean())
    .pipe gulp.dest(config.app.dest)

    # Live reload hook
    .pipe liveReload()


gulp.task "fonts", ->
  gulp.src "#{config.fonts.src}/**/*"
    .pipe gulp.dest(config.fonts.dest)


gulp.task "browser-sync", ->
  browserSync.init
    proxy: config.wordpress.host

