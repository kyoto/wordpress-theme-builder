# TODO:
# - packages.json
# - coffee script
# - lint
# - less
# - bootstrap
# - image compression


# sudo npm install gulp gulp-flatten del
gulp    = require 'gulp'
flatten = require 'gulp-flatten'
del     = require 'del'

paths =
  'build': '.build/'
  'php': [
    'pages/**/*.php'
    'partials/**/*.php'
    'functions/**/*.php'
  ]
  'scripts': [
    ''
  ]
  'css': ''


gulp.task 'build', ->

  # Build the PHP files
  gulp.src paths.php
    .pipe flatten()
    .pipe gulp.dest(paths.build)


  # Build the javascript

  # Build the stylesheets


gulp.task 'clean', (cb) ->
  del([paths.build + '*'], cb)


gulp.task 'default', ->
  gulp.start('clean', 'build')



gulp.task 'watch', ->
  gulp.watch paths.php, ['default']
  # gulp.watch paths.js, ['scripts']
  # gulp.watch paths.images, ['images']
