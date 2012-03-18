<?php

class Util {
  

  static function uploadImage($name, $directory) {
    $file = $_FILES[$name]['tmp_name'];
    $filename = $_FILES[$name]['name'];
    $file_types = array("image/jpeg", "image/pjpeg","image/gif", "image/png");
    
    if (!$file)
      return false;
    
    $img_info = getimagesize($file);
    $file_type = $img_info["mime"];

    if (!in_array($file_type, $file_types))
      return false;

    //if (file_exists("uploads/" . $filename))
      //return false;

    if (!copy($file, "uploads/" . $filename))
      return false;

    return $filename;
    
  }
  
  static function login($username, $password) {
    $db = new Database();
    
    $password = hash("md5", $password); 
    $password = hash("whirlpool", $password); 

    $query = "SELECT id "
           . "FROM users "
           . "WHERE username='$username' "
           . "AND password='$password'";
           
    $db->query($query);
    
    // echo $password; 
    
    if ($db->getNumRows() != 1) 
      return;
      
    $_SESSION['admin'] = "Mxyzptlk";
    header("Location: admin.php");
  }

  
}



?>