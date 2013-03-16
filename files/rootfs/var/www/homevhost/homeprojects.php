<!DOCTYPE HTML>

<html>
 <head>
  <title>Homepages and Projects</title>
  <link rel="stylesheet" href="main.css">
  <link rel="icon" href="favicon.ico">
 </head>

 <body class="front-page">

  <hgroup>
   <h1><object data="logo.png" height=134 width=150><img src="logo.png" alt="" height=101 width=138></object> Homepages and Projects</h1>
   <h2>A <a href="/">home server</a> for friends and family</h2>
  </hgroup>

<?php

class SortableDirectoryIterator implements IteratorAggregate {

    private $_storage;

    public function __construct($path) {
        $this->_storage = new ArrayObject();

        $files = new DirectoryIterator($path);
        foreach ($files as $file) {
            $this->_storage->offsetSet($file->getFilename(), $file->getFileInfo());
        }
        $this->_storage->uksort(
            function ($a, $b) {
                return strcmp($a, $b);
            }
        );
    }

    public function getIterator() {
        return $this->_storage->getIterator();
    }

}

$dir = "/home/srv/www";
$dir_it = new SortableDirectoryIterator($dir);
foreach ($dir_it as $file) {
    $fn = $file->getFilename();
    if ($fn !== '.' && $fn !== '..') {
        if (glob("$dir/$fn/*") != false) {
            echo "   <a class=\"ss\" href=\"/$fn\"><strong>$fn</strong></a>\n";
        }
    }
}
?>

  <div class="footer">
   <address>Queries should be directed to <a href="mailto:info [at] mehho [dot] net">info [at] mehho [dot] net</a>.</address>
   <p class="copyright">&copy; 2011-2013 S&eacutebastien Lerique. Design inspired from the <a href="http://www.whatwg.org/">WHATWG</a> website, thank you to them :).</p>
  </div>

 </body>
</html>
