<?php
/**
 * Post related helpers
 * @package helpers/post
 */

/**
 * Find a page by its slug
 *
 * @param $slug slug to search against
 * @param $postType post type to search against
 */
function get_post_by_slug($slug, $postType = "page") {
  $args = array(
    "name"           => $slug,
    "post_type"      => $postType,
    "posts_per_page" => 1
    );

  $posts = get_posts($args);

  return empty($posts) ? null : $posts[0];
}


/**
 * Get all the children of a page
 *
 * @param $parent_id parent id to search against
 * @param $postType post type to search against
 */
function get_post_children($parent_id, $postType = "page") {
  $args = array(
    "post_parent" => $parent_id,
    "post_type"   => $postType,
    "posts_per_page" => 1000
    );

  $posts = get_posts($args);

  return empty($posts) ? null : $posts;
}


/**
 * Output embed script for Disqus
 *
 * @param $disqus_shortname disqus shortname
 * @todo clean up syntax
 */
function render_disqus($disqus_shortname) {
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


/**
 * Return the categories of a post id
 *
 * @param $post_id Post id to search against
 */
function get_categories_by_post_id($post_id) {
  $values = array();
  $categories = wp_get_post_categories($post_id);

  foreach ($categories as $category) {
    $category = get_category($category);
  }
  return $values;
}


/**
 * Return the number of comments of the current post
 */
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
