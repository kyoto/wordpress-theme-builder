<?php

//
// Functions that only are specific to this theme
//


// Disable enqueued javascripts
function wp_dequeue_scripts() {
  // wp_dequeue_script("");
}
add_action("wp_print_scripts", "wp_dequeue_scripts", 100);


// Disable enqueued stylesheets
function wp_dequeue_styles() {
  // wp_dequeue_style("");
}
add_action("wp_print_styles", "wp_dequeue_styles", 100);


// Define the image sizes and their dimensions
function custom_image_sizes() {
  return array(
    "thumbnail" => __("Thumbnail"),
    "small"     => __("Small"),
    "medium"    => __("Medium"),
    "large"     => __("Large"),
    "full"      => __("Original")
  );
}
add_filter("image_size_names_choose", "custom_image_sizes");


// Define the dimensions for each image size
add_image_size("thumbnail", 100, 100, true);
add_image_size("small", 300, 0);
add_image_size("medium", 630, 0);
add_image_size("large", 960, 0);



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
  $url         = "";

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
  $className   = isset($options["class"]) ? $options["class"] : "";

  $output = "
    <a class='work $className' href='$url'>
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
    <div class='carousel slide' data-ride='carousel'>
      <ol class='carousel-indicators'>$links_output</ol>
      <div class='carousel-inner' role='listbox'>$images_output</div>
    </div>
  ";

  return $output;
}
