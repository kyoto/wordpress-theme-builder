
getWordPressFileSrcName = ->
  if config.wordpress.version == "latest"
    "latest.zip"
  else
    "wordpress-#{config.wordpress.version}.zip"


gulp.task "wp-init", (cb) ->
  runSequence(
    "wp-install"
    "wp-remove-defaults"
    "wp-install-plugins"
    cb
  )


# Install the latest instance of WordPress or the version specified
gulp.task "wp-install", (cb) ->
  helper.out "Installing WordPress"

  # Remove WordPress folder
  if fs.existsSync "#{config.wordpress.folder}"
    del.sync(["#{config.wordpress.folder}"], force: true)

  # Get WordPress from the cache folder if a copy is available
  if fs.existsSync "#{config.base}/.cache/#{getWordPressFileSrcName()}"
    helper.out "Using cached source of WordPress"

    runSequence(
      "wp-extract-from-cache"
      "wp-copy-from-cache"
      cb
    )

  else
    # Download the WordPress instance from wordpress.org
    runSequence(
      "wp-download"
      "wp-extract-from-cache"
      "wp-copy-from-cache"
      cb
    )


# Download the WordPress source into the cache folder
gulp.task "wp-download", ->
  url = "https://wordpress.org/#{getWordPressFileSrcName()}"

  # Download to the cache folder
  download(url)
    .pipe gulp.dest("#{config.base}/.cache")


# Extract the WordPress source in the cache directory
gulp.task "wp-extract-from-cache", ->
  gulp.src "#{config.base}/.cache/#{getWordPressFileSrcName()}"
    .pipe unzip()
    .pipe gulp.dest("#{config.base}/.cache")


# Copy the WordPress source from the cache folder
gulp.task "wp-copy-from-cache", ->
  gulp.src "#{config.base}/.cache/wordpress/**/*"
    .pipe gulp.dest(config.wordpress.folder)



# Remove all default plugins and themes
gulp.task "wp-remove-defaults", ->
  helper.out "Removing default themes and plugins"

  # Remove default themes and plugins
  del.sync([
    "#{config.wordpress.folder}/wp-content/themes/**/*/"
    "#{config.wordpress.folder}/wp-content/plugins/**/*/"

    # Hack: Instead of hardcoding the plugin name, use a regex
    "#{config.wordpress.folder}/wp-content/plugins/hello.php"

  ], force: true)


# Install WordPress plugins declared in the config
gulp.task "wp-install-plugins", ->
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
gulp.task "wp-default-theme-install", ->
  helper.out "Installing default theme"

  #TODO: Generate the folders according to the paths
  #TODO: Generate the most essential files for a theme to work

  # Copy over the default theme
  unless fs.exists(config.wordpress.theme.src)
    gulp.src "#{config.base}/theme-default/**/*"
      .pipe gulp.dest(config.wordpress.theme.src)
