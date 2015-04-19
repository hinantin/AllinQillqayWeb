<?php
include("BaseXClient.php");
?>
<!DOCTYPE unspecified PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Allin Qillqay - Hinantin Management System</title>
</head>
<body>
<?php
try {
  /*
   * Basic Example
   * 
   * */
  
  $ini_array = parse_ini_file("/usr/lib/cgi-bin/spellcheck31/script/ConfigFile.ini", true);
  $HOST = $ini_array["PRODUCTION_BASEX_HNTErrorCorpus"]["HOST"];
  $USER = $ini_array["PRODUCTION_BASEX_HNTErrorCorpus"]["USER"];
  $PASSWORD = $ini_array["PRODUCTION_BASEX_HNTErrorCorpus"]["PASSWORD"];
  $DATABASE = $ini_array["PRODUCTION_BASEX_HNTErrorCorpus"]["DATABASE"];
  $PORT = $ini_array["PRODUCTION_BASEX_HNTErrorCorpus"]["PORT"];
  
  $session = new Session($HOST, $PORT, $USER, $PASSWORD);
  $session->execute("OPEN $DATABASE");
  /* This is a sample id */
  $id = "doc_20150418005816";
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
</body>
</html>