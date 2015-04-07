let $root := "/usr/lib/cgi-bin/spellcheck31/script/dbspellchecker/tmp/"
for $file in file:list($root)
return db:add("HNTQhichwaErrorCorpus", $root || $file)
