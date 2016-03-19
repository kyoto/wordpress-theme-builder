<?php
/**
 * Advance Custom Fields related helpers
 * @package helpers/acf
 */


// Enable ACF options
if (function_exists("acf_add_options_page")) {
  acf_add_options_page();
}


/**
 * Returns an option from the Advanced Custom Field options of a key
 *
 * @param striing $key The acf key
 */
function k($key) {
  return get_field($key, "option");
}


/**
 * Return an acf page
 *
 * @param acf_object $content The acf content object which contains a page's content
 */
function get_acf_page($content) {
  global $post;

  $output = "";

  if (empty($content)) {
    return "";
  }

  foreach ($content as $section) {
    switch ($section["acf_fc_layout"]) {
      // Display the page as a single column layout
      case "column-1":
        $contents = $section["content"];
        $output  .= "<div class='row'><div class='col-sm-12'>
          $contents
          </div></div>";
        break;

      // Display the page as a 2 column layout
      case "column-2":
        $column_1 = $section["column-1"];
        $column_2 = $section["column-2"];
        $output  .= "
        <div class='row'>
          <div class='col-sm-6'>$column_1</div>
          <div class='col-sm-6'>$column_2</div>
        </div>";
        break;

      default: break;
    }
  }

  return $output;
}


/**
 * Returns the HTML template for an image gallery
 *
 * @param array $images An array of acf images
 * @param array $options An associative array of options to configure the gallery
 *
 * @todo Update to reflect new JQuery plugin
 * @todo Adapt WooCommerce to use new jQuery plugin markup
 * @todo Set the options properly
 *
 */
function get_gallery($images, $options = null) {
  $name = $options["name"];

  $links_output  = "";
  $images_output = "";

  $img_url   = get_img_url($images[0], "large");
  $blank_url = get_base() . "/images/blank.gif";

  for ($i=0; $i < sizeof($images); $i++) {
    $thumnail_url = get_img_url($images[$i], "thumbnail");
    $fullsize_url = get_img_url($images[$i], "large");

    $links_output .= "
    <a data-rel='prettyPhoto[product-gallery-$name]' href='$fullsize_url' class='col-sm-2'>
      <img data-src='$thumnail_url' src='$blank_url'>
    </a>";
  }

  $output = "
    <div class='gallery row'>
      <div class='images'>
        <a itemprop='image' data-rel='prettyPhoto[product-gallery-$name]' href='$fullsize_url'>
          <img data-src='$img_url' src='$blank_url'>
        </a>
      </div>
      <div class='thumbnails row'>
        $links_output
      </div>
    </div>
  ";

  return $output;
}


/**
 * Returns the HTML template for an image gallery
 *
 * @param array $images an array of acf images
 * @param array $options an associative array of options to configure the gallery
 *
 * @todo Set the options properly
 *
 */
function get_carousel($images, $options = null) {
  $links_output  = "";
  $images_output = "";

  for ($i=0; $i < sizeof($images); $i++) {
    $links_output   .= "<li data-target='#album' data-slide-to='$i'></li>";
    $img_tag = get_img_tag($images[0]);

    $active = ($i == 0) ? "active" : "";

    $images_output .= "
      <div class='item $active'>
        $img_tag
      </div>
    ";
  }

  $output = "
    <div class='carousel slide' data-ride='carousel'>
      <ol class='carousel-indicators'>$links_output</ol>
      <div class='carousel-inner' role='listbox'>$images_output</div>
    </div>
  ";

  return $output;
}

