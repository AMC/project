<?php

if ($action == 'create') {
  $ddl_prize = $prize->createPrize($prize_name, $prize_category, $prize_price, $prize_description);
  $prize->updateImage($ddl_prize);
}

if ($action == 'update') {
  $ddl_prize = $prize->updatePrize($ddl_prize, $prize_name, $prize_category, $prize_price, $prize_description);
  $prize->updateImage($ddl_prize);
}

if ($action == 'delete') {
  $prize->deletePrize($ddl_prize);
  $ddl_prize = "New";
}

$action = 'edit';

?>

<?php if ($ddl_prize != "New") { ?>
  <form action="admin.php" method="post">
    <input type="hidden" name="ddl_prize" value="<?php echo $ddl_prize; ?>" />
    <input type="hidden" name="task" value="prizes" />
    <input type="hidden" name="action" value="delete" />
    <input type="submit" value="delete" />
  </form>
<?php } ?>

<form action="admin.php" method="post" enctype="multipart/form-data">
  <?php if ($ddl_prize != "New") { ?>
    <?php $p = $prize->getPrize($ddl_prize); ?>
  <?php } else { ?>
    <?php $p = null; ?>
  <?php } // End if?>
  
  <p>
    Name: <br />
    <input type="text" name="prize_name" value="<?php echo $p['name'];?>" />
  </p>
  
  <p>
    Category: <br />
    <input type="text" name="prize_category" value="<?php echo $p['category']; ?>" />
  </p>
  
  <p>
    Price: <br />
    <input type="text" name="prize_price" value="<?php echo $p['price']; ?>" />
  </p>
  
  <p>
    Image: <br /> 
    <img class='prize_image' src="prizes/<?php echo $p['image']; ?>" /><br />
    <input type="file" name="prize_image" />
  </p>
  
  <p>
    Description:<br />
    <textarea name="prize_description"><?php echo preg_replace('/<br \/>\s+<br \/>/', "\n", $p['description']); ?></textarea>
  </p>
  
  <input type="hidden" name="ddl_prize" value="<?php echo $ddl_prize; ?>" />
  <input type="hidden" name="task" value="prizes" />
  
  <?php if ($ddl_prize == "New") { ?>
    <input type="hidden" name="action" value="create" />
    <input type="submit" value="create" class="right" />
  <?php } else { ?>
    <input type="hidden" name="action" value="update" />
    <input type="submit" value="update" class="right" />
  <?php } ?>

<br />
</form>