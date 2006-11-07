ad_library {

	Library for Ajax Helper Procs
	based on Yahoo's User Interface Libraries

	@author Hamilton Chua (ham@solutiongrove.com)
	@creation-date 2006-01-16
}

namespace eval ah::yui { }

ad_proc -private ah::yui::load_js_sources {
	-source_list
} {
	Accepts a tcl list of sources to load.
	This source_list will be the global ajax_helper_yui_js_sources variable.
	This script is called in the blank-master template.

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-11-05
} {
	set ah_base_url [ah::get_url]
	set script ""
	set minsuffix ""

	if { [parameter::get_from_package_key -package_key "ajaxhelper" -parameter "UseMinifiedJs"] == 1 } {
		set minsuffix "-min"
	}

	foreach source $source_list {
		switch $source {
			"animation" { 
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/animation/animation${minsuffix}.js\"></script> \n" 
			}
			"event" {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/event/event${minsuffix}.js\"></script> \n" 
			}
			"treeview" {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/treeview/treeview${minsuffix}.js\"></script> \n" 
				global yahoo_treeview_css
				if { [exists_and_not_null yahoo_treeview_css] } {
					append script "<link rel=\"stylesheet\" type=\"text/css\" href=\"${yahoo_treeview_css}\" /> \n" 
				} else {
					append script "<link rel=\"stylesheet\" type=\"text/css\" href=\"${ah_base_url}yui/treeview/assets/tree.css\" /> \n" 
				}
			}
			"calendar" {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/calendar/calendar${minsuffix}.js\"></script> \n" 
			}
			"dragdrop" {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/dragdrop/dragdrop${minsuffix}.js\"></script> \n" 
			}
			"slider" {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/slider/slider${minsuffix}.js\"></script> \n" 
			}
			"container" {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/container/container${minsuffix}.js\"></script> \n" 
				append script "<link rel=\"stylesheet\" type=\"text/css\" href=\"${ah_base_url}yui/container/assets/container.css\" /> \n" 
			}
			"dom" {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/dom/dom${minsuffix}.js\"></script> \n"		
			}
			"connection" {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/connection/connection${minsuffix}.js\"></script> \n" 
			}
			"yahoo" {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/yahoo/yahoo${minsuffix}.js\"></script> \n"
			}
		}
	}
	return $script
}

ad_proc -private ah::yui::is_js_sources_loaded {
	-js_source
} {
	This proc will loop thru source_list and check for the presence of js_source.
	If found, this proc will return 1 
	If not found, this proc will return 0

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-11-05
} {
	global ajax_helper_yui_js_sources
	set state 0
	if { [info exists ajax_helper_yui_js_sources] } {
		foreach source $ajax_helper_yui_js_sources {
			if { [string match $source $js_source] } { 
				set state 1
				break
			}
		}
	}
	return $state
}

ad_proc -public ah::yui::js_sources {
	{-source "default"}
	{-min:boolean}
} {

	Generates the < script > syntax needed on the head 
	for Yahoo's User Interface Library
	The code :
	<pre>
		[ah::yui::js_sources -default]
	</pre>
	will load the default YUI javascript library which includes the connections and doms js files

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-01-16

	@param default Loads the prototype and scriptaculous javascript libraries.
	@param source The caller can specify which set of javascript source files to load. You can specify more than one by separating the list with commas.
		Valid values include 
		"animation" : loads animation.js
		"event" : loads events.js
		"treeview" : loads treeview.js
		"calendar" : loads calendar.js
		"dragdrop" : loads dragdrop.js
		"slider" : loads slider.js
		"container" : loads container.js
	@param min Provide this parameter to use minified versions of the yahoo javascript sources

	@return 
	@error 

} {
	set ah_base_url [ah::get_url]
	set script ""
	set js_file_list [split $source ","]
	set minsuffix ""

	if { $min_p || [parameter::get_from_package_key -package_key "ajaxhelper" -parameter "UseMinifiedJs"] == 1 } {
		set minsuffix "-min"
	}
	
	foreach x $js_file_list {
		switch $x { 
			"animation" {
				if { ![ah::yui::is_js_sources_loaded -js_source "animation"] } {
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/animation/animation${minsuffix}.js\"></script> \n" 
				}
			}
			"event" {
				if { ![ah::yui::is_js_sources_loaded -js_source "event"] } {
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/event/event${minsuffix}.js\"></script> \n" 
				}
			}
			"treeview" {
				if { ![ah::yui::is_js_sources_loaded -js_source "treeview"] } {
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/treeview/treeview${minsuffix}.js\"></script> \n" 
				}
			}
			"calendar" {
				if { ![ah::yui::is_js_sources_loaded -js_source "calendar"] } {
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/calendar/calendar${minsuffix}.js\"></script> \n" 
				}
			}
			"dragdrop" {
				if { ![ah::yui::is_js_sources_loaded -js_source "dragdrop"] } {
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/dragdrop/dragdrop${minsuffix}.js\"></script> \n" 
				}
			}
			"slider" {
				if { ![ah::yui::is_js_sources_loaded -js_source "slider"] } {
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/slider/slider${minsuffix}.js\"></script> \n" 
				}
			}
			"container" {
				if { ![ah::yui::is_js_sources_loaded -js_source "container"] } {
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/container/container${minsuffix}.js\"></script> \n" 
					append script "<link rel=\"stylesheet\" type=\"text/css\" href=\"${ah_base_url}yui/container/assets/container.css\" /> \n" 
				}
			}
			"menu" {
				if { ![ah::yui::is_js_sources_loaded -js_source "menu"] } {
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/menu/menu${minsuffix}.js\"></script> \n" 
				}
			}
			"connection" {
				if { ![ah::yui::is_js_sources_loaded -js_source "connection"] } {
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/connection/connection${minsuffix}.js\"></script> \n" 
				}
			}
			default {
				if { ![ah::yui::is_js_sources_loaded -js_source "yahoo"] } {
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/yahoo/yahoo${minsuffix}.js\"></script> \n"
				}
				if { ![ah::yui::is_js_sources_loaded -js_source "dom"] } {
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/dom/dom${minsuffix}.js\"></script> \n"		
				}
			}
		}
	}

	return $script
}

ad_proc -public ah::yui::addlistener {
	-element:required
	-event:required
	-callback:required
	{-element_is_var:boolean}
} {
	Creates javascript for Yahoo's Event Listener.
	http://developer.yahoo.com/yui/event/

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-11-05

	@param element The element that this function will listen for events. This is the id of an html element (e.g. div or a form)
	@param event The event that this function waits for. Values include load, mouseover, mouseout, unload etc.
	@param callback The name of the javascript function to execute when the event for the given element has been triggered.
} {

	if { ![ah::yui::is_js_sources_loaded -js_source "yahoo"] } { 
		global ajax_helper_yui_js_sources
		lappend ajax_helper_yui_js_sources "yahoo"
		if { ![ah::yui::is_js_sources_loaded -js_source "event"] } { 
			lappend ajax_helper_yui_js_sources "event"
		}
	}

	if { !$element_is_var_p } { 
		set element [ah::isnot_js_var $element]
	}
	return "YAHOO.util.Event.addListener($element,\"$event\",${callback});\n"
}

ad_proc -public ah::yui::tooltip {
	-varname:required
	-element:required
	-message:required
	{-enclose:boolean}
	{-options ""}
} {
	Generates the javascript to create a tooltip using yahoo's user interface javascript library.
	http://developer.yahoo.com/yui/container/tooltip/index.html

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-11-05

	@param varname The variable name you want to give to the tooltip
	@param element The element where you wish to attache the tooltip
	@param message The message that will appear in the tooltip
} {
	if { ![ah::yui::is_js_sources_loaded -js_source "yahoo"] } { 
		global ajax_helper_yui_js_sources
		lappend ajax_helper_yui_js_sources "yahoo"
		if { ![ah::yui::is_js_sources_loaded -js_source "container"] } { 
			lappend ajax_helper_yui_js_sources "container"
		}
	}

	set script "var $varname = new YAHOO.widget.Tooltip(\"alertTip\", { context:\"$element\", text:\"$message\", $options });"
	if { $enclose_p } { set script [ah::enclose_in_script -script ${script} ] }
	return $script
}

ad_proc -public ah::yui::create_tree {
	-element:required
	-nodes:required
	{-varname "tree"}	
	{-css ""}
} {
	Generates the javascript to create a yahoo tree view control.
	http://developer.yahoo.com/yui/treeview/

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-11-05
	
	@param element This is the id of the html elment where you want to generate the tree view control.
	@param nodes Is list of lists. Each list contains the node information to be passed to ah::yui::create_tree_node to create a node.
	@param varname The javascript variable name to give the tree.	

} {
	if { ![ah::yui::is_js_sources_loaded -js_source "yahoo"] } { 
		global ajax_helper_yui_js_sources
		lappend ajax_helper_yui_js_sources "yahoo"
		lappend ajax_helper_yui_js_sources "dom"
		if { ![ah::yui::is_js_sources_loaded -js_source "treeview"] } { 
			lappend ajax_helper_yui_js_sources "treeview"
			global yahoo_treeview_css
			set yahoo_treeview_css $css
		}
	}


	set script "${varname} = new YAHOO.widget.TreeView(\"${element}\"); "
	append script "var ${varname}root = ${varname}.getRoot(); "
	foreach node $nodes {
		append script [ah::yui::create_tree_node -varname [lindex $node 0] \
				-label [lindex $node 1] \
				-treevarname [lindex $node 2] \
				-href [lindex $node 3] \
				-attach_to_node [lindex $node 4] \
				-dynamic_load [lindex $node 5] ]
	}
	append script "${varname}.draw(); "
	return $script
}

ad_proc -private ah::yui::create_tree_node {
	-varname:required
	-label:required
	-treevarname:required
	{-href "javascript:void(0)"}
	{-attach_to_node ""}
	{-dynamic_load ""}
} {
	Generates the javascript to add a node to a yahoo tree view control
	http://developer.yahoo.com/yui/treeview/

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-11-05
} {
	set script "var od${varname} = {label: \"${label}\", id: \"${varname}\", href: \"${href}\"}; "

	if { [exists_and_not_null attach_to_node] } {
		append script "var node = ${treevarname}.getNodeByProperty('id','${attach_to_node}'); "
		append script "if ( node == null ) { var node = nd${attach_to_node}; } "
		
	} else {
		append script "var node = ${treevarname}root; "
	}
	append script "var nd${varname} = new YAHOO.widget.TextNode(od${varname},node,false); "

	if { [exists_and_not_null dynamic_load] } {
		append script "nd${varname}.setDynamicLoad(${dynamic_load}); "
	}

	return $script
}