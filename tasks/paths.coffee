path        = require "path"
objectMerge = require "object-merge"
yargs       = require "yargs"


helper = require "./helper"

# TODO: Fix this race condition
config = require "../theme/config"

# Flag for compiling theme with production settings
global.production = !!(yargs.argv.production)

paths = {}

paths.base = path.resolve()

paths.wordpress =
  version: "latest"
  base: "#{paths.base}"
  themeName: "THEME"
  plugins: []


# Override the initial configuration with the user defined configuration (config.coffee)
paths.wordpress = objectMerge(paths.wordpress, config)

paths.wordpress.theme =
  src:  "#{paths.base}/theme"
  dest: "#{paths.wordpress.base}/wordpress/wp-content/themes/#{paths.wordpress.themeName}"

paths.css =
  sass: "#{paths.wordpress.theme.src}/stylesheets/sass"

paths.js =
  src:    "#{paths.wordpress.theme.src}/javascripts/js"
  coffee: "#{paths.wordpress.theme.src}/javascripts/coffee"

paths.images =
  src:  "#{paths.wordpress.theme.src}/images"
  dest: "#{paths.wordpress.theme.dest}/images/"

paths.app =
  src:  [
    "#{paths.wordpress.theme.src}/**/*"
    "#{paths.wordpress.theme.src}/wordpress/**/*"
  ]
  dest: paths.wordpress.theme.dest


module.exports = paths

