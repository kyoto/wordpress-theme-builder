gulp.task "php", ->
  helper.out "Running PHP task"

  gulp.src "#{config.php.src}/**/*"

    # Remove all HTML comments & white-space
    .pipe gulpIf(args.production, htmlClean())

    .pipe gulp.dest(config.php.dest)

    # Live reload hook
    .pipe liveReload()

