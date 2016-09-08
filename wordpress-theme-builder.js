#!/usr/bin/env node

// TODO: implement coffeelint
// TODO: implement scss-lint
// TODO: implement gulp-size

// Enable Coffeescript so that all Gulp tasks can be written in Coffeescript
require("coffee-script/register");

require("./wordpress-theme-builder.coffee");
