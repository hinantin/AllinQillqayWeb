<?php
include("BaseXClient.php");
try {
  $session = new Session("localhost", 1984, "admin", "admin");
  $session->execute("OPEN HNTErrorCorpus");
  $input = "for \$id in subsequence(db:open('HNTErrorCorpus')//document/@id, 1, 10) return <doc>{data(\$id)}</doc>";
  $query = $session->query($input);
    // loop through all results
    while($query->more()) {
      print $query->next()."\n";
    }
  $session->close();
  $xslDoc = new DOMDocument();
  $xslDoc->load("collection.xsl");

  $xmlDoc = new DOMDocument();
  $xmlDoc->load("collection.xml");
  //$doc->loadXML('<root><node/></root>');

  $proc = new XSLTProcessor();
  $proc->importStylesheet($xslDoc);
  echo $proc->transformToXML($xmlDoc);

} catch (Exception $e) {
  // print exception
  print $e->getMessage();
}

?>
