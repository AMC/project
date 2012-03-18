<?php

class Page {
  private $db;
  
  private $name;

    
  function __construct($page) {
    $this->page = $page;
  }
  
  function getPages() {
    $db = new Database();
    
    $query = "SELECT DISTINCT(page) "
           . "FROM elements ";

    $db->query($query);
    echo $query;    
    while ($result = $db->getAssoc()) {
      $pages[$result['page']] = stripslashes($result['page']);
    }
    
    return $pages;
  }
  
  function getElements() {
    $db = new Database();
    $query = "SELECT name, type, body "
           . "FROM elements "
           . "WHERE page='$this->page'";

    $db->query($query);
    
    while ($result = $db->getAssoc()) {
      $elements[$result['name']] = stripslashes($result['body']);
    }
    
    return $elements;
  }
  
  
  function getSubElements() {
    $db = new Database();
    $query = "SELECT id, name, body, weight "
           . "FROM subelements "
           . "WHERE page='$this->page'";

    $db->query($query);
    
    $i = 0;
    while ($result = $db->getAssoc()) {
      $subelements[$i++] = array(
        'id' => $result['id'], 
        'name' => stripslashes($result['name']), 
        'body' => stripslashes($result['body']), 
        'weight' => $result['weight']);
    }
    
    if (isset($subelements))
      return $subelements;
    return null;
  }
  
  
  function getEditElements() {
    $db = new Database();
    $query = "SELECT name, type, body "
           . "FROM elements "
           . "WHERE page='$this->page'";

    $db->query($query);
    
    $i = 0;
    while ($result = $db->getAssoc()) {
      $elements[$i++] = array(
        'name' => stripslashes($result['name']), 
        'body' => stripslashes($result['body']), 
        'type' => $result['type']);
    }
    
    return $elements;
  }
  
  

  
  function updateElement($key, $value) {
    $db = new Database();
    
    $key = addslashes($key);
    $value = addslashes($value);
    
    $query = "UPDATE elements "
           . "SET body='$value' "
           . "WHERE page='$this->page' "
           . "AND name='$key' ";
    
    echo "$query <hr>";
    
    $db->query($query);
    
  }
  
  function updateSubElement($id, $name, $body, $weight=10) {
    $db = new Database();
    
    if ($name == "" || $body == "")
      return;

    if (!is_numeric($weight))
      $weight = 10;
      
    $name = addslashes($name);
    $body = addslashes($body);
    
    if ($id == "") {
      $query = "INSERT INTO subelements (page, name, body, weight) "
             . "VALUES ('$this->page', '$name', '$body', $weight)";
    } else {
      $query = "UPDATE subelements "
            . "SET name='$name', body='$body'"
            . "WHERE id='$id' ";
    }
    
    $db->query($query);
    
  }
  


}

?>