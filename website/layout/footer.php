    </div>    
    
    <div class='clear'>
    </div>  
    
    

  </div>
  
  <div id='footer'>
    &copy; 2012 Mugshot Casino
  </div>
  
  <div id='admin'>
    <?php if (isset($_SESSION['admin'])) { ?>
      <ul>
        <li><a href='admin.php'>admin</a></li>
        <li><a href='logout.php'>logout</a></li>
      </ul>
    <?php } else { ?>
      <a href='login.php'>login</a>
    <?php } ?>
  </div>
    
</body>

</html>