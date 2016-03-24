gulp       = require "gulp"
gulpif     = require "gulp-if"
livereload = require "gulp-livereload"
sass       = require "gulp-ruby-sass"
sizereport = require "gulp-sizereport"
sourcemaps = require "gulp-sourcemaps"
uglifycss  = require "gulp-uglifycss"

paths = require "./paths"


gulp.task "css", ->
  bootstrap_url = "#{paths.base}/bower_components/bootstrap-sass/assets/stylesheets"

  # Load sass frameworks
  sass(paths.css.sass, loadPath: [bootstrap_url], sourcemap: !global.production)

    # Include the sourcemaps for debugging
    .pipe gulpif(!global.production, sourcemaps.write())
    .pipe gulpif(global.production, uglifycss())
    .pipe gulp.dest(paths.wordpress.theme.dest)
    .pipe sizereport(gzip: true, total: false)
    .pipe livereload()

