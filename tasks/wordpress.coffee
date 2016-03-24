
gulp.task "wordpress-install", ->
  version  = "4.4.2"
  filename = "wordpress-#{version}.zip"
  url      = "https://wordpress.org/#{filename}"

  # Remove wordpress
  del.sync([wordpress_url], force: true)

  # Download the wordpress instance
  return download(url)
    .pipe unzip()
    .pipe gulp.dest(root_url)

gulp.task "wordpress-remove-defaults", ->

  # Remove default themes and plugins
  del.sync([
    "#{wordpress_url}/wp-content/themes/**/*/"
    "#{wordpress_url}/wp-content/plugins/**/*/"
    # Hack: Instead of hardcoding the plugin name, use a regex
    "#{wordpress_url}/wp-content/plugins/hello.php"
  ], force: true)

gulp.task "wordpress-install-plugins", ->

  # Download the wordpress plugins
  i = 0
  while i < plugins.length
    download(plugins[i])
      .pipe unzip()
      .pipe gulp.dest("#{wordpress_url}/wp-content/plugins")

    i++

gulp.task "wordpress-init", (cb) ->
  # run_sequence "wordpress-install", "wordpress-remove-defaults", "wordpress-install-plugins", cb
  run_sequence "wordpress-install-plugins", cb


gulp.task "wordpress", ->
  # Include any arbitrary wordpress files
  gulp.src paths.wordpress.src
    .pipe gulp.dest(output_url)

gulp.task "plugins", (cb) ->
  # TODO: Check if folder exists in wp, if not copy over
  gulp.src "#{paths.plugins.src}/**/*.zip"
    .pipe unzip()
    .pipe gulp.dest(paths.plugins.dest)
