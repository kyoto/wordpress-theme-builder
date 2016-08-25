# CSS Related tasks

gulp       = require "gulp"
gulpif     = require "gulp-if"
livereload = require "gulp-livereload"
sass       = require "gulp-ruby-sass"
sizereport = require "gulp-sizereport"
sourcemaps = require "gulp-sourcemaps"
uglifycss  = require "gulp-uglifycss"

helper     = require "./helper"
paths      = require "./paths"


# Generate the CSS from SASS files
gulp.task "css", ->

  # TODO: Figure out how to make this more generic
  bootstrap_url = "#{paths.base}/bower_components/bootstrap-sass/assets/stylesheets"

  # Load sass frameworks
  sass(paths.css.sass, loadPath: [bootstrap_url], sourcemap: !global.production)

    # Include the sourcemaps for debugging
    .pipe gulpif(!global.production, sourcemaps.write())

    # Optimize the CSS using uglifycss
    .pipe gulpif(global.production, uglifycss())

    .pipe gulp.dest(paths.wordpress.theme.dest)

    # Generate a size report
    .pipe sizereport(gzip: true, total: false)

    # Livereload hook
    .pipe livereload()

