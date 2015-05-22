<?php
/**
 * Contains all the overriding of any undesirable default behaviour of wordpress
 * as well as any generic initialising
 *
 * @package reset
 */


/**
 * Perform resets on the initialization of wordpress
 *
 * @ignore
 */
function initialize_wordpress_app() {
  // Remove unecessary meta tags
  remove_action("wp_head", "wp_generator");
  remove_action("wp_head", "wlwmanifest_link");
  remove_action("wp_head", "rsd_link");

  // Enable primary menu
  register_nav_menus(array("primary" => "primary"));

  // Enable widgets
  register_sidebar(array("name" => ""));
}

add_action("init", "initialize_wordpress_app", 100);


/**
 * By default, Wordpress does not highlight the menu if you are currently viewing a single blog post
 *
 * @ignore
 */
function highlight_single_post_blog( $classes, $item ) {
  if (is_single() && !is_product() && $item->title == "Blog") {
    $classes[] = "current_page_item";
  }
  return $classes;
}

add_filter("nav_menu_css_class", "highlight_single_post_blog", 10, 2);


/**
 * Wordpress has an issue in which uploaded images are not scaled up
 *
 * Scale up images functionality in "Edit image" ...
 * See http://core.trac.wordpress.org/ticket/23713
 * This is slightly changed function image_resize_dimensions() in wp-icludes/media.php
 *
 * @ignore
 */
function my_image_resize_dimensions( $nonsense, $orig_w, $orig_h, $dest_w, $dest_h, $crop = false) {
  if ($crop) {
    // crop the largest possible portion of the original image that we can size to $dest_w x $dest_h
    $aspect_ratio = $orig_w / $orig_h;
    $new_w = min($dest_w, $orig_w);
    $new_h = min($dest_h, $orig_h);

    if ( !$new_w ) {
      $new_w = intval($new_h * $aspect_ratio);
    }

    if ( !$new_h ) {
      $new_h = intval($new_w / $aspect_ratio);
    }

    $size_ratio = max($new_w / $orig_w, $new_h / $orig_h);

    $crop_w = round($new_w / $size_ratio);
    $crop_h = round($new_h / $size_ratio);

    $s_x = floor( ($orig_w - $crop_w) / 2 );
    $s_y = floor( ($orig_h - $crop_h) / 2 );
  }
  else {
    // don't crop, just resize using $dest_w x $dest_h as a maximum bounding box
    $crop_w = $orig_w;
    $crop_h = $orig_h;

    $s_x = 0;
    $s_y = 0;

    /* wp_constrain_dimensions() doesn't consider higher values for $dest :( */
    /* So just use that function only for scaling down ... */
    if ($orig_w >= $dest_w && $orig_h >= $dest_h ) {
      list( $new_w, $new_h ) = wp_constrain_dimensions( $orig_w, $orig_h, $dest_w, $dest_h );
    } else {
      $ratio = $dest_w / $orig_w;
      $w = intval( $orig_w  * $ratio );
      $h = intval( $orig_h * $ratio );
      list( $new_w, $new_h ) = array( $w, $h );
    }
  }

  // if the resulting image would be the same size or larger we don't want to resize it
  // Now WE need larger images ...
  // if ($new_w >= $orig_w && $new_h >= $orig_h)
  if ($new_w == $orig_w && $new_h == $orig_h)
    return false;

  // the return array matches the parameters to imagecopyresampled()
  // int dst_x, int dst_y, int src_x, int src_y, int dst_w, int dst_h, int src_w, int src_h
  return array( 0, 0, (int) $s_x, (int) $s_y, (int) $new_w, (int) $new_h, (int) $crop_w, (int) $crop_h );
}

add_filter("image_resize_dimensions", "my_image_resize_dimensions", 1, 6);
