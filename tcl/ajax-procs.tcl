ad_library {

	Library for Ajax Helper Procs
 	based on 
	Scriptaculous and Prototype for Ajax and Effects
	OverlibMWS for Popups

    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2006-01-16
}

namespace eval ah { }

ad_proc -private ah::get_package_id  {

} {
	Return the package_id of the installed and mounted ajax helper

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-01-16
	@return 

	@error 

} {
	return [apm_package_id_from_key "ajaxhelper"]
}

ad_proc -private ah::get_url  {

} {
	Return the URL to the mounted ajax helper instance

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-01-16
	@return 

	@error 

} {
	return [apm_package_url_from_id [ah::get_package_id]]
}

ad_proc -private ah::isnot_js_var {
	element
} {
	Receives a string and surrounds it with single quotes.
	This is a utility proc used to make a parameter passed to a proc a string.
	The assumption is that an element passed as a parameter is a javascript variable.
} {
	return "'$element'"
}

ad_proc -public ah::js_sources {
	{-default:boolean}
	{-source ""}
	{-withbubble:boolean}
	{-scrollable:boolean}
	{-draggable:boolean}
} {
	
	Generates the < script > syntax needed on the head 
	for each set of javascript files this package uses or needs to source.
	The code :
	<pre>
		[ah::js_sources -default]
	</pre>
	will load the prototype javascript library and scriptaculous javascript files by default.

	It's not recommended to mix scriptaculous and rico.

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-01-16

	@param default Loads the prototype and scriptaculous javascript libraries.
	@param source The caller can specify which set of javascript source files to load. 
		Valid values include 
		"rounder" : to load the rico corner rounder functions only, use this if you are working primarily with scriptaculous, 
		"rico" : to load the rico javascript library, 
		"overlibws" : to load the overlibmws javascript files for dhtml callouts and popups.

	@param withbubble Do we want to use the overlibmws plugin for bubble callouts ?
	@param scrollable Do we want to use the overlibmws scrollable plugin ?
	@param draggable Do we want to use the overlibmws draggable plugin ?

	@return 

	@error 

} {
	set ah_base_url [ah::get_url]
	set script ""

	if { $default_p } {
		# load prototype and scriptaculous js files
		append script "<script type=\"text/javascript\" src=\"${ah_base_url}prototype/prototype.js\"></script> \n"
		append script "<script type=\"text/javascript\" src=\"${ah_base_url}scriptaculous/scriptaculous.js\"></script> \n"		
	} else {
		if { [info exists source] } {
			# load other js libraries
			switch $source {
				"rico" { 
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}rico/rico.js\"></script> \n" 
				}
				"rounder" {
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}rico/rounder.js\"></script> \n" 
				}
				"overlibmws" {
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}overlibmws/overlibmws.js\"></script> \n"
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}overlibmws/overlibmws_overtwo.js\"></script>\n"
					if { $withbubble_p } {
						append script "<script language=\"JavaScript\" type=\"text/JavaScript\">var OLbubbleImageDir=\"${ah_base_url}overlibmws\";</script>\n"
						append script "<script type=\"text/javascript\" src=\"${ah_base_url}overlibmws/overlibmws_bubble.js\"></script>\n"
					}
					if { $scrollable_p } {
						append script "<script type=\"text/javascript\" src=\"${ah_base_url}overlibmws/overlibmws_scroll.js\"></script>\n"
					}
					if { $draggable_p } {
						append script "<script type=\"text/javascript\" src=\"${ah_base_url}overlibmws/overlibmws_draggable.js\"></script>\n"
					}	
				}
				default {
					# invalid value for source
				}
			}
		}
	}

	return $script

}

ad_proc -private ah::enclose_in_script {
	-script:required
} {
	Encloses whatever is passed to the script parameter in javascript tags.
	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-01-16

	@param script string to enclose in javascript tags.
} {
	set tag "<script language=\"JavaScript\" type=\"text/JavaScript\"> \n"
	append tag ${script}
	append tag "\n</script>"
	return $tag
}

