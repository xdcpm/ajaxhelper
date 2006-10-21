ad_library {

	Library for Ajax Helper Procs
 	based on Yahoo's User Interface Libraries

    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2006-01-16
}

namespace eval ah::yui { }

ad_proc -public ah::yui::js_source_dynamic {
	{-js "default"}
	{-enclose:boolean}
} {
	Dynamically Loads the Yahoo UI javascript libraries.
        WARNING : experimental, use ah::yui::js_sources instead


	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-04-20

	@param js Comma separated list of javascript files to load
		Valid values include 
		"default" : loads yui.js and dom.js, the most commonly used
		"animation" : loads js for animation 
		"event" : loads js for event monitoring (e.g. listnern)
		"treeview" : loads js for Yahoo's Tree View control
		"calendar" : loads js for Yahoo's Calendar Control
		"dragdrop" : loads js for Yahoo's Drag and Drop functions
		"slider" : loads js for slider functions

} {

	set ah_base_url [ah::get_url]
	set script ""
	set js_file_list [split $js ","]

	foreach x $js_file_list {
		switch $x { 
			"animation" { 
				append script [ah::js_include -js_file "${ah_base_url}yui/animation/animation.js"]
			}
			"event" {
				append script [ah::js_include -js_file "${ah_base_url}yui/event/event.js"]
			}
			"treeview" {
				append script [ah::js_include -js_file "${ah_base_url}yui/treeview/treeview.js"]
			}
			"calendar" {
				append script [ah::js_include -js_file "${ah_base_url}yui/calendar/calendar.js"]
			}
			"dragdrop" {
				append script [ah::js_include -js_file "${ah_base_url}yui/dragdrop/dragdrop.js"]
			}
			"slider" {
				append script [ah::js_include -js_file "${ah_base_url}yui/slider/slider.js"]
			}
			default {
				append script [ah::js_include -js_file "${ah_base_url}yui/yui.js"]
				append script [ah::js_include -js_file "${ah_base_url}yui/dom/dom.js"]
			}
		}
	}

	if { $enclose_p } { set script [ah::enclose_in_script -script ${script} ] }

	return $script
}

ad_proc -public ah::yui::js_sources {
	{-source "default"}
	{-min:boolean}
} {

	Generates the < script > syntax needed on the head 
	for yui's User Interface Library
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

	@return 
	@error 

} {
	set ah_base_url [ah::get_url]
	set script ""
	set js_file_list [split $source ","]
	if { $min_p } {
		set min "-min"
	} else {
		set min ""
	}
	
	
	foreach x $js_file_list {
		switch $x { 
			"animation" { 
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/animation/animation${min}.js\"></script> \n" 
			}
			"event" {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/event/event${min}.js\"></script> \n" 
			}
			"treeview" {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/treeview/treeview${min}.js\"></script> \n" 
			}
			"calendar" {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/calendar/calendar${min}.js\"></script> \n" 
			}
			"dragdrop" {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/dragdrop/dragdrop${min}.js\"></script> \n" 
			}
			"slider" {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/slider/slider${min}.js\"></script> \n" 
			}
			"container" {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/container/container${min}.js\"></script> \n" 
				append script "<link rel=\"stylesheet\" type=\"text/css\" href=\"${ah_base_url}yui/container/assets/container${min}.css\" /> \n" 
			}
			"menu" {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/menu/menu${min}.js\"></script> \n" 
			}
			default {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/yahoo/yahoo${min}.js\"></script> \n"
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}yui/dom/dom${min}.js\"></script> \n"		
			}
		}
	}

	return $script
}

ad_proc -public ah::yui::addlistener {
	-element:required
	-event:required
	{-scope "''"}
	{-callback ""}
	{-element_is_var:boolean}
	{-override:boolean}
} {
	Creates javascript for Yahoo's Event Listener.
} {
	if { !$element_is_var_p } { 
		set element [ah::isnot_js_var $element]
	}
	if { $override_p } {
		set override "true"
	} else {
		set override "false"
	}
	return "YAHOO.util.Event.addListener($element,\"$event\",${callback},${scope},${override});\n"
}

ad_proc -public ah::yui::tooltip {
	-varname:required
	-element:required
	-message:required
	{-enclose:boolean}
	{-options ""}
} {
	Generates the javascript to create a tooltip using yahoo's user interface javascript library.
	For this to work, the default and container sources need to be loaded, see ah::yui::js_sources
} {
	set script "var $varname = new YAHOO.widget.Tooltip(\"alertTip\", { context:\"$element\", text:\"$message\", $options });"
	if { $enclose_p } { set script [ah::enclose_in_script -script ${script} ] }
	return $script
}