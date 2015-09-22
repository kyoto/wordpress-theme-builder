<?php
/**
 * General helpers
 *
 * @package helpers
 */


/**
 * Output the contents of a variable in a readable format
 *
 * @param object $value The value to output
 */
function o($value) {
  echo "<pre>";
  print_r($value);
  echo "</pre>";
  // var_dump($value);
}


/**
 * Determines whether an array is associative or numeric
 *
 * @param array $arr The array to test
 */
function is_assoc($arr) {
  return array_keys($arr) !== range(0, count($arr) - 1);
}


/**
 * Return a partial template by its name
 *
 * @param string $name The name of the partial template
 */
function get_partial($name) {
  return file_get_contents(locate_template($name));
}


/**
 * Output a partial
 *
 * @param string $name The name of the partial template
 */
function partial($name) {
  echo get_partial($name);
}


/**
 * Return a page's or post's content
 *
 * @param object $content The post content of a page or post
 */
function get_content($content = null) {
  global $post;

  $page    = isset($page) ? $page : $post;
  $content = isset($content) ? $content : $page->post_content;

  return do_shortcode($content);
}


/**
 * Return a page's or post's content
 *
 * @param object $content The post content of a page or post
 */
function content($content = null) {
  echo get_content($content);
}


/**
 * Return the HTML template of a page's or post's content
 *
 * @param page $page The page. If a page is not provided, the global post will be attempted to be found.
 */
function get_the_page($page = null) {
  global $post;

  $page       = isset($page) ? $page : $post;
  $title      = $page->post_title;
  $text       = "";
  $breadcrumb = get_breadcrumb($page);
  $slug       = $page->post_name;

  if (function_exists("get_field")) {
    $content = get_field("content", $page->ID);
    $text    = get_acf_page($content);
  }
  else {
    $text = get_content($page->post_content);
  }

  $output = "
    <div class='post post-$slug'>
      $breadcrumb
      <h1>$title</h1>
      $text
    </div>
  ";

  return $output;
}


/**
 * Output the HTML template of a page's or post's content.
 *
 * @param page $page The page. If a page is not provided, the global post will be attempted to be found.
 */
function page($page = null) {
  echo get_the_page($page);
}


/**
 * Return the HTML template of a page's breadcrumb
 *
 * @param page $page The page
 */
function get_breadcrumb($page) {
  $separator = " » ";
  $output = "";

  if (!is_front_page()) {
    // $output .= '<a href="';
    // $output .= get_option('home');
    // $output .= '">';
    // $output .= get_bloginfo('name');
    // $output .= "</a> ".$separator;

    if (is_single()) {
      // TODO: Handle Blog
      // $output .= $separator;
      // $output .= $page->post_title;
    }
    elseif (is_page() && $page->post_parent) {
      $home = get_the_page(get_option('page_on_front'));
      for ($i = count($page->ancestors)-1; $i >= 0; $i--) {
        if (($home->ID) != ($page->ancestors[$i])) {
          $output .=  '<a href="';
          $output .=  get_permalink($page->ancestors[$i]);
          $output .=  '">';
          $output .=  get_the_title($page->ancestors[$i]);
          $output .=  "</a>".$separator;
        }
      }
      // $output .=  $page->post_title;
    }
    elseif (is_page()) {
      // $output .=  $page->post_title;
    }
    elseif (is_404()) {
      $output .=  "404";
    }
  }

  // Handle Shopping
  else {
    $output .= get_bloginfo('name');
  }

  if ($output == "") {
    return;
  }

  return "<div class='breadcrumb'>$output</div>";
}


/**
 * Output the HTML template of a page's breadcrumb
 *
 * @param page $page The page
 */
function breadcrumb($page) {
  echo get_breadcrumb($page);
}


/**
 * Return the HTML template of the navigation
 *
 * @todo this function is incomplete
 */
function get_navigation() {
}


/**
 * Output the HTML template of the navigation
 *
 * @todo this function is incomplete
 */
function navigation() {
  wp_nav_menu(array(
    "menu" => "primary"
  ));
}
