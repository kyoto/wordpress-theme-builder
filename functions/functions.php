<?php

require_once("wp_admin.php");
require_once("wp_admin_disable.php");

require_once("scale_up_images.php");
require_once("bootstrap_menu.php");
require_once("helpers.php");
require_once("tag_helpers.php");


function initialize_wordpress_app() {
  remove_action("wp_head", "wp_generator");
  remove_action("wp_head", "wlwmanifest_link");
  remove_action("wp_head", "rsd_link");

  // Enable primary menu
  register_nav_menus(array("primary" => "primary"));

  // Enable widgets
  register_sidebar(array("name" => ""));
}

add_action("init", "initialize_wordpress_app", 100);


function custom_image_sizes($sizes) {
  return array(
    "thumbnail" => __("Thumbnail"),
    "small"     => __("Small"),
    "medium"    => __("Medium"),
    "large"     => __("Large"),
    "full"      => __("Original")
  );
}

add_filter("image_size_names_choose", "custom_image_sizes");


add_image_size("thumbnail", 100, 100, true);
add_image_size("small", 300, 0);
add_image_size("medium", 630, 0);
add_image_size("large", 960, 0);


// Disable enqueued javascripts
function wp_dequeue_scripts() {
  wp_dequeue_script("contact-form-7");
}
add_action("wp_print_scripts", "wp_dequeue_scripts", 100);


// Disable enqueued stylesheets
function wp_dequeue_styles() {
  wp_dequeue_style("contact-form-7");
}
add_action("wp_print_styles", "wp_dequeue_styles", 100);


// By default, Wordpress does not highlight the menu if you are currently viewing a single blog post
function highlight_single_post_blog( $classes, $item ) {
  if (is_single() && !is_product() && $item->title == "Blog") {
    $classes[] = "current_page_item";
  }
  return $classes;
}
add_filter("nav_menu_css_class", "highlight_single_post_blog", 10, 2);
