<?php

class AdminPage {
  private $db;
  
  private $id;
  private $page;

    
  function __construct($page) {
    $this->page = $page;
    $this->db = new Database();
  }

  
  function getPages() {
    $query = "SELECT DISTINCT(name) "
           . "FROM page ";

    $db->query($query);
    echo $query;    
    while ($result = $db->getAssoc()) {
      $pages[$result['name']] = $result['name'];
    }
    
    return $pages;
  }
  
  
  function getContent() {
    $query = "SELECT id, name, type, content "
           . "FROM page "
           . "WHERE page='$this->page'";

    $db->query($query);

    while ($result = $db->getAssoc()) {
      $content[$result['name']] = $result['content'];
    }
    
    return $content;
  }
  
  
  function getChildren() {
    $query = "SELECT name, type, content "
           . "FROM page_child "
           . "WHERE page='$this->page'"
           . "ORDER BY weight";

    $db->query($query);

    $i = 0;
    while ($result = $db->getAssoc()) {
      $children[$i++] = $result;
    }
    return $children;
  }




}

?>