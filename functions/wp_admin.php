<?php

// Load custom stylesheets for Admin
function load_custom_wp_admin_style() {
  wp_register_style("custom_wp_admin_css", get_template_directory_uri() . "/admin.css", false, "1.0.0");
  wp_enqueue_style("custom_wp_admin_css");
}
add_action("admin_enqueue_scripts", "load_custom_wp_admin_style");
add_action("admin_bar_init", "load_custom_wp_admin_style");
add_action("login_init", "load_custom_wp_admin_style");


// Configure Tiny MCE
function tiny_mce_options( $init ) {
  $init["block_formats"]              = "Header 1=h1;Header 2=h2;Text=p";
  $init["content_css"]                = get_template_directory_uri() . "/admin.css";
  $init["custom_shortcuts"]           = false;
  // $init["forced_root_block"]          = false;
  // $init["force_p_newlines"]           = false;
  // $init["force_br_newlines"]          = true;
  // $init["convert_newlines_to_brs"]    = true;
  // $init["remove_linebreaks"]          = false;
  // $init['remove_redundant_brs']       = false;

  return $init;
}
add_filter("tiny_mce_before_init", "tiny_mce_options");


// Disable Shortcut keys for Tiny MCE
function tiny_mce_disable_shortcuts() {
  echo "
  <script type='text/javascript'>
    tinymce.on('SetupEditor', function (ed) {
      ed.shortcuts = {
        add: function() {}
      };
    });
  </script>";
}
add_filter("after_wp_tiny_mce", "tiny_mce_disable_shortcuts");


// Enable ACF options
if (function_exists("acf_add_options_page")) {
  acf_add_options_page();
}
