<?php
/**
 * Contains all the overriding of any undesirable default behaviour
 * @package wp_admin
 */

/**
 * Load custom stylesheets for Admin
 * @ignore
 */
function load_custom_wp_admin_style() {
  wp_register_style("custom_wp_admin_css", get_template_directory_uri() . "/admin.css", false, "1.0.0");
  wp_enqueue_style("custom_wp_admin_css");
}
add_action("admin_enqueue_scripts", "load_custom_wp_admin_style");
add_action("admin_bar_init", "load_custom_wp_admin_style");
add_action("login_init", "load_custom_wp_admin_style");


/**
 * Custom configure Tiny MCE
 * @ignore
 */
function tiny_mce_options( $init ) {
  $stylesheets = array(
    "/wp-includes/js/tinymce/skins/lightgray/content.min.css",
    "/wp-includes/css/dashicons.min.css",
    "/wp-includes/js/tinymce/skins/wordpress/wp-content.css",
    get_template_directory_uri() . "/admin.css"
  );

  $init["block_formats"]              = "Header 1=h1;Header 2=h2;Text=p";
  $init["content_css"]                = join(",", $stylesheets);
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


/**
 * Disable Shortcut keys for Tiny MCE
 * @ignore
 */
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


/**
 * Disable support for comments and trackbacks in post types
 * @ignore
 */
function df_disable_comments_post_types_support() {
  $post_types = get_post_types();
  foreach ($post_types as $post_type) {
    if(post_type_supports($post_type, "comments")) {
      remove_post_type_support($post_type, "comments");
      remove_post_type_support($post_type, "trackbacks");
    }
  }
}
add_action("admin_init", "df_disable_comments_post_types_support");


/**
 * Close comments on the front-end
 * @ignore
 */
function df_disable_comments_status() {
  return false;
}
add_filter("comments_open", "df_disable_comments_status", 20, 2);
add_filter("pings_open", "df_disable_comments_status", 20, 2);


/**
 * Hide existing comments
 * @ignore
 */
function df_disable_comments_hide_existing_comments($comments) {
  $comments = array();
  return $comments;
}
add_filter("comments_array", "df_disable_comments_hide_existing_comments", 10, 2);


/**
 * Remove comments page in menu
 * @ignore
 */
function df_disable_comments_admin_menu() {
  remove_menu_page("edit-comments.php");
}
add_action("admin_menu", "df_disable_comments_admin_menu");


/**
 * Redirect any user trying to access comments page
 * @ignore
 */
function df_disable_comments_admin_menu_redirect() {
  global $pagenow;
  if ($pagenow === "edit-comments.php") {
    wp_redirect(admin_url()); exit;
  }
}
add_action("admin_init", "df_disable_comments_admin_menu_redirect");


/**
 * Remove comments metabox from dashboard
 * @ignore
 */
function df_disable_comments_dashboard() {
  remove_meta_box("dashboard_recent_comments", "dashboard", "normal");
}
add_action("admin_init", "df_disable_comments_dashboard");


/**
 * Remove comments links from admin bar
 * @ignore
 */
function df_disable_comments_admin_bar() {
  if (is_admin_bar_showing()) {
    remove_action("admin_bar_menu", "wp_admin_bar_comments_menu", 60);
  }
}
add_action("init", "df_disable_comments_admin_bar");


/**
 * Disable custom fields
 * @ignore
 */
function customize_meta_boxes() {
  remove_meta_box("postcustom","post","normal");
}
add_action("admin_init","customize_meta_boxes");


/**
 * Disable categories
 * @ignore
 */
function disable_categories() {
  register_taxonomy("category", array());
}
add_action("init", "disable_categories");


/**
 * Remove tags functionality across the board
 * @ignore
 */
function remove_tags(){
  register_taxonomy("post_tag", array());
}
add_action("init", "remove_tags");

