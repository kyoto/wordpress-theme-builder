gulp        = require "gulp"
download    = require "gulp-download"
del         = require "del"
fs          = require "fs"
runSequence = require "run-sequence"
unzip       = require "gulp-unzip"

h           = require "./helper"
paths       = require "./paths"


# Install the latest instance of WordPress or the version specified
gulp.task "wordpress-install", ->
  h.out "Installing Wordpress"

  fileName = if paths.wordpress.version == "latest" then "latest.zip" else "wordpress-#{paths.wordpress.version}.zip"

  # Remove wordpress
  if fs.existsSync "#{paths.wordpress.base}/wordpress"
    del.sync(["#{paths.wordpress.base}/wordpress"], force: true)

  if fs.existsSync "#{paths.base}/.cache/#{fileName}"
    h.out "Use local"

    gulp.src "#{paths.base}/.cache/#{fileName}"
      .pipe unzip()
      .pipe gulp.dest(paths.wordpress.base)

  else
    # Download the wordpress instance
    h.out "Downloading Wordpress"

    url = "https://wordpress.org/#{fileName}"

    return download(url)
      .pipe gulp.dest("#{paths.base}/.cache")
      .pipe unzip()
      .pipe gulp.dest(paths.wordpress.base)


# Remove all default plugins and themes
gulp.task "wordpress-remove-defaults", ->
  # Remove default themes and plugins
  del.sync([
    "#{paths.wordpress.base}/wordpress/wp-content/themes/**/*/"
    "#{paths.wordpress.base}/wordpress/wp-content/plugins/**/*/"

    # Hack: Instead of hardcoding the plugin name, use a regex
    "#{paths.wordpress.base}/wordpress/wp-content/plugins/hello.php"

  ], force: true)


# Install WordPress plugins declared in the config
gulp.task "wordpress-install-plugins", ->
  h.out "Installing Wordpress Plugins"

  # Download the wordpress plugins
  i = 0
  while i < paths.wordpress.plugins.length
    plugin = paths.wordpress.plugins[i]
    fileName = plugin.replace(/^.*[\\\/]/, '')

    if fs.existsSync("#{paths.base}/.cache/plugins/#{fileName}")
      gulp.src "#{paths.base}/.cache/plugins/#{fileName}"
        .pipe unzip()
        .pipe gulp.dest("#{paths.wordpress.base}/wordpress/wp-content/plugins")

    else
      download(plugin)
        .pipe gulp.dest("#{paths.base}/.cache/plugins/")
        .pipe unzip()
        .pipe gulp.dest("#{paths.wordpress.base}/wordpress/wp-content/plugins")

    i++


gulp.task "wordpress-theme-install", ->
  h.out "Install Theme"

  # Copy over themes directory if it doesnt exist
  unless fs.exists(paths.wordpress.theme.src)
    gulp.src "#{paths.base}/theme-default/**/*"
      .pipe gulp.dest(paths.wordpress.theme.src)


gulp.task "wordpress-init", (cb) ->

  runSequence(
    "wordpress-theme-install",
    "wordpress-install",
    "wordpress-remove-defaults",
    "wordpress-install-plugins",
    cb
  )

