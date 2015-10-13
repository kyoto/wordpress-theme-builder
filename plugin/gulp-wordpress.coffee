# TODO: clean up paths for Wordpress / PHP
# TODO: allow paths to be overwritten
# gulp

gulp       = require "gulp"
yargs      = require "yargs"
del        = require "del"
bower      = require "gulp-bower"
coffee     = require "gulp-coffee"
concat     = require "gulp-concat"
flatten    = require "gulp-flatten"
gulpif     = require "gulp-if"
sass       = require "gulp-ruby-sass"
order      = require "gulp-order"
plumber    = require "gulp-plumber"
sourcemaps = require "gulp-sourcemaps"
uglify     = require "gulp-uglify"
uglifycss  = require "gulp-uglifycss"
watch      = require "gulp-watch"

regex_all     = "/**/*"

theme_name        = "THEME"
theme_url         = "../theme"
wordpress_url     = "../../wordpress"
wordpress_plugins = []


require "../theme/config.coffee"


output_url = "#{wordpress_url}/wp-content/themes/#{theme_name}"
paths =
  "fonts":
    "src": ["#{theme_url}/assets/fonts/#{regex_all}"]
    "dest": "#{output_url}/fonts/"
  "images":
    "src": ["#{theme_url}/assets/images/#{regex_all}"]
    "dest": "#{output_url}/images/"
  "wordpress": ["#{theme_url}/assets/wordpress/#{regex_all}"]
  "plugins":
    "src": ["#{theme_url}/assets/plugins"]
    "dest": "#{wordpress_url}/wp-content/plugins"
  "php":
    "src": [
      "#{theme_url}/functions/#{regex_all}.*"
      "#{theme_url}/pages/#{regex_all}.php"
      "#{theme_url}/partials/#{regex_all}.php"
    ]
    "dest": output_url
  "js":
    "app":    "#{theme_url}/assets/javascripts/coffee/index.coffee"
    "base":   "#{theme_url}/assets/javascripts/js"
    "coffee": "#{theme_url}/assets/javascripts/coffee/#{regex_all}.coffee"
  "css":
    "base": "#{theme_url}/assets/stylesheets/"
    "sass": "#{theme_url}/assets/stylesheets/sass"
    "bootstrap": ["./bower_components/bootstrap-sass/assets/stylesheets"]


# Flag for compiling theme with production settings
production = !!(yargs.argv.production)


process.stdout.write("Theme Name: #{theme_name}\n")
gulpif(production, process.stdout.write("Compiling for Production\n\n"))

gulp.task "fonts", ->
  gulp.src paths.fonts.src
    .pipe gulp.dest(paths.fonts.dest)

gulp.task "images", ->
  gulp.src paths.images.src
    .pipe gulp.dest(paths.images.dest)

gulp.task "php", ->
  gulp.src paths.php.src
    .pipe gulp.dest(paths.php.dest)

gulp.task "js", (cb) ->
  # Compile all coffeescripts into javascript
  gulp.src paths.js.coffee
    .pipe coffee(bare: true)
    .pipe gulp.dest(paths.js.base)

  gulp.src require(paths.js.app)
    .pipe plumber()
    .pipe concat("index.js")
    .pipe gulpif(production, uglify())
    .pipe plumber.stop()
    .pipe gulp.dest(output_url)

  # Internet explorer javascript
  gulp.src ["#{paths.js.base}/ie.js"]
    .pipe gulpif(production, uglify())
    .pipe gulp.dest(output_url)

gulp.task "css", ->
  # Load sass frameworks
  sass(paths.css.sass, loadPath: [paths.css.bootstrap])
    # Include the sourcemaps for debugging
    .pipe gulpif(!production, sourcemaps.write("./maps"))
    .pipe gulpif(production, uglifycss())
    .pipe gulp.dest(output_url)

gulp.task "wordpress", ->
  # Include any arbitrary wordpress files
  gulp.src paths.wordpress
    .pipe gulp.dest(output_url)

gulp.task "plugins", ->
  # Download and unzip plugins into source plugins folder, according to URL
  # Compare folders and copy to actual plugins folder if not.

gulp.task "clean", (cb) ->
  # Sets up bower
  bower().pipe gulp.dest("./bower_components")

  # Clear out all folders in the theme
  del.sync(["#{output_url}/images/**", "#{output_url}/images", "#{output_url}/*"], {force: true})
  cb()

gulp.task "default", ->
  gulp.start "clean"
  gulp.start "fonts", "images", "php", "js", "css", "wordpress", "plugins"

gulp.task "watch", ->
  gulp.start "default"

  watch paths.fonts.src,  -> gulp.start "fonts"
  watch paths.images.src, -> gulp.start "images"
  watch paths.php.src,    -> gulp.start "php"
  watch paths.js.app,     -> gulp.start "js"
  watch paths.js.coffee,  -> gulp.start "js"
  watch paths.css.sass,   -> gulp.start "css"

