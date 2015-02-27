<?php
/**
 * Helpers that generate HTML tags
 * @package helpers/tag
 */

/**
 * Outputs a html link
 *
 * @param string $text The text for the link
 * @param string $url The url of the link
 * @param array $options An associative array of options to configure the link
 *
 */
function link_to($text, $url, $options = null) {
  global $translations;

  $class  = isset($options["class"]) ? "class={$options['class']}" : "";
  $target = isset($options["target"]) ? "target={$options['target']}" : "";

  echo "<a href='$url' $class $target>$text</a>";
}


/**
 * Return a url relative to the website
 *
 * @param string $url The url of the website
 * @param string $language_code the language code of the website
 *
 */
function get_url($url, $language_code = ICL_LANGUAGE_CODE) {
  return get_site_url() . "/$language_code/" . $url;
}


/**
 * Outputs a url relative to the website
 *
 * @param string $url The url of the website
 * @param string $language_code the language code of the website
 *
 */
function url($url, $language_code = ICL_LANGUAGE_CODE) {
  echo get_url($url, $language_code);
}


/**
 * Returns the base URL
 */
function get_base() {
  return get_template_directory_uri();
}


/**
 * Outputs the base path of the website
 */
function base() {
  echo get_base();
}


/**
 * Output a HTML image tag
 *
 * @param array $images An array of acf images
 * @param array $options An associative array of options to configure the image tag
 *
 * @todo Reevaluate this function
 */
function img_tag($image, $options = null) {
  echo get_img_tag($image, $options);
}


/**
 * Return a HTML image tag
 *
 * @param array $image An array of acf images
 * @param array $options An associative array of options to configure the image tag
 *
 * @todo Reevaluate this function
 */
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


/**
 * Return the absolute url of an image
 *
 * @param array $images An array of acf images
 * @param array $size size of the image
 *
 * @todo Reevaluate this function
 */
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


/**
 * Outputs the contents of an SVG file
 *
 * @param string $url the url of the svg
 */
function svg($url) {
  echo get_svg($url);
}


/**
 * Returns the contents of an SVG file. In the case of ie8, output the png equivalent in the same directory
 *
 * @param string $url the url of the svg
 */
function get_svg($url) {
  $png = str_replace(".svg", ".png", $url);
  echo getcwd();
  $output  = "<!--[if gte IE 9]><!-->";
  $output .= file_get_contents($url, true);
  $output .= "<![endif]-->";
  $output .= "<!--[if lte IE 8]><img src='/$png' class='svg_png'><![endif]-->";

  return $output;
}
