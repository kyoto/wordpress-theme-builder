# TODO: Find a way to have index.coffee update on watch

# Compile all coffeescripts into javascript
gulp.task "js", (cb) ->

  gulp.src "#{config.js.coffee}/**/*.coffee"
    .pipe coffee(bare: true)
    .pipe gulp.dest(config.js.src)

  # Concat and minify all javascript files
  js_files = ("#{config.js.src}/#{file_name}.js" for file_name in require("#{config.js.coffee}/index.coffee"))

  gulp.src js_files
    # Concat all the Javascript files
    .pipe concat("index.js")

    # Optimize the javascript
    .pipe gulpIf(args.production, uglify())

    .pipe gulp.dest(config.wordpress.theme.dest)

    # Generate a size report
    .pipe sizeReport(gzip: true, total: false)

    # Live reload hook
    .pipe liveReload()

  # Internet explorer javascript
  gulp.src ["#{config.js.src}/ie.js"]
    .pipe gulpIf(args.production, uglify())
    .pipe gulp.dest(config.wordpress.theme.dest)


gulp.task "js_minify", ->

  # TODO: List file sizes
  gulp.src "#{config.js.src}/*.js"
    .pipe uglify()
    .pipe gulp.dest("#{config.js.src}/../min")

