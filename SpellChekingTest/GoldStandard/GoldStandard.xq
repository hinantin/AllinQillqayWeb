declare variable $file_name  := '20110823-2207-GoldstandardTexts.txt.xml'; 
for $status in distinct-values(doc($file_name)//spelltestresult//results//word/status)
return $status

(: 
TYPES OF STATUS
===============
declare variable $file_name  := '20110823-2207-GoldstandardTexts.txt.xml'; 
for $status in distinct-values(doc($file_name)//spelltestresult//results//word/status)
return $status

Results: SplCor SplErr TokErr 
:)