gulp.task "app", ->
  helper.out "Running App task"

  gulp.src "#{config.app.src}/**/*"
    .pipe gulp.dest(config.app.dest)


gulp.task "browser-sync", ->
  browserSync.init
    proxy: config.wordpress.host

