<?php

class Prize {
  
  private $db;
  
  private $categories;

  private $id;
  private $name;
  private $price;
  private $image;
  private $description;
  
  public function __construct($id = null) {
    if ($id)
      $this.getPrize($id);
  }
  
  
  public function getCategories() {
    $db = new Database();
    
    $query = "SELECT DISTINCT(category) "
           . "FROM prizes ";

    $db->query($query);
    
    $categories = array();

    $i = 0;
    while ($result = $db->getAssoc()) 
      $categories[$i++] = stripslashes($result['category']);
    
    return $categories;
  }
  
  public function getPrizes($c = null) {
    $db = new Database();
    
    if ($c == null) {
      $query = "SELECT id, name, category, price, image, description "
             . "FROM prizes ";
    } else {
      $c = addslashes($c);
      $query = "SELECT id, name, category, price, image, description "
             . "FROM prizes "
             . "WHERE category='$c' ";
    }
    
    $db->query($query);
    
    $i = 0;
    while ($result = $db->getAssoc()) 
      $prizes[$i++] = array(
        "id"          => stripslashes($result['id']), 
        "name"        => stripslashes($result['name']), 
        "category"    => stripslashes($result['category']),  
        "price"       => stripslashes($result['price']), 
        "image"       => stripslashes($result['image']), 
        "description" => stripslashes($result['description'])
      );
    
    return $prizes;
  }
  
  
  public function getPrize($id) {
    $db = new Database();
    
    $query = "SELECT id, name, category, price, image, description "
           . "FROM prizes "
           . "WHERE id=$id ";
           
    $db->query($query);
    
    while ($result = $db->getAssoc()) 
      $prize = array(
        "id"          => stripslashes($result['id']), 
        "name"        => stripslashes($result['name']), 
        "category"    => stripslashes($result['category']),  
        "price"       => stripslashes($result['price']), 
        "image"       => stripslashes($result['image']), 
        "description" => stripslashes($result['description']));
    
    return $prize;
  }
  
  
  public function createPrize($name, $category, $price, $description) {
    $db = new Database();
    
    $name = addslashes($name);
    $category = addslashes($category);
    $price = addslashes($price);
    $description = addslashes($description);
    
    $query = "INSERT INTO prizes (name, category, price, description) "
           . "VALUES('$name', '$category', '$price', '$description') ";

    $db->query($query);
    
    return $db->getInsertId();
  }
  
  
  public function updatePrize($id, $name, $category, $price, $description) {
    $db = new Database();
    
    if (!is_numeric($id))
      return false;
      
    $name = addslashes($name);
    $category = addslashes($category);
    $price = addslashes($price);
    $description = addslashes($description);
    
    $query = "UPDATE prizes "
           . "SET name='$name', category='$category', "
           . "price='$price', description='$description' "
           . "WHERE id=$id ";
           
    $db->query($query);
    
    return $id;
  }
  

  public function deletePrize($id) {
    $db = new Database();
    
    if (!is_numeric($id))
      return false;
    
    $query = "DELETE FROM prizes "
           . "WHERE id=$id ";

    $db->query($query);
    
  }
  
  
  static function updateImage($id, $name='prize_image') {
    if (!is_numeric($id))
      return false;
    
    $file = $_FILES[$name]['tmp_name'];
    $file_types = array(
      "image/jpeg" => ".jpg",
      "image/gif"  => ".gif", 
      "image/png"  => ".png");
    
    if (!$file)
      return false;
    
    $img_info = getimagesize($file);
    $file_type = $img_info["mime"];
    

    if (!array_key_exists($file_type, $file_types))
      return false;
      
    $filename = $id . $file_types[$file_type];
      
    if (!copy($file, "prizes/" . $filename))
      return false;

    $db = new Database();
    
    $query = "UPDATE prizes "
           . "SET image='$filename' "
           . "WHERE id=$id ";
           
    $db->query($query);
    
  }

  
}

?>