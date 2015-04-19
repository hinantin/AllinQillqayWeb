<?php
include("BaseXClient.php");
try {
  $ini_array = parse_ini_file("/usr/lib/cgi-bin/spellcheck31/script/ConfigFile.ini", true);
  $HOST = $ini_array["PRODUCTION_BASEX_HNTErrorCorpus"]["HOST"];
  $USER = $ini_array["PRODUCTION_BASEX_HNTErrorCorpus"]["USER"];
  $PASSWORD = $ini_array["PRODUCTION_BASEX_HNTErrorCorpus"]["PASSWORD"];
  $DATABASE = $ini_array["PRODUCTION_BASEX_HNTErrorCorpus"]["DATABASE"];
  $PORT = $ini_array["PRODUCTION_BASEX_HNTErrorCorpus"]["PORT"];
  
  $session = new Session($HOST, $PORT, $USER, $PASSWORD);
  $session->execute("OPEN $DATABASE");
  $input = "for \$id in subsequence(db:open('$DATABASE')//document/@id, 1, 10) return <doc>{data(\$id)}</doc>";
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
