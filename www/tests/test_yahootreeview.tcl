# create the nodes for our tree
set nodes [list]
lappend nodes [list "fld1" "Folder 1" "tree" "" ""]
lappend nodes [list "fld11" "Folder 1.1" "tree" "" "fld1"]
lappend nodes [list "fld12" "Folder 1.2" "tree" "" "fld1"]
lappend nodes [list "fld2" "Folder 2" "tree" "javascript:alert('this is a tree node')" ""]

set js_script [ah::yui::create_tree -element "folders" \
		-nodes $nodes \
		-varname "tree" ]

set js_script [ah::enclose_in_script -script $js_script]