path = require "path"


module.exports.base = path.resolve()

theme_name = "THEME"

# Wordpress path
wordpress =
  base: "#{module.exports.base}/wordpress"
  theme:
    name: theme_name
    src:  "#{module.exports.base}/theme"
    dest: "#{module.exports.base}/wordpress/wp-content/themes/#{theme_name}"

module.exports.wordpress = wordpress


module.exports.css =
  base: "#{wordpress.theme.src}/assets/stylesheets/"
  sass: "#{wordpress.theme.src}/assets/stylesheets/sass"


module.exports.js =
  base:   "#{wordpress.theme.src}/assets/javascripts/js"
  coffee: "#{wordpress.theme.src}/assets/javascripts/coffee"


module.exports.images =
  src: ["#{wordpress.theme.src}/assets/images/**/*"]
  dest: "#{wordpress.theme.dest}/images/"


module.exports.fonts =
  src: ["#{wordpress.theme.src}/assets/fonts/**/*"]
  dest: "#{wordpress.theme.dest}/fonts/"


module.exports.php =
  src: [
    "#{wordpress.theme.src}/app/pages/**/*.php"
    "#{wordpress.theme.src}/app/partials/**/*.php"
  ]
  dest: wordpress.theme.dest



    # plugins: [
    #   "https://downloads.wordpress.org/plugin/contact-form-7.4.4.zip"
    #   "https://downloads.wordpress.org/plugin/advanced-custom-fields.4.4.5.zip"
    #   "https://downloads.wordpress.org/plugin/regenerate-thumbnails.zip"
    #   "https://downloads.wordpress.org/plugin/restricted-site-access.5.1.zip"
    # ]

    # src: ["#{theme_src}/wordpress/**/*"]
    # images:
    #   src: "#{root_url}/wordpress/wp-content/uploads"
    #   backup: "#{root_url}/wordpress/wp-content/uploads_backup/"
    # plugins:
    #   src: "#{root_url}/wordpress/plugins"
    #   dest: "#{wordpress_url}/wp-content/plugins"
