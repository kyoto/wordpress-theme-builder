<?php

/**
 * Define all functions
 * @package functions
 */

// Libraries


// Helper functions
require_once("helpers/i18n.php");
require_once("helpers/tag.php");
require_once("helpers/post.php");
require_once("helpers/acf.php");
require_once("helpers/gallery.php");
require_once("helpers/helpers.php");


// Initial configurations of the wordpress theme
require_once("functions/reset.php");
require_once("functions/wp_admin.php");


// Theme specific functionality
require_once("theme/theme.php");

