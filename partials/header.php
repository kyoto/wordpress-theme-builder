<!DOCTYPE html>
<!--[if lte IE 7]>
<html class="ie ie7" <?php language_attributes(); ?>>
<![endif]-->
<!--[if IE 8]>
<html class="ie ie8" <?php language_attributes(); ?>>
<![endif]-->
<!--[if !(IE 7) & !(IE 8)]><!-->
<html <?php language_attributes(); ?>>
<!--<![endif]-->

<head>
  <meta charset="<?php bloginfo("charset"); ?>" />
  <title><?php bloginfo("name"); ?><?php wp_title(); ?></title>
  <link rel="profile" href="http://gmpg.org/xfn/11" />
  <link rel="pingback" href="<?php bloginfo( 'pingback_url' ); ?>" />
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <?php wp_enqueue_style("index", "/index.css", array(), "", "all"); ?>
  <?php wp_enqueue_script("index", "/index.js", array(), "", false); ?>
  <?php wp_meta(); ?>
  <?php wp_head(); ?>

  <!--[if lt IE 9]>
  <script type="text/javascript" src="<?php echo get_site_url(); ?>/ie.js"></script>
  <![endif]-->
  <!--[if lt IE 8]>
  <script>window.onload=function(){e("/images/ie/")}</script>
  <![endif]-->
</head>
<body>
<header>
  <div class="container">
    <div class="logo">
      <a href="/">
        <h1><?php bloginfo("name"); ?></h1>
        <h2><?php bloginfo("description"); ?></h2>
      </a>
    </div>
    <nav>
      <?php navigation(); ?>
    </nav>
  </div>
</header>
<div class="container">