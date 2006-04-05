ad_library {

	Library for Ajax Helper Procs
 	based on Yahoo's User Interface Libraries

    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2006-01-16
}

namespace eval ah::yahoo { }

ad_proc -public ah::yahoo::js_sources {
	{-default:boolean}
	{-source ""}
} {
	
	Generates the < script > syntax needed on the head 
	for Yahoo's User Interface Library
	The code :
	<pre>
		[ah::yahoo::js_sources -default]
	</pre>
	will load the default YUI javascript library which includes the connections and doms js files

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-01-16

	@param default Loads the prototype and scriptaculous javascript libraries.
	@param source The caller can specify which set of javascript source files to load. 
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

	if { $default_p } {
		append script "<script type=\"text/javascript\" src=\"${ah_base_url}yahoo/YAHOO.js\"></script> \n"
		append script "<script type=\"text/javascript\" src=\"${ah_base_url}yahoo/dom/build/dom.js\"></script> \n"		
	} else {
		if { [info exists source] } {
			# load other js libraries
			switch $source {
				"animation" { 
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}yahoo/animation/build/animation.js\"></script> \n" 
				}
				"event" {
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}yahoo/event/build/event.js\"></script> \n" 
				}
				"treeview" {
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}yahoo/treeview/build/treeview.js\"></script> \n" 
				}
				"calendar" {
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}yahoo/calendar/build/calendar.js\"></script> \n" 
				}
				"dragdrop" {
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}yahoo/dragdrop/build/dragdrop.js\"></script> \n" 
				}
				"slider" {
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}yahoo/slider/build/slider.js\"></script> \n" 
				}

				default {
					# invalid value for source
				}
			}
		}
	}

	return $script
}

ad_proc -public ah::yahoo::addlistener {
	-element:required
	-event:required
	{-callback ""}
	{-element_is_var:boolean}
} {
	Creates javascript for Yahoo's Event Listener.
} {
	if { !$element_is_var_p } { 
		set element [ah::isnot_js_var $element]
	}
	return "YAHOO.util.Event.addListener($element,\"$event\",${callback});\n"
}