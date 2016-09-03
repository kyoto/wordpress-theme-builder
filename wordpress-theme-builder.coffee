# NPM Functions
global.browserSync  = require("browser-sync").create()
global.del          = require "del"
global.fs           = require "graceful-fs"
global.objectMerge  = require "object-merge"
global.path         = require "path"
global.runSequence  = require "run-sequence"
global.util         = require "util"
global.yargs        = require "yargs"

# Gulp tasks
global.gulp         = require "gulp"
global.bower        = require "gulp-bower"
global.coffee       = require "gulp-coffee"
global.concat       = require "gulp-concat"
global.download     = require "gulp-download"
global.gulpIf       = require "gulp-if"
global.htmlClean    = require "gulp-htmlclean"
global.imageMin     = require "gulp-imagemin"
global.liveReload   = require "gulp-livereload"
global.requireTasks = require "gulp-require-tasks"
global.sass         = require "gulp-ruby-sass"
global.sizeReport   = require "gulp-sizereport"
global.sourceMaps   = require "gulp-sourcemaps"
global.uglify       = require "gulp-uglify"
global.uglifyCss    = require "gulp-uglifycss"
global.unzip        = require "gulp-unzip"
global.watch        = require "gulp-watch"

# WordPress Theme Builder functions
global.helper       = require "./helper"
global.args         = require "./arguments"
global.config       = require "./config"

# WordPress Theme Builder tasks
requireTasks path: "#{__dirname}/gulp-tasks"


# Run the selected task
gulp.start args.taskName


