<?php
/**
 * Internationalization related helpers
 * @package helpers/i18n
 */

/**
 * Load translations into a global variable
 */
function load_translations() {
  global $translations;
  $translations = array();

  $values = get_field("translations", "options");

  /**
   * @todo Make this return depending on region
   */
  foreach ($values as $key => $value) {
    $translations[$value["name"]] = $value["english"];
  }
}


/**
 * Return a translation's value according to language
 *
 * @param string $name The name of the translation
 */
function t($name) {
  global $translations;
  return isset($translations[$name]) ? $translations[$name] : $name;
}


/**
 * Output the translation
 *
 * @param string $name The name of the translation
 */
function e($name) {
  echo t($name);
}
