
config = {}
config.base = path.resolve()

# Default settings
config.wordpress =
  host: "localhost"
  version: "latest"
  folder: "#{config.base}/wordpress"
  themeName: "THEME"
  plugins: []


# Create the default config if one does not exist
unless fs.existsSync "#{config.base}/theme/config.coffee"
  # Create the theme directory
  fs.mkdirSync("#{config.base}/theme")

  # Copy the default config file
  fs.createReadStream("#{__dirname}/../config-default.coffee")
    .pipe fs.createWriteStream("#{config.base}/theme/config.coffee")


# Override the initial configuration with the user defined configuration (config.coffee)
userConfig = require "#{config.base}/theme/config"
config.wordpress = objectMerge(config.wordpress, userConfig)


config.wordpress.theme =
  src:  "#{config.base}/theme"
  dest: "#{config.wordpress.folder}/wp-content/themes/#{config.wordpress.themeName}"

config.css =
  sass: "#{config.wordpress.theme.src}/stylesheets/sass"

config.js =
  src:    "#{config.wordpress.theme.src}/javascripts/js"
  coffee: "#{config.wordpress.theme.src}/javascripts/coffee"

config.images =
  src:  "#{config.wordpress.theme.src}/images"
  dest: "#{config.wordpress.theme.dest}/images/"

# TODO: have this as part of APP
config.fonts =
  src:  "#{config.wordpress.theme.src}/fonts"
  dest: "#{config.wordpress.theme.dest}/fonts/"

config.app =
  src:  [
    "#{config.wordpress.theme.src}/php/**/*"
    "#{config.wordpress.theme.src}/wordpress/**/*"
  ]
  dest: config.wordpress.theme.dest


# Make the config variable globally available
module.exports = config
