gulp.task "js", (cb) ->
  # Compile all coffeescripts into javascript

  gulp.src "#{paths.js.coffee}/**/*.coffee"
    .pipe coffee(bare: true)
    .pipe gulp.dest(paths.js.base)

  # Concat and minify all javascript files
  js_files = ("#{paths.js.base}/#{file_name}.js" for file_name in require("#{paths.js.coffee}/index.coffee"))

  gulp.src js_files
    .pipe concat("index.js")
    .pipe gulpif(production, uglify())
    .pipe gulp.dest(output_url)
    .pipe sizereport(gzip: true, total: false)
    .pipe livereload()

  # Internet explorer javascript
  gulp.src ["#{paths.js.base}/ie.js"]
    .pipe gulpif(production, uglify())
    .pipe gulp.dest(output_url)


gulp.task "minify_js", ->
  # TODO: List file sizes
  gulp.src "#{paths.js.base}/*.js"
    .pipe uglify()
    .pipe gulp.dest("#{paths.js.base}/../min")
