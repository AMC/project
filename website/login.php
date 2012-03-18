<?php
  include 'layout/init.php';

  if (isset($username) && isset($password))
    Util::login($username, $password);

$_SESSION['hi'] = "hello";
?>

<?php include 'layout/header.php'; ?>

<div id='content'>
  
  <div id='login'>
    <form action='login.php' method='post'>
      <h4>Login</h4>
      <p>
      username: 
      <input type='text' name='username' />
      </p>
      <p>
      password:
      <input type='password' name='password' />
      </p>
      <p>
      <input type='submit' value='login' class='right' />
      </p>
    </form>
    
    <div class='clear'>
    </div>
      
  </div>

    
</div>
    
<?php include 'layout/footer.php'; ?>