ad_proc -public ah::starteventwatch {
	-element:required
	-event:required
	-obs_function:required
	{-element_is_var:boolean}
	{-useCapture "false"}
} {
	Use prototype's Event object to watch/listen to a specific event from a specific html element.
	Valid events include click, load, mouseover etc.
	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-02-28

	@param element the element you want to observe
	@param event the event that the observer will wait for
	@param obs_function the funcion that will be executed when the event is detected
	
} {
	if { !$element_is_var_p } { 
		set element [ah::isnot_js_var $element]
	}
	set script "Event.observe(${element}, '${event}', ${obs_function}, $useCapture);"
	return $script
}

ad_proc -public ah::stopeventwatch {
	-element:required
	-event:required
	-obs_function:required
	{-useCapture "false"}
	{-element_is_var:boolean}
} {
	Use prototype's Event object to watch/listen to a specific event from a specific html element.
	Valid events include click, load, mouseover etc.
	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-02-28

	@param element the element you want to observe
	@param event the event that the observer will wait for
	@param obs_function the funcion that will be executed when the event is detected
	
} {
	if { !$element_is_var_p } { 
		set element [ah::isnot_js_var $element]
	}
	set script "Event.stopObserving(${element}, '${event}', ${obs_function}, $useCapture);"
	return $script
}


ad_proc -public ah::ajaxrequest {
	-url:required
	{-pars ""}
	{-options ""}
} {
	Returns javascript that calls the prototype javascript library's ajax request (Ajax.Request) object.
	The Ajax.Request object will only perform an xmlhttp request to a url. 
	If you prefer to perform an xmlhttp request and then update the contents of a < div >, look at ah::ajaxupdate.
	Parameters and options are case sensitive, refer to scriptaculous documentation.
	http://wiki.script.aculo.us/scriptaculous/show/Ajax.Request


	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-01-16

	@param url the url that the javascript will call/query
	@param pars the parameters that will be passed to Ajax.Request. these parameters should normally be enclosed in single quotes ('') unless you intend to provide a javascript variable or function as a parameter
	@param options the options that will be passed to the Ajax.Request javascript function

} {
	set preoptions "asynchronous:'true',method:'post'"

	if { [exists_and_not_null pars] } { 
		append preoptions ",parameters:$pars"
	}
	if { [exists_and_not_null options] } { append preoptions ",$options" }	
	set script "new Ajax.Request('$url',{$preoptions}); "

	return $script
}

ad_proc -public ah::ajaxupdate {
	-container:required
	-url:required
	{-pars ""}
	{-options ""}
	{-effect ""}
	{-effectopts ""}
	{-enclose:boolean}
	{-container_is_var:boolean}
} {
	Generate an Ajax.Updater javascript object. 
	The parameters are passed directly to Ajax.Update script.
	You can optionally specify an effect to use as the container is updated. 
	By default it will use the "Appear" effect.
	Parameters and options are case sensitive, refer to scriptaculous documentation.
	http://wiki.script.aculo.us/scriptaculous/show/Ajax.Updater

	<pre>
		set script [ah::ajaxupdate -container "connections"  \
				-url "/xmlhttp/getconnections" \
				-pars "'q=test&limit_n=3'"
				-enclose  \
				-effectopts "duration: 1.5"]
	</pre>
	
	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-01-16

	@param container the 'id' of the layer (div) you want to update via ajax
	@param url the url that will be querried for the content to update the container's innerHtml
	@param options optional parameters that you can pass to the Ajax.Updater script
	@param effect optionally specify an effect to use as the container is updated
	@param effectopts options for the effect
	@param enclose optionally specify whether you want your script to be enclosed in < script > tags

	@return 

	@error 
} {
	if { !$container_is_var_p } {
		set container [ah::isnot_js_var $container]
	}

	set preoptions "asynchronous:'true',method:'post'"

	if { [exists_and_not_null pars] } { 
		append preoptions ",parameters:$pars"
	}
	if { [exists_and_not_null options] } { append preoptions ",$options" }

	if { [exists_and_not_null effect] } {
		set effects_script [ah::effects -element $container -effect $effect -options $effectopts -element_is_var]
		append preoptions ",onSuccess: function(t) { $effects_script }"
	}

	set script "new Ajax.Updater ($container,'$url',\{$preoptions\}); "
	
	if { $enclose_p } { set script [ah::enclose_in_script -script ${script} ] }

	return $script
}

ad_proc -public ah::popup {
	-content:required
	{-options ""}
} {
	This proc will generate javascript for an overlibmws popup.
	This script has to go into a javscript event like onClick or onMouseover.
	The ah::source must be executed with -source "overlibmws"
	For more information about the options that you can pass 
	http://www.macridesweb.com/oltest/

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-02-12

	@param content this is what the popup will contain or display. if content is text, enclose it in single quotes (' ').
	@param options the options to pass to overlibmws

	@return 

	@error 

} {
	if { [exists_and_not_null options] } {
		set overlibopt ","
		append overlibopt $options		
	} else {
		set overlibopt ""
	}
	set script "return overlib\(${content}${overlibopt}\);"
	return $script
}

ad_proc -public ah::clearpopup {

} {
	This proc will generate javascript for to clear a popup.
	This script has to go into a javscript event like onClick or onMouseover.
	The ah::source must be executed with -source "overlibmws"

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-02-12

	@return 

	@error 

} {
	set script "nd();"
	return $script
}

ad_proc -public ah::bubblecallout {
	-text:required
	{-type "square"}
	{-textsize "x-small"}
} {

	This proc will generate mouseover and mouseout javascript 
	for dhtml callout or popup using overlibmws 
	and the overlibmws bubble plugin.
	The ah::source must be called with -source "overlibmws" -withbubble

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-01-16

	@param type this is passed to the overlibmws script, refer to overlib documentation for possible values.
	@param text the text that will appear in the popup.
	@param textsize the size of the text in the popup

	@return 

	@error 

} {
	set script "onmouseover=\""
	append script [ah::popup -content "'$text'" -options "BUBBLE,BUBBLETYPE,'$type',TEXTSIZE,'$textsize'"]
	append script "\" onmouseout=\""
	append script [ah::clearpopup]
	append script "\""
	return $script
}

ad_proc -public ah::ajax_bubblecallout {
	-url:required
	{-pars ""}
	{-options ""}
	{-type "square"}
	{-textsize "x-small"}	
} {
	This proc executes an xmlhttp call and outputs the response text in a bubblecallout.

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-01-16
	
	@param url the url to make the xmlhttp call to
	@param pars the parameters in querystring format you want to pass to the url

	@return 

	@error 
} {
	set popup [ah::popup -content "t.responseText" -options "BUBBLE,BUBBLETYPE,'$type',TEXTSIZE,'$textsize'"]
	set request [ah::ajaxrequest -url $url -pars '$pars' -options "onSuccess: function(t) { $popup }" ]
	set script "onmouseover=\"$request\" onmouseout=\"nd();\"" 
	return $script
}

ad_proc -public ah::effects {
	-element:required
	{-effect "Appear"}
	{-options ""}
	{-element_is_var:boolean}
} {
	Generates javascript for effects by scriptaculous. 
	Refer to the scriptaculous documentaiton for a list of effects.
	This proc by default will use the "Appear" effect
	The parameters are passed directly to the scriptaculous effects script. 
	Parameters and options are case sensitive, refer to scriptaculous documentation.
	http://wiki.script.aculo.us/scriptaculous/show/CoreEffects

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-01-16

	@param element the page element that you want to apply the effect to
	@param effect specify one of the scriptaculous effects you want to implement
	@param options specify the options to pass to the javascript

	@return 

	@error 

} {
	if { !$element_is_var_p } { 
		set element [ah::isnot_js_var $element]
	}
	set script "new Effect.$effect\($element,\{$options\}\); "
	return $script
}

