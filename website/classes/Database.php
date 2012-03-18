<?php

class Database {
  private $host = 'localhost';
  private $user = 'msdbu';
  private $password = 'j9b5de5PhLYzzr9s';
  private $db = 'mugshotdb';
  
  private $link;
  
  private $lastQuery;
  private $count;
  private $result;
  
  function __construct() {
    $this->connect();
  }
  
  function getLastQuery() {
    return $this->lastQuery;
  }
  
  function getCount() {
    return $this->count;
  }
  
  function connect() {
    // Close existing connection if exists
    // TODO: use mysqli::close
    if ($this->link)
      $this->link->close;
      
    // Create new connection
    try {
      $this->link = new mysqli($this->host, $this->user, $this->password, $this->db);
    
      if (!$this->link)
        throw new Exeption($this->link->connect_error);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
  
  function ping() {
    return $this->link->ping();
  }
  
  function query($query) {
    $this->lastQuery = $query;
    
    try {
      //$query = $this->link->real_escape_string($query);
      $this->result = $this->link->query($query);
      if (!$this->result)
        throw new Exception("Unable to perform query: $this->lastQuery : " . $this->link->error);
    } catch (Exception $e) {
      echo $e->getMessage();
    }
    
    $this->count++;
    return $this->result;
  }
  
  function getInsertId() {
    return $this->link->insert_id;
  }
  
  function getAffectedRows() {
    return $this->link->affected_rows;
  }
  
  function getNumRows() {
    return $this->result->num_rows;
  }
  
  function getRow() {
    return $this->result->fetch_row();
  }
  
  function getArray() {
    return $this->result->fetch_array();
  }
  
  function getAssoc() {
    return $this->result->fetch_assoc();
  }
  
  function getResult() {
    return $this->result;
  }
  
  function getNumFields() {
    return $this->result->field_count;
  }
  
  function getFieldName() {
    // TODO: Get field name by index
    return $this->result->fetch_field()->name;
  }
  
  function tableExists($table) {
    $query = "SHOW TABLES LIKE '$table'";
    $this->query($query);
    if ($this->getNumRows() == 1)
      return 1;
    else
      return 0;
  }
  
  function getResultsAsTable($page, $class = 'resultsTable') {

    if ($this->getNumRows() > 0) {
      $result = "<table class='$class'>\n";
      $result .= "<tr>\n";

      $this->getFieldName(); // Clears the ID field

      for ($i = 1; $i < $this->getNumFields(); $i++)
        $result .= "<th>" . $this->getFieldName() . "</th>\n";

      $result .= "<th colspan='2'></th>\n";
      $result .= "</tr>\n";

      while ($row = $this->getRow()) {

        $result .= "<tr>\n";
        for ($i = 1; $i < $this->getNumFields(); $i++)
          $result .= "<td>" . htmlentities($row[$i]) . "</td>\n";
        $result .= "<td style='width: 70px'><a href='$page?action=edit&id=$row[0]'>Edit</a></td>\n";
        $result .= "<td style='width: 70px'><a href='$page?action=delete&id=$row[0]'>Delete</a></td>\n";
        $result .= "</tr>\n";
      }
        
        $result .= "</table>";
    } else {
      $result = "<p>no results found</p>";
    }
        
    return $result;
  }
  
}




?>