<?php

if (isset($ddl_page))
  $edit_page = new Page($ddl_page);
else
  $edit_page = new Page('');
  
$subelements = $edit_page->getSubElements();

if ($action == 'update') {
  foreach ($edit_page->getEditElements() as $element ) {
    if ($element['type'] == 'image') {
      if ( $file = Util::uploadImage($element['name'], 'uploads'))
        $edit_page->updateElement($element['name'], "uploads/" . $file);
    } else {
      $edit_page->updateElement($element['name'], $$element['name']);
    }
  }
  
  if (isset($se_id))
    for ($i = 0; $i < count($se_id); $i++) 
      $edit_page->updateSubElement($se_id[$i], $se_name[$i], $se_body[$i], $se_weight[$i]);
  
  $action = 'edit';
}

?>



<?php if ($action == 'edit') { ?>
  <form action="admin.php" method="post" enctype="multipart/form-data">
    <h3>Page Elements</h3>

    <?php foreach ($edit_page->getEditElements() as $e) {?>
      <?php if ($e['type'] == 'textbox') {?>
        <p>
          <?php echo $e['name']; ?>
          <input type="text" name="<?php echo $e['name']; ?>" value="<?php echo $e['body']; ?>" />
        </p>
      <?php } // End if ?>
      
      <?php if ($e['type'] == 'url') {?>
        <p>
          <?php echo $e['name']; ?>
          <input type="text" name="<?php echo $e['name']; ?>" value="<?php echo $e['body']; ?>" />
        </p>
      <?php } // End if ?>
      
      <?php if ($e['type'] == 'textarea') {?>
        <p>
          <?php echo $e['name']; ?><br />
          <textarea name="<?php echo $e['name']; ?>"><?php echo preg_replace('/<br \/>\s+<br \/>/', "\n", $e['body']); ?></textarea>
        </p>
      <?php } // End if ?>
      
      <?php if ($e['type'] == 'img') {?>
        <p>
          <img src="<?php echo $e['body']; ?>" /><br />
          <?php echo $e['name']; ?>
          <input type="file" name="<?php echo $e['name']; ?>" />
        </p>
      <?php } // End if ?>
    <?php } // End foreach ?>
    
    <?php if ($subelements != null) { ?>
      <hr />
      <h3>Sub Elements</h3>
      
      <?php foreach ($subelements as $se) { ?>
        <div class='subelements'>
          <p>
            Weight
            <input type="hidden" name="se_id[]" value="<?php echo $se['id']; ?>" />
            <input type="text" name="se_weight[]" value="<?php echo $se['weight']; ?>" />
          </p>
          <p>
            Name
            <input type="text" name="se_name[]" value="<?php echo $se['name'];?>" />
          </p>
          <p>
            Body
            <textarea name="se_body[]"><?php echo $se['body'];?></textarea>
          <p>
        </div>

      <?php } // End foreach ?>
      <div class='subelements'>
        <p>
          <input type="hidden" name="se_id[]" value="" />
          <input type="text" name="se_weight[]" value="" />
        </p>
        <p>
          <input type="text" name="se_name[]" value="" />
        </p>
        <p>
          <textarea name="se_body[]"></textarea>
        <p>
      </div>
    
    <?php } // End if ?>
    
    <input type="hidden" name="ddl_page" value="<?php echo $ddl_page; ?>" />
    <input type="hidden" name="task" value="pages" />
    <input type="hidden" name="action" value="update" />
    <input type="submit" value="update" class="right" />
  </form>
<?php } // End if ?>