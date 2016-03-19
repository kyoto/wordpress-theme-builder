<?php
/**
 * Functions that only are specific to this theme
 * @package theme
 */


/**
 * Disable enqueued javascripts
 * @ignore
 */
function wp_dequeue_scripts() {
  // wp_dequeue_script("");
}

add_action("wp_print_scripts", "wp_dequeue_scripts", 100);


/**
 * Disable enqueued stylesheets
 * @ignore
 */
function wp_dequeue_styles() {
  // wp_dequeue_style("");
}

add_action("wp_print_styles", "wp_dequeue_styles", 100);


/**
 * Define the image sizes and their dimensions
 * @ignore
 */
function custom_image_sizes() {
  return array(
    "thumbnail" => __("Thumbnail"),
    "small"     => __("Small"),
    "medium"    => __("Medium"),
    "large"     => __("Large"),
    "full"      => __("Original")
  );
}

add_filter("image_size_names_choose", "custom_image_sizes");


// Define the dimensions for each image size
add_image_size("thumbnail", 100, 100, true);
add_image_size("small", 300, 0);
add_image_size("medium", 630, 0);
add_image_size("large", 960, 0);



