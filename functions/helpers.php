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

// Load translations into a global variable
function load_translations() {
  global $translations;
  $translations = array();

  $values = get_field("translations", "options");

    // TODO: Make this return depending on region
  foreach ($values as $key => $value) {
    $translations[$value["name"]] = $value["english"];
  }
}

// Return a translation's value according to language
function t($name) {
  global $translations;
  return isset($translations[$name]) ? $translations[$name] : $name;
}

// Output the translation
function e($name) {
  echo t($name);
}


// TEMPLATE HELPERS

// Get a template by its name
function get_template_by_name($name) {
  return file_get_contents(locate_template("$name.php"));
}

// Output a partial
function partial($name) {
  echo get_template_by_name($name);
}


// POST HELPERS

// Find a page by its slug
function get_post_by_slug($slug, $postType = 'page') {
  $args = array(
    "name"           => $slug,
    "post_type"      => $postType,
    "posts_per_page" => 1
    );

  $posts = get_posts($args);

  return empty($posts) ? null : $posts[0];
}

// Get all the children of a page
function get_post_children($parent_id, $postType = 'page') {
  $args = array(
    "post_parent" => $parent_id,
    "post_type"   => $postType,
    "posts_per_page" => 1000
    );

  $posts = get_posts($args);

  return empty($posts) ? null : $posts;
}

// Output embed script for Disqus
function disqus_embed($disqus_shortname) {
  global $post;
  wp_enqueue_script('disqus_embed','http://'.$disqus_shortname.'.disqus.com/embed.js');
  echo '<div id="disqus_thread"></div>
  <script type="text/javascript">
    var disqus_shortname = "'.$disqus_shortname.'";
    var disqus_title = "'.$post->post_title.'";
    var disqus_url = "'.get_permalink($post->ID).'";
    var disqus_identifier = "'.$disqus_shortname.'-'.$post->ID.'";
  </script>';
}

// Return the categories of a post id
function get_categories_by_post_id($post_id) {
  $values = array();
  $categories = wp_get_post_categories($post_id);

  foreach ($categories as $category) {
    $category = get_category($category);

    if ($category->slug != "dont-miss" &&
        $category->slug != "uncategorized") {
      array_push($values, $category->name);
    }
  }
  return $values;
}

// Return the number of comments of the current post
function get_comments_count() {
  $num_comments = get_comments_number(); // get_comments_number returns only a numeric value

  if ( comments_open() ) {
    if ( $num_comments == 0 ) {
      $comments = __('No Comments');
    } elseif ( $num_comments > 1 ) {
      $comments = $num_comments . __(' Comments');
    } else {
      $comments = __('1 Comment');
    }
    $write_comments = $comments;
  } else {
    $write_comments =  __('Comments are off for this post.');
  }
  return $write_comments;
}


// HELPERS

// Returns an option from the Advanced Custom Field options given a key
function k($key) {
  return get_field($key, "option");
}

function render_page($page = null) {
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

  echo $output;
}

function render_page_links($page_links) {
  if (empty($page_links)) {
    return;
  }

  foreach ($page_links as $page_link) {
    switch ($page_link["acf_fc_layout"]) {
      case "flickr":
        render_flickr();
        break;
      case "twitter":
        render_twitter();
        break;
      case "page_link":
        render_page_link($page_link);
        break;

      default: break;
    }
  }
}

function render_page_link($page_link) {
  $url         = $page_link["url"];
  $image_tag   = get_img_tag($page_link["image"], array("image_size" => "medium"));
  $description = $page_link["description"];

  $output = "
    <a class='page_link' href='$url'>
      $image_tag
      <p>$description</p>
    </a>
  ";

  echo $output;
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

function render_nav() {
  wp_nav_menu(array(
    "menu"            => "primary",
    "container_class" => "collapse navbar-collapse",
    "menu_class"      => "navbar-nav nav",
    "walker"          => new wp_bootstrap_menu()
  ));
}

function render_projects($projects, $options = null) {
  foreach ($projects as $project_id => $project) {
    render_project($project, $options);
  }
}

function render_project($project, $options = null) {
  $image_size  = isset($options["image_size"]) ? $options["image_size"] : "large";
  $image_first = isset($options["image_first"]) && $options["image_first"] == true;
  $gallery     = isset($options["gallery"]) && $options["gallery"] == true;
  $class_name  = isset($options["class_name"]) ? $options["class_name"] : "";
  $render_div  = isset($options["render_div"]) && $options["render_div"] == true;
  $url = "";

  $title       = $project["title"];
  $description = $project["description"];

  $name = str_replace(" ", "", $title);

  if ($gallery) {
    $image_tag = get_gallery($project["images"], array("name" => $name));
  }
  else {
    $image_tag = get_img_tag($project["images"], array("image_size" => $image_size, "render_div" => $render_div));
  }


  $output = "";

  if (isset($project["url"])) {
    $url = $project["url"];
    $output .= "<a class='project $class_name' href='$url'>";
  }
  else {
    $output .= "<div class='project $class_name'>";
  }

  if ($image_first) {
    $output .= "$image_tag<h1>$title</h1>";
  }
  else {
    $output .= "<h1>$title</h1>$image_tag";
  }

  $output .= $description;

  if (isset($project["url"])) {
    $output .= "</a>";
  }
  else {
    $output .= "</div>";
  }

  echo $output;
}

function render_work($work_page, $options = null) {
  $url         = get_permalink($work_page->ID);
  $title       = $work_page->post_title;
  $image       = get_field("image", $work_page->ID);
  $image_tag   = get_img_tag($image, array("image_size" => "medium", "render_div" => true));

  $description = get_field("description", $work_page->ID);

  $class  = isset($options["class"]) ? $options["class"] : "";

  $output = "
    <a class='work $class' href='$url'>
      <h1>$title</h1>
      $image_tag
      <p>$description</p>
    </a>
  ";

  echo $output;
}

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
    <div id='album' class='carousel slide' data-ride='carousel'>
      <ol class='carousel-indicators'>$links_output</ol>
      <div class='carousel-inner' role='listbox'>$images_output</div>
    </div>
  ";

  return $output;
}

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