ad_proc -public ah::toggle {
	-element:required
	{-effect "Appear"}
	{-options ""}
	{-element_is_var:boolean}
} {
	Generates javascript that toggle the state of an element.
	The parameters are passed directly to the scriptaculous toggle script. 
	Parameters and options are case sensitive, refer to scriptaculous documentation.
	http://wiki.script.aculo.us/scriptaculous/show/Effect.toggle

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-02-23

	@param element the page element that you want to apply the effect to
	@param effect specify one of the scriptaculous effects you want to toggle

	@return 

	@error 

} {
	if { !$element_is_var_p } { 
		set element [ah::isnot_js_var $element]
	}
	set script "Effect.toggle\($element,'$effect',{$options}\)"
	return $script
}

ad_proc -public ah::draggable {
	-element:required
	{-options ""}
	{-uid ""}
	{-element_is_var:boolean}
} {
	Generates javascript to make the given element a draggable.
	The parameters are passed directly to the scriptaculous script. 
	Parameters and options are case sensitive, refer to scriptaculous documentation.
	http://wiki.script.aculo.us/scriptaculous/show/Draggables

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-01-24

	@param element the page element that you want to make draggable
	@param options specify the scriptaculous options
	@param uid provide a unique id that is used as a variable to associate with the draggable
	@param element_is_var specify this parameter if the element you are passing is a javscript variable

	@return 

	@error 

} {
	if { !$element_is_var_p } { 
		set element [ah::isnot_js_var $element]
	}

	set script "new Draggable \($element,\{$options\}\);"

	return $script
}

ad_proc -public ah::droppable {
	-element:required
	{-options ""}
	{-uid ""}
	{-element_is_var:boolean}
} {
	Generates javascript to make the given element a droppable.
	If a uid parameter is provided, the script will also check if the droppable with the same uid has already been created.
	The parameters are passed directly to the scriptaculous script. 
	Parameters and options are case sensitive, refer to scriptaculous documentation.
	http://wiki.script.aculo.us/scriptaculous/show/Droppables

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-02-24

	@param element the page element that you want to be a droppable
	@param element_is_var specify this parameter if the element you are passing is a javscript variable
	@param uid provide a unique id that is used as a variable to associate with the droppable
	@param options specify the scriptaculous options for droppables

	@return 

	@error 

} {	
	if { !$element_is_var_p } { 
		set element [ah::isnot_js_var $element]
	}

	set script "Droppables.add (${element},{${options}});"

	return $script
}

ad_proc -public ah::droppableremove {
	-element:required
	{-element_is_var:boolean}
} {
	Generates javascript to remove a droppable.
	The parameters are passed directly to the scriptaculous script. 
	Parameters and options are case sensitive, refer to scriptaculous documentation.
	http://wiki.script.aculo.us/scriptaculous/show/Droppables

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-02-24

	@param element the page element that you want to be a droppable

	@return 

	@error 

} {
	if { !$element_is_var_p } { 
		set element [ah::isnot_js_var $element]
	}
	set script "Droppables.remove \($element);"
	return $script
}


ad_proc -public ah::sortable {
	-element:required
	{-options ""}
	{-element_is_var:boolean}
} {
	Generates javascript for sortable elements.
	The parameters are passed directly to the scriptaculous sortable script. 
	Parameters and options are case sensitive, refer to scriptaculous documentation.
	http://wiki.script.aculo.us/scriptaculous/show/Sortables

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-01-24

	@param element the page element that you want to apply the effect to
	@param options specify the scriptaculous options

	@return 

	@error 
} {
	if { !$element_is_var_p } { 
		set element [ah::isnot_js_var $element]
	}
	set script "Sortable.destroy($element); "
	append script "Sortable.create\($element, \{$options\}\); "
	return $script
}

ad_proc -public ah::rounder {
	-element:required
	{-options ""}
	{-element_is_var:boolean}
} {
	Generates javascript to round html div elements.
	The ah::source must be executed with -source "rounder"
	Parameters are case sensitive.
	http://encytemedia.com/blog/articles/2005/12/01/rico-rounded-corners-without-all-of-rico

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-01-24

	@param element the page element that you want the corners rounded
	@param options specify the options for rounding the element

} {
	if { !$element_is_var_p } { 
		set element [ah::isnot_js_var $element]
	}
	set script "Rico.Corner.round\($element, \{$options\}\); "
	return $script
}