<?php 
  include 'layout/init.php';

  if (empty($_SESSION['admin']) || $_SESSION['admin'] != "Mxyzptlk") 
    header("Location: login.php"); 
    
  if (empty($task))
    $task = null;
?>

<?php $page = new Page('admin'); ?>
<?php $prize = new Prize(); ?>

<?php include 'layout/header.php'; ?>
<h2>Admin</h2>

<div class='left admin_menu'>
  <form action="admin.php" method="post">
    Pages: 
    <select name="ddl_page">
      <?php foreach( $page->getPages() as $p) { ?>
      <?php if ($p == $ddl_page) { ?>
      <option selected='selected'><?php echo $p; ?></option>
      <?php } else { ?>
      <option><?php echo $p; ?></option>
      <?php } ?>
      <?php } ?>
    </select>
    <input type="hidden" name="task" value="pages">
    <input type="hidden" name="action" value="edit">
    <input type="submit" value="edit" />
  </form>
</div>

<div class='left admin_menu'>
  <form action="admin.php" method="post">
    Prizes: 
    <select name="ddl_prize">
      <option>New</option>
      <?php foreach( $prize->getPrizes() as $p) { ?>
      <?php if ($p['id'] == $ddl_prize) { ?>
      <option value="<?php echo $p['id']; ?>" selected='selected'><?php echo $p['name']; ?></option>
      <?php } else { ?>
      <option value="<?php echo $p['id']; ?>"><?php echo $p['name']; ?></option>
      <?php } ?>
      <?php } ?>
    </select>
    <input type="hidden" name="task" value="prizes">
    <input type="hidden" name="action" value="edit">
    <input type="submit" value="edit" />
  </form>
  
</div>

<hr class='clear' />


<?php if ($task == 'pages') { ?>
  <?php include 'admin/pages.php'; ?>
<?php } ?>
  
<?php if ($task == 'prizes') { ?>
  <?php include 'admin/prizes.php'; ?>
<?php } ?>

<?php include 'layout/footer.php'; ?>