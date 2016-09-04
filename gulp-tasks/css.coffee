# CSS Related tasks

# Generate the CSS from SASS files
gulp.task "css", ->
  helper.out "Running Css task"

  gulp.src "#{config.css.sass}/*"
    # Include the source maps for debugging
    .pipe gulpIf(args.development, sourceMaps.init())

    .pipe sass()

    .pipe gulpIf(args.development, sourceMaps.write())

    # Optimize the CSS using uglifyCss
    .pipe gulpIf(args.production, uglifyCss())

    .pipe gulp.dest(config.wordpress.theme.dest)

    # Generate a size report
    .pipe sizeReport(gzip: true, total: false)

    # Live reload hook
    .pipe liveReload()
