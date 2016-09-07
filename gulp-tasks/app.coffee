gulp.task "app", ->
  helper.out "Running App task"

  gulp.src "#{config.app.src}/**/*"
    .pipe gulp.dest(config.app.dest)


# Uses the browser_sync library to allow the website to be synced across browsers
gulp.task "browser-sync", ->
  helper.out "Running browser sync task"

  browserSync.init
    proxy: config.wordpress.host


# Generate a list of all the TODOs in the project
gulp.task "todos", ->
  helper.out "Running TODOs task"

  gulp.src "#{config.wordpress.theme.src}/**/*.+(php|scss|less|coffee)"

    .pipe todo(fileName: "TODOS.md")

    .pipe gulp.dest(config.wordpress.theme.src)
