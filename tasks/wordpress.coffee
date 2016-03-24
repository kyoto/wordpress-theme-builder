gulp        = require "gulp"
download    = require "gulp-download"
runSequence = require "run-sequence"
unzip       = require "gulp-unzip"


h     = require "./helper"
paths = require "./paths"


gulp.task "wordpress-install", ->
  version  = "4.4.2"
  filename = "wordpress-#{version}.zip"
  url      = "https://wordpress.org/#{filename}"

  # Remove wordpress
  del.sync([paths.wordpress.base], force: true)

  # TODO: skip the download by storing the file in a cached location

  # Download the wordpress instance
  return download(url)
    .pipe unzip()
    .pipe gulp.dest(paths.base)


gulp.task "wordpress-remove-defaults", ->

  # Remove default themes and plugins
  del.sync([
    "#{paths.wordpress.base}/wp-content/themes/**/*/"
    "#{paths.wordpress.base}/wp-content/plugins/**/*/"

    # Hack: Instead of hardcoding the plugin name, use a regex
    "#{paths.wordpress.base}/wp-content/plugins/hello.php"

  ], force: true)


gulp.task "wordpress-install-plugins", ->

  # Download the wordpress plugins
  i = 0
  while i < paths.wordpress.plugins.length
    download(paths.wordpress.plugins[i])
      .pipe unzip()
      .pipe gulp.dest("#{paths.wordpress.base}/wp-content/plugins")

    i++




gulp.task "wordpress-init", (cb) ->
  # run_sequence "wordpress-install", "wordpress-remove-defaults", "wordpress-install-plugins", cb
  runSequence "wordpress-install-plugins", cb


