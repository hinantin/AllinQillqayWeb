<?php
include("BaseXClient.php");
?>
<!DOCTYPE unspecified PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Allin Qillqay - Hinantin Management System</title>
<link rel="stylesheet"
	href="http://ajax.googleapis.com/ajax/libs/dojo/1.9.1/dojo/resources/dojo.css" />
<link rel="stylesheet"
	href="http://ajax.googleapis.com/ajax/libs/dojo/1.9.1/dijit/themes/claro/claro.css" />
<link rel="stylesheet"
	href="http://ajax.googleapis.com/ajax/libs/dojo/1.9.1/dojox/grid/resources/Grid.css" />
<link rel="stylesheet"
	href="http://ajax.googleapis.com/ajax/libs/dojo/1.9.1/dojox/grid/resources/claroGrid.css" />
<script type="text/javascript"
	src="http://ajax.googleapis.com/ajax/libs/dojo/1.9.1/dojo/dojo.js"
	djConfig="parseOnLoad: true"></script>
<script src="http://code.jquery.com/jquery-1.7.1.min.js"></script>
<script type="text/javascript">
	dojo.require('dojox.grid.DataGrid');
	dojo.require('dojo.data.ItemFileWriteStore');
	dojo.require('dijit.form.Button');
	dojo.addOnLoad(function() {
	var grid = dijit.byId('myDataGrid');
	<?php
	try {
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
		$input = "for \$id in subsequence(db:open('$DATABASE')//document/@id, 1, 100) return concat(\"{id: '\", data(\$id), \"',name: '\", data(\$id), \".xml'},\")";
		$query = $session->query($input);
		// loop through all results
		print "var itemList = [";
			while($query->more()) {
				print $query->next()."\n";
			}
			print "];";
			$session->close();
			} catch (Exception $e) {
				// print exception
				print $e->getMessage();
			}
	?>
	var store = new dojo.data.ItemFileWriteStore({
		data: {
			items: itemList
		}
	});
	grid.setStore(store);
	});
	</script>
</head>
<body class="claro">
<?php
$xslDoc = new DOMDocument();
$xslDoc->load("collection.xsl");

$xmlDoc = new DOMDocument();
$xmlDoc->load("collection.xml");
//$doc->loadXML('<root><node/></root>');

$proc = new XSLTProcessor();
$proc->importStylesheet($xslDoc);
echo $proc->transformToXML($xmlDoc);
?>
	<table id="myDataGrid" dojoType="dojox.grid.DataGrid"
		style="width: 400px;">
		<thead>
			<tr>
				<th field="id" width="40%">Identifier</th>
				<th field="name" width="60%">File Name</th>
			</tr>
		</thead>
	</table>
</body>
</html>