<?php include 'layout/init.php'; ?>

<?php $page = new Page('prizes'); ?>
<?php $elements = $page->getElements(); ?>
<?php $subelements = $page->getSubElements(); ?>

<?php $prize = new Prize(); ?>
<?php if (empty($_GET['p'])) { $cp = null; } else {$cp = $_GET['p']; }?>
<?php if (empty($_GET['c'])) { $cc = null; } else {$cc = $_GET['c']; }?>

<?php include 'layout/header.php'; ?>

  <h1><?php echo $elements['title']; ?></h1>
      
  <?php echo $elements['body']; ?>
  
  <div class='clear'>
  </div>
  
  <div id="catalog" class="left">
    <h4>Categories</h4>
    <ul>
    <?php foreach ($prize->getCategories() as $c) { ?>
      <li>
        <a href="prizes.php?c=<?php echo $c; ?>&p=<?php echo $cp?>" />
          <?php echo $c; ?>
        </a>
        <?php if ($c == $cc) { ?>
          <ul>
          <?php foreach ($prize->getPrizes($c) as $p) { ?>
            <li>
              <a href="prizes.php?c=<?php echo $c; ?>&p=<?php echo $p['id']?>" />
                <?php echo $p['name']; ?>
              </a>
            </li>

          <?php } // End foreach ?>
          </ul>
        <?php } // End if ?>
        
      </li>
          
    <?php } ?>
    </ul>
  </div>
  
  <?php if ($cp != null) { ?>
    <div id="prizes" class="right">
      <?php $p = $prize->getPrize($cp); ?>
      <img class="right prize_image" src="prizes/<?php echo $p['image']; ?>" />
    
      <h4 class="left">
        <?php echo $p['name']; ?>
      </h4>
      <p class="left clear_left">
        Credits: <?php echo $p['price']; ?>
      </p>
    
      <p class="left clear_left">
        Description: <br />
        <?php echo $p['description']; ?>
      </p>
    </div>
  <?php } ?>
  
  
      
      

<?php include 'layout/footer.php'; ?>