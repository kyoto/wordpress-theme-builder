<?php

// Advance Custom Fields related helpers


// Enable ACF options
if (function_exists("acf_add_options_page")) {
  acf_add_options_page();
}

// Returns an option from the Advanced Custom Field options of a key
function k($key) {
  return get_field($key, "option");
}

// Returns the markup for an image gallery.
// TODO: Update to reflect new JQuery plugin
// TODO: Adapt WooCommerce to use new jQuery plugin markup
// TODO: Set the options properly
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

// TODO: Determine whether this is ACF dependant
// TODO: Set the options properly
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

// render_images ( style => 'gallery|carousel|')