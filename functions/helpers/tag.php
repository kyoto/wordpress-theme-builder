<?php

// Helpers that generate HTML tags

// Outputs a html link
function link_to($title, $url, $options = null) {
  global $translations;

  $class  = isset($options["class"]) ? "class={$options['class']}" : "";
  $target = isset($options["target"]) ? "target={$options['target']}" : "";

  echo "<a href='$url' $class $target>$title</a>";
}

// Return a url relative to the website
function get_url($url, $language_code = ICL_LANGUAGE_CODE) {
  return get_site_url() . "/$language_code/" . $url;
}

// Outputs a url relative to the website
function url($url, $language_code = ICL_LANGUAGE_CODE) {
  echo get_url($url, $language_code);
}

// Returns the base URL
function get_base() {
  return get_template_directory_uri();
}

// Outputs the base path of the website
function base() {
  echo get_base();
}


// Outputs the images path
function img($path) {
  echo get_template_directory_uri() . '/images/' . $path;
}

function img_tag($image, $options = null) {
  echo get_img_tag($image, $options);
}

function get_img_tag($image, $options = null) {
  $image_size  = isset($options["image_size"]) ? $options["image_size"] : "large";
  $render_div  = isset($options["render_div"]) && $options["render_div"] == true;

  $url = get_img_url($image, $image_size);

  if ($render_div) {
    return "<div class='image' style='background-image: url($url)'></div>";
  }
  else {
    return "<img src='$url'>";
  }
}

function get_img_url($images, $size) {
  if (empty($images)) {
    return;
  }
  else if (is_array($images)) {
    return is_assoc($images) ? $images["sizes"][$size] : $images[0]["sizes"][$size];
  }
  else {
    return $images;
  }
}

// Outputs the contents of an SVG file
function svg($path) {
  echo get_svg($path);
}

// Returns the contents of an SVG file
function get_svg($path) {
  $png = str_replace(".svg", ".png", $path);

  $output  = "<!--[if gte IE 9]><!-->";
  $output .= file_get_contents($path, true);
  $output .= "<![endif]-->";
  $output .= "<!--[if lte IE 8]><img src='/$png' class='svg_png'><![endif]-->";

  return $output;
}
