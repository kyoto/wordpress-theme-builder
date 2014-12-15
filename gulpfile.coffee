# gulp
# - less
# - bootstrap
# - compress images

# sudo npm install gulp gulp-flatten del
gulp       = require 'gulp'
browserify = require 'browserify'
coffee     = require 'gulp-coffee'
concat     = require 'gulp-concat'
del        = require 'del'
flatten    = require 'gulp-flatten'


paths =
  'build': '.build/'
  'php': [
    'pages/**/*.php'
    'partials/**/*.php'
    'functions/**/*.php'
  ]
  'js': {
    'app': './assets/javascripts/app.json',
    'coffee': 'assets/javascripts/coffee/**/*.coffee'
  }

  'css': ''



gulp.task 'php', ->
  gulp.src paths.php
    .pipe flatten()
    .pipe gulp.dest(paths.build)


gulp.task 'js', ->
  app_js = require paths.js.app

  gulp.src paths.coffee
    .pipe coffee()
    .pipe gulp.dest('assets/javascripts/js/')

  gulp.src app_js.list
    .pipe concat('index.js')
    .pipe gulp.dest(paths.build)


gulp.task 'css', ->


gulp.task 'clean', (cb) ->
  del [paths.build + '*'], cb


gulp.task 'default', ->
  gulp.start 'clean', 'php', 'js'


gulp.task 'watch', ->
  gulp.watch paths.php, ['php']
  gulp.watch paths.coffee, ['js']

  # gulp.watch paths.images, ['images']
