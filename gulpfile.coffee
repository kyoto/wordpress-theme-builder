# gulp

theme_name = "THEME"

gulp       = require "gulp"
yargs      = require "yargs"
coffee     = require "gulp-coffee"
concat     = require "gulp-concat"
del        = require "del"
flatten    = require "gulp-flatten"
gulpif     = require "gulp-if"
less       = require "gulp-less"
order      = require "gulp-order"
plumber    = require "gulp-plumber"
sourcemaps = require "gulp-sourcemaps"
uglify     = require "gulp-uglify"
uglifycss  = require "gulp-uglifycss"
watch      = require "gulp-watch"

production = !!(yargs.argv.production)

paths =
  "build": "../wordpress/wp-content/themes/#{theme_name}"
  "fonts": [
    "./assets/fonts/**/*"
  ]
  "images": [
    "./assets/images/**/*"
  ]
  "php": [
    "./pages/**/*.php"
    "./partials/**/*.php"
    "./functions/**/*.*"
  ]
  "js":
    "app":    "./assets/javascripts/coffee/index.coffee"
    "base":   "./assets/javascripts/js"
    "coffee": "./assets/javascripts/coffee/**/*.coffee"
  "css":
    "base": "./assets/stylesheets/css"
    "less": "./assets/stylesheets/less/**/*.less"


gulp.task "fonts", ->
  gulp.src paths.fonts
    .pipe gulp.dest("#{paths.build}/fonts/")

gulp.task "images", ->
  gulp.src paths.images
    .pipe gulp.dest("#{paths.build}/images/")

gulp.task "php", ->
  gulp.src paths.php
    .pipe gulp.dest(paths.build)

gulp.task "coffee", (cb) ->
  gulp.src paths.js.coffee
    .pipe coffee(bare: true)
    .pipe gulp.dest(paths.js.base)
  cb()

gulp.task "js", ->
  gulp.src require(paths.js.app)
    .pipe plumber()
    .pipe concat("index.js")
    .pipe gulpif(production, uglify())
    .pipe plumber.stop()
    .pipe gulp.dest(paths.build)

  gulp.src ["#{paths.js.base}/ie.js"]
    .pipe gulpif(production, uglify())
    .pipe gulp.dest(paths.build)

gulp.task "css", ->
  gulp.src ["./assets/stylesheets/less/index.less", "./assets/stylesheets/less/admin.less"]
    .pipe plumber()
    .pipe gulpif(!production, sourcemaps.init())
    .pipe less()
    .pipe gulpif(production, uglifycss())
    .pipe gulpif(!production, sourcemaps.write("./maps"))
    .pipe plumber.stop()
    .pipe gulp.dest(paths.build)

gulp.task "wordpress", ->
  gulp.src ["./style.css", "./screenshot.png"]
    .pipe gulp.dest(paths.build)

gulp.task "clean", (cb) ->
  del.sync(["#{paths.build}/images/**", "#{paths.build}/images", "#{paths.build}*"], { force: true})
  cb()

gulp.task "default", ->
  gulp.start "clean"
  gulp.start "fonts", "images", "php", "coffee", "js", "css", "wordpress"

gulp.task "watch", ->
  gulp.start "default"

  watch paths.fonts,     -> gulp.start ["fonts"]
  watch paths.images,    -> gulp.start ["images"]
  watch paths.php,       -> gulp.start ["php"]
  watch paths.js.app,    -> gulp.start ["coffee", "js"]
  watch paths.js.coffee, -> gulp.start ["coffee", "js"]
  watch paths.css.less,  -> gulp.start ["css"]
