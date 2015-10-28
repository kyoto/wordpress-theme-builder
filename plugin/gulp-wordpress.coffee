# TODO: clean up paths for Wordpress / PHP
# TODO: automate the process of storing minified files
# TODO: allow paths to be overwritten
# TODO: Find a way to have index.coffee update on watch

gulp       = require "gulp"
yargs      = require "yargs"
del        = require "del"
bower      = require "gulp-bower"
coffee     = require "gulp-coffee"
concat     = require "gulp-concat"
flatten    = require "gulp-flatten"
gulpif     = require "gulp-if"
htmlclean  = require "gulp-htmlclean"
imagemin   = require "gulp-imagemin"
order      = require "gulp-order"
plumber    = require "gulp-plumber"
sass       = require "gulp-ruby-sass"
sizereport = require "gulp-sizereport"
sourcemaps = require "gulp-sourcemaps"
uglify     = require "gulp-uglify"
uglifycss  = require "gulp-uglifycss"
unzip      = require "gulp-unzip"
watch      = require "gulp-watch"

regex_all     = "/**/*"


config = require "../theme/config.coffee"


theme_name        = config.theme_name        or "THEME"
theme_url         = config.theme_url         or "../theme"
wordpress_url     = config.wordpress_url     or "../../wordpress"

output_url        = "#{wordpress_url}/wp-content/themes/#{theme_name}"

# TODO: override the paths with config
paths =
  "fonts":
    "src": ["#{theme_url}/assets/fonts/#{regex_all}"]
    "dest": "#{output_url}/fonts/"
  "images":
    "src": ["#{theme_url}/assets/images/#{regex_all}"]
    "dest": "#{output_url}/images/"
  "wordpress":
    "src": ["#{theme_url}/wordpress/#{regex_all}"]
    "images":
      "src": "#{wordpress_url}/wp-content/uploads"
      "backup": "#{wordpress_url}/wp-content/uploads_backup/"

  "plugins":
    "src": "#{theme_url}/plugins"
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


process.stdout.write("\n\n==================================================\n")
process.stdout.write("Theme Name: #{theme_name}\n")
process.stdout.write("Compiling for Production\n") if production
process.stdout.write("==================================================\n\n\n")

gulp.task "init" ->
  #TODO: generate the base assets folder
  #TODO: pull a copy of the latest wordpress and setup the folder

gulp.task "fonts", ->
  gulp.src paths.fonts.src
    .pipe gulp.dest(paths.fonts.dest)

gulp.task "images", ->
  gulp.src paths.images.src
    # Optimize images
    .pipe gulpif(production, imagemin(progressive: true))
    .pipe gulp.dest(paths.images.dest)

gulp.task "php", ->
  gulp.src paths.php.src
    # Remove whitespace in the rendered HTML aspect in the PHP
    .pipe gulpif(production, htmlclean())
    .pipe gulp.dest(paths.php.dest)

gulp.task "js", (cb) ->
  # Compile all coffeescripts into javascript
  gulp.src paths.js.coffee
    .pipe coffee(bare: true)
    .pipe gulp.dest(paths.js.base)

  # Fetch the list of js files to compile
  js_files = ("#{paths.js.base}/#{js}" for js in require(paths.js.app))

  gulp.src js_files
    .pipe concat("index.js")
    .pipe gulpif(production, uglify())
    .pipe gulp.dest(output_url)
    .pipe sizereport(gzip: true, total: false)

  # Internet explorer javascript
  gulp.src ["#{paths.js.base}/ie.js"]
    .pipe gulpif(production, uglify())
    .pipe gulp.dest(output_url)

gulp.task "css", ->
  # Load sass frameworks
  sass(paths.css.sass, loadPath: [paths.css.bootstrap], sourcemap: !production)
    # Include the sourcemaps for debugging
    .pipe gulpif(!production, sourcemaps.write())
    .pipe gulpif(production, uglifycss())
    .pipe gulp.dest(output_url)
    .pipe sizereport(gzip: true, total: false)

gulp.task "wordpress", ->
  # Include any arbitrary wordpress files
  gulp.src paths.wordpress.src
    .pipe gulp.dest(output_url)

gulp.task "optimize_uploads", ->
  # Optimize uploaded images
  gulp.src "#{paths.wordpress.images.src}#{regex_all}"
    # Backup the images
    .pipe gulp.dest(paths.wordpress.images.backup)
    .pipe imagemin(progressive: true)
    .pipe gulp.dest(paths.wordpress.images.src)

gulp.task "plugins", (cb) ->
  # TODO: Check if folder exists in wp, if not copy over
  gulp.src "#{paths.plugins.src}/#{regex_all}.zip"
    .pipe unzip()
    .pipe gulp.dest(paths.plugins.dest)

gulp.task "clean", (cb) ->
  # Set up bower to obtain css/javascript libraries
  bower().pipe gulp.dest("./bower_components")

  # Clear out all folders in the theme
  del.sync(["#{output_url}/images/**", "#{output_url}/images", "#{output_url}/*"], {force: true})
  cb()

gulp.task "default", ->
  gulp.start "clean"
  gulp.start "fonts", "images", "php", "js", "css", "wordpress", "plugins"

gulp.task "watch", ->
  gulp.start "default"

  watch paths.php.src,    -> gulp.start "php"
  watch paths.fonts.src,  -> gulp.start "fonts"
  watch paths.images.src, -> gulp.start "images"
  watch paths.js.app,     -> gulp.start "js"
  watch paths.js.coffee,  -> gulp.start "js"
  watch paths.css.sass,   -> gulp.start "css"

