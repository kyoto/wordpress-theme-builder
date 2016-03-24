path  = require "path"
yargs = require "yargs"


# Flag for compiling theme with production settings
global.production = !!(yargs.argv.production)



module.exports.base = path.resolve()

theme_name = "THEME"


wordpress =
  base: "#{module.exports.base}/wordpress"
  theme:
    name: theme_name
    src:  "#{module.exports.base}/theme"
    dest: "#{module.exports.base}/wordpress/wp-content/themes/#{theme_name}"
  plugins: [
    "https://downloads.wordpress.org/plugin/contact-form-7.4.4.zip"
    "https://downloads.wordpress.org/plugin/advanced-custom-fields.4.4.5.zip"
    "https://downloads.wordpress.org/plugin/regenerate-thumbnails.zip"
    "https://downloads.wordpress.org/plugin/restricted-site-access.5.1.zip"
  ]


module.exports.wordpress = wordpress


module.exports.css =
  sass: "#{wordpress.theme.src}/assets/stylesheets/sass"


module.exports.js =
  src:    "#{wordpress.theme.src}/assets/javascripts/js"
  coffee: "#{wordpress.theme.src}/assets/javascripts/coffee"


module.exports.images =
  src:  "#{wordpress.theme.src}/assets/images"
  dest: "#{wordpress.theme.dest}/images/"


module.exports.app =
  src:  [
    "#{wordpress.theme.src}/app/**/*"
    "#{wordpress.theme.src}/wordpress/**/*"
  ]
  dest: wordpress.theme.dest


