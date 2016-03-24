
gulp        = require "gulp"
yargs       = require "yargs"
del         = require "del"
fs          = require "fs"
path        = require "path"
requireDir  = require "require-dir"
runSequence = require "run-sequence"
util        = require "util"

bower       = require "gulp-bower"
coffee      = require "gulp-coffee"
concat      = require "gulp-concat"
download    = require "gulp-download"
flatten     = require "gulp-flatten"
gulpif      = require "gulp-if"
htmlclean   = require "gulp-htmlclean"
imagemin    = require "gulp-imagemin"
order       = require "gulp-order"
plumber     = require "gulp-plumber"
uglify      = require "gulp-uglify"
unzip       = require "gulp-unzip"
watch       = require "gulp-watch"


# Flag for compiling theme with production settings
global.production = !!(yargs.argv.production)


h     = require "./tasks/helper"
paths = require "./tasks/paths"

require "./tasks/css"


gulp.start "css"


gulp.task "init", ->
  #TODO: generate the base assets folder

  # # Initialize the wordpress instance
  # gulp.start "wordpress-init"

  # # Set up bower to obtain css/javascript libraries
  # bower().pipe gulp.dest("#{paths.base}/bower_components")

  # # Copy over themes directory if it doesnt exist
  # unless fs.exists(paths.wordpress.theme.src)
  #   gulp.src "#{paths.base}/theme-default/**/*"
  #     .pipe gulp.dest(paths.wordpress.theme.src)





# gulp.task "clean", (cb) ->
#   # Clear out all folders in the theme
#   del.sync(["#{output_url}/images/**", "#{output_url}/images", "#{output_url}/*", output_url], force: true)
#   cb()


# gulp.task "default", ->
#   gulp.start "clean"
#   gulp.start "fonts", "images", "php", "js", "css", "wordpress", "plugins"


# gulp.task "watch", ->
#   gulp.start "default"

#   livereload.listen()

#   watch paths.fonts.src,  -> gulp.start "fonts"
#   watch paths.images.src, -> gulp.start "images"
#   watch paths.php.src,    -> gulp.start "php"
#   watch paths.js.coffee,  -> gulp.start "js"
#   watch paths.js.app,     -> gulp.start "js"
#   watch paths.css.sass,   -> gulp.start "css"






# gulp.start "watch"
gulp.start "init"