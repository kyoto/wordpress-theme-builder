<?php
/**
 * Gallery related helpers
 * @package helpers/gallery
 */

/**
 * Overriding wordpress's default gallery HTML template to accomodate for the jQuery slider plugin
 *
 * @param $atts post attributes
 */
function get_slide_gallery($atts) {
  global $post;

  $post_id = isset($post) ? $post->ID : null;

  if (! empty($atts['ids'])) {
    // 'ids' is explicitly ordered, unless you specify otherwise.
    if (empty($atts['orderby'])) {
      $atts['orderby'] = 'post__in';
    }
    $atts['include'] = $atts['ids'];
  }

  extract(shortcode_atts(array(
    'orderby'    => 'menu_order ASC, ID ASC',
    'include'    => '',
    'id'         => $post_id,
    'itemtag'    => 'dl',
    'icontag'    => 'dt',
    'captiontag' => 'dd',
    'columns'    => 3,
    'size'       => 'medium',
    'link'       => 'file'
  ), $atts));

  $args = array(
    'post_type'      => 'attachment',
    'post_status'    => 'inherit',
    'post_mime_type' => 'image',
    'orderby'        => $orderby
  );

  if (!empty($include)) {
    $args['include'] = $include;
  }
  else {
    $args['post_parent'] = $id;
    $args['numberposts'] = -1;
  }

  $images = get_posts($args);

  $output  = "";
  $links_output  = "";
  $images_output = "";

  for ($i=0; $i < sizeof($images); $i++) {
    $links_output .= "<li data-slide-to='$i'></li>";

    $url = wp_get_attachment_image_src($images[$i]->ID, "large");
    $url = $url[0];

    $img_tag = "<img src='$url'>";

    $active = ($i == 0) ? "active" : "";

    $images_output .= "
      <div class='item $active'>
        $img_tag
      </div>
    ";
  }

  $output = "
    <div class='slick'>
      $images_output
    </div>
  ";

  return $output;
}

add_filter("use_default_gallery_style", "__return_false");

remove_shortcode("gallery");

add_shortcode("gallery", "get_slide_gallery");

