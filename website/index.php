<?php include 'layout/init.php'; ?>

<?php $page = new Page('index'); ?>
<?php $elements = $page->getElements(); ?>
<?php $subelements = $page->getSubElements(); ?>

<?php include 'layout/header.php'; ?>

      

      <h1><?php echo $elements['title']; ?></h1>
      
      <?php echo $elements['body']; ?>

<?php include 'layout/footer.php'; ?>