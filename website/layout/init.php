<?php
  session_start();
  
  function __autoload($class_name) {
    include 'classes/' . str_replace('\\', '/', $class_name) . '.php'; 
  }
  
  $action = null;
  
  $i = 0;
  foreach ($_POST as $key => $value) {
    $vars[$i++] = $key;
    $$key = $value;
  }
    
?>