gulp  = require "gulp"


require "./tasks/app"
require "./tasks/css"
require "./tasks/images"
require "./tasks/js"
require "./tasks/wordpress"
require "./tasks/init"


gulp.start "init"