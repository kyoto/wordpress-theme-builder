<?php

//
// General helpers
//

// Print out the contents of a variable
function o($value) {
  echo "<pre>";
  print_r($value);
  echo "</pre>";
  // var_dump($value);
}

// Determines whether an array is associative or numeric
function is_assoc($arr) {
  return array_keys($arr) !== range(0, count($arr) - 1);
}


// Template helpers

// Get a partial template by its name
function get_partial($name) {
  return file_get_contents(locate_template("$name.php"));
}

// Output a partial
function partial($name) {
  echo get_partial($name);
}



// HELPERS

//
//
//


function get_content($content = null) {
  global $post;

  $page    = isset($page) ? $page : $post;
  $content = isset($content) ? $content : $page->post_content;

  return do_shortcode($content);
}

function content($content = null) {
  echo get_content($content);
}

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

function page($page = null) {
  echo get_the_page($page);
}

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

function breadcrumb($page) {
  echo get_breadcrumb($page);
}

function get_navigation() {
}

function navigation() {
  wp_nav_menu(array(
    "menu"            => "primary"
  ));
}
