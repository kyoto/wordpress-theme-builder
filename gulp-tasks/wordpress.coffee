
# Initialize WordPress
gulp.task "wordpress-init", (cb) ->

  # Run the tasks sequentially as they have depencies
  runSequence(
    "wordpress-install",
    "wordpress-default-theme-install",
    "wordpress-remove-themes-and-plugins",
    "wordpress-install-plugins",
    cb
  )


# Install the latest instance of WordPress or the version specified
gulp.task "wordpress-install", (cb) ->
  helper.out "Installing WordPress"

  fileName = if config.wordpress.version == "latest" then "latest.zip" else "wordpress-#{config.wordpress.version}.zip"

  # Remove WordPress
  if fs.existsSync "#{config.wordpress.folder}"
    del.sync(["#{config.wordpress.folder}"], force: true)

  if fs.existsSync "#{config.base}/.cache/#{fileName}"
    # Get WordPress from the cache folder if a copy is available
    helper.out "Using cached source of WordPress"

    gulp.src "#{config.base}/.cache/#{fileName}"
      .pipe unzip()
      .pipe gulp.dest("#{config.base}/.cache")


  else
    # Download the WordPress instance from wordpress.org
    helper.out "Downloading WordPress"

    url = "https://wordpress.org/#{fileName}"

    download(url)
      # Make a copy to the cache folder
      .pipe gulp.dest("#{config.base}/.cache")
      .pipe unzip()

    # TODO: Not working due to the sequencing need to separate into tasks and runSequence
    gulp.src "#{config.base}/.cache/wordpress/**/*", base: "wordpress"
      .pipe gulp.dest(config.wordpress.folder)

    # TODO: Delete folder in the cache

  cb


# Remove all default plugins and themes
gulp.task "wordpress-remove-themes-and-plugins", ->
  helper.out "Removing default themes and plugins"

  # Remove default themes and plugins
  del.sync([
    "#{config.wordpress.folder}/wp-content/themes/**/*/"
    "#{config.wordpress.folder}/wp-content/plugins/**/*/"

    # Hack: Instead of hardcoding the plugin name, use a regex
    "#{config.wordpress.folder}/wp-content/plugins/hello.php"

  ], force: true)


# Install WordPress plugins declared in the config
gulp.task "wordpress-install-plugins", ->
  helper.out "Installing Wordpress Plugins"

  # Download the wordpress plugins
  i = 0
  while i < config.wordpress.plugins.length
    plugin = config.wordpress.plugins[i]
    fileName = plugin.replace(/^.*[\\\/]/, '')

    if fs.existsSync("#{config.base}/.cache/plugins/#{fileName}")
      gulp.src "#{config.base}/.cache/plugins/#{fileName}"
        .pipe unzip()
        .pipe gulp.dest("#{config.wordpress.folder}/wp-content/plugins")

    else
      download(plugin)
        .pipe gulp.dest("#{config.base}/.cache/plugins/")
        .pipe unzip()
        .pipe gulp.dest("#{config.wordpress.folder}/wp-content/plugins")

    i++


# Install the default theme
gulp.task "wordpress-default-theme-install", ->
  helper.out "Installing default theme"

  # Copy over the default theme
  unless fs.exists(config.wordpress.theme.src)
    gulp.src "#{config.base}/theme-default/**/*"
      .pipe gulp.dest(config.wordpress.theme.src)
