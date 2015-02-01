<?php

class wp_bootstrap_menu extends Walker_Nav_Menu {
  public function start_lvl( &$output, $depth = 0, $args = array() ) {
    $indent = str_repeat( "\t", $depth );
    $output .= "\n$indent<ul role='menu' class=' dropdown-menu'>";
  }
}