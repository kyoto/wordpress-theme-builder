# CSS Related tasks

# Generate the CSS from SASS files
gulp.task "css", ->

  # TODO: Figure out how to make this more generic
  bootstrap_url = "#{config.base}/bower_components/bootstrap-sass/assets/stylesheets"

  # Load sass frameworks
  sass(config.css.sass, loadPath: [bootstrap_url], sourcemap: args.development)

    # Include the source maps for debugging
    .pipe gulpIf(args.development, sourceMaps.write())

    # Optimize the CSS using uglifyCss
    .pipe gulpIf(args.production, uglifyCss())

    .pipe gulp.dest(config.wordpress.theme.dest)

    # Generate a size report
    .pipe sizeReport(gzip: true, total: false)

    # Live reload hook
    .pipe liveReload()

