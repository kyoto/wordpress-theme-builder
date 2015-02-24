<?php

// GENERAL HELPERS

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


// TEMPLATE HELPERS

// Get a partial template by its name
function get_partial($name) {
  return file_get_contents(locate_template("$name.php"));
}

// Output a partial
function partial($name) {
  echo get_partial($name);
}



// HELPERS

function get_page($page = null) {
  global $post;

  $page       = isset($page) ? $page : $post;
  $title      = $page->post_title;
  $content    = get_field("content", $page->ID);
  $text       = "";
  $breadcrumb = get_breadcrumb($page);
  $slug       = $page->post_name;

  if (empty($content)) {
    $text = do_shortcode($page->post_content);
  }
  else {
    foreach ($content as $section) {
      switch ($section["acf_fc_layout"]) {
        case "column-1":
          $contents = $section["content"];
          $text    .= "<div class='row'><div class='col-sm-12'>
            $contents
            </div></div>";
          break;

        case "column-2":
          $column_1 = $section["column-1"];
          $column_2 = $section["column-2"];
          $text    .= "
          <div class='row'>
            <div class='col-sm-6'>$column_1</div>
            <div class='col-sm-6'>$column_2</div>
          </div>";
          break;

        default: break;
      }
    }
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
  echo get_page($page);
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
      $home = get_page(get_option('page_on_front'));
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
    "menu"            => "primary",
    "container_class" => "collapse navbar-collapse",
    "menu_class"      => "navbar-nav nav",
    "walker"          => new wp_bootstrap_menu()
  ));
}
