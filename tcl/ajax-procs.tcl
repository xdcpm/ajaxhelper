ad_library {

	Library for Ajax Helper Procs
 	based on Scriptaculous and Prototype for Ajax and Effects
	OverlibMWS for Popups

    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2006-01-16
}

namespace eval ah { }

ad_proc -private ah::get_package_id  {

} {
	Return the package_id of the installed and mounted ajax helper instance

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
	return "/resources/ajaxhelper/"
}

ad_proc -private ah::isnot_js_var {
	element
} {
	Receives a string and surrounds it with single quotes.
	This is a utility proc used to make a parameter passed to a proc a string.
	The assumption is that an element passed as a parameter is a javascript variable.

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-01-16
	@return 
} {
	return "'$element'"
}

ad_proc -private ah::dynamic_load_functions {
	
} {
	Generates the javascript functions that perform dynamic loading of local javascript files.
	http://www.phpied.com/javascript-include/
        WARNING : experimental

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-04-20

} {
	set ah_base_url [ah::get_url]
	set script "<script type=\"text/javascript\" src=\"${ah_base_url}dynamicInclude.js\"></script>"
	return $script
}

ad_proc -public ah::js_include {
	{-js_file ""}
} {
	Generates the javscript to include a js file dynamically via DOM to the head section of the page.
        WARNING : experimental

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-04-20
} {
	return "js_include_once('$js_file'); "
}

ad_proc -public ah::js_source_dynamic {
	{-js "default"}
	{-enclose:boolean}
} {
	Uses the javascript dynamic loading functions to load the comma separated list of javascript source file.
        WARNING : experimental

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-04-20


	@param js A comma separated list of js files to load.
		Possible values include prototype, scriptaculous, rounder, rico, overlibmws, overlibmws_bubble, overlibmws_scroll, overlibmws_drag
        @param enclose Specify this if you want the javascript to be enclosed in script tags, which is usually the case unless you include this along with other javascript.
} {

	set ah_base_url [ah::get_url]
	set script ""
	set js_file_list [split $js ","]
	
	foreach x $js_file_list {
		switch $x {
			"rico" { 
				append script [ah::js_include -js_file "${ah_base_url}rico/rico.js"]
			}
			"rounder" {
				append script [ah::js_include -js_file "${ah_base_url}rico/rico.js"]
				append script [ah::js_include -js_file "${ah_base_url}rico/rounder.js"]
			}
			"overlibmws" {
				append script [ah::js_include -js_file "${ah_base_url}overlibmws/overlibmws.js"]
				append script [ah::js_include -js_file "${ah_base_url}overlibmws/overlibmws_overtwo.js"]
			}
			"overlibmws_bubble" {
				append script [ah::js_include -js_file "${ah_base_url}overlibmws/overlibmws_bubble.js"]
			}
			"overlibmws_scroll" {
				append script [ah::js_include -js_file "${ah_base_url}overlibmws/overlibmws_scroll.js"]
			}
			"overlibmws_drag" {
				append script [ah::js_include -js_file "${ah_base_url}overlibmws/overlibmws_draggable.js"]
			}
			default {
				append script [ah::js_include -js_file "${ah_base_url}prototype/prototype.js"]
				append script [ah::js_include -js_file "${ah_base_url}scriptaculous/scriptaculous.js"]
			}
		}
	}

	if { $enclose_p } { set script [ah::enclose_in_script -script ${script} ] }

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
	set tag "<script language=\"javascript\" type=\"text/javascript\"> \n"
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
        See ah::yui::addlistener for Yahoo's implementation which some say is more superior.
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

ad_proc -public ah::ajaxperiodical {
	-url:required
	-container:required
	{-frequency "5"}
	{-asynchronous "true"}
	{-pars ""}
	{-options ""}
} {
	Returns javascript that calls the prototype javascript library's ajax periodic updater object.
	This object makes "polling" possible. Polling is a way by which a website can regularly update itself.
	The ajax script is executed periodically in a set interval. 
	It has the same properties as ajax update, the only difference is that it is executed after x number of seconds.
	Parameters and options are case sensitive, refer to scriptaculous documentation
	http://wiki.script.aculo.us/scriptaculous/show/Ajax.PeriodicalUpdater
} {
	set preoptions "asynchronous:${asynchronous},frequency:${frequency},method:'post'"

	if { [exists_and_not_null pars] } { 
		append preoptions ",parameters:$pars"
	}
	if { [exists_and_not_null options] } { append preoptions ",$options" }	
	set script "new Ajax.PeriodicalUpdater('$container','$url',{$preoptions}); "

	return $script

}

ad_proc -public ah::ajaxrequest {
	-url:required
	{-asynchronous "true"}
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
        @param asynchronous the default is true

} {
	set preoptions "asynchronous:${asynchronous},method:'post'"

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
	{-asynchronous "true"}
	{-pars ""}
	{-options ""}
	{-effect ""}
	{-effectopts ""}
	{-enclose:boolean}
	{-container_is_var:boolean}
} {
	Generate an Ajax.Updater javascript object. 
	The parameters are passed directly to the Ajax.Update script.
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

	set preoptions "asynchronous:$asynchronous,method:'post'"

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
        See ah::yui::tooltip for Yahoo's implementation

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
	The ah::source must be called with -source "overlibmws,overlibmws_bubble"

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
        @param options the options you want to pass to overlibmws
        @param type parameter specific to the bubble callout
        @param textsize the size of the text in the callout

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
	@param options specify the options to pass to the scritpaculous javascript
        @param element_is_var specify this if the element you are passing is a javascript variable

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
	Generates javascript that toggles the state of an element.
	The parameters are passed directly to the scriptaculous toggle script. 
	Parameters and options are case sensitive, refer to scriptaculous documentation.
	http://wiki.script.aculo.us/scriptaculous/show/Effect.toggle

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-02-23

	@param element the page element that you want to apply the effect to
	@param effect specify one of the scriptaculous effects you want to toggle
	@param options specify the options to pass to the scritpaculous javascript
        @param element_is_var specify this if the element you are passing is a javascript variable
	
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
	@param element_is_var specify this parameter if the element you are passing is a javscript variable

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
	@param element_is_var specify this parameter if the element you are passing is a javscript variable

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

ad_proc -public ah::js_sources {
	{-source "default"}
} {
	
	Will load the prototype javascript library and scriptaculous javascript files.

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-01-16

	@param source The caller can specify which set of javascript source files to load. This can be a comma seprated list
		Valid values include 
		"default" : to load prototype and scriptaculous libraries
		"rounder" : to load the rico corner rounder functions only, use this if you are working primarily with scriptaculous, 
		"rico" : to load the rico javascript library, 
		"overlibmws" : to load the overlibmws javascript files for dhtml callouts and popups.
		"overlibmws_bubble" : to load the overlibmws javascript files for dhtml callouts and popups.
		"overlibmws_scroll" : to load the overlibmws javascript files for dhtml bubble callouts and popups that scroll.
		"overlibmws_drag" : to load the overlibmws javascript files for draggable dhtml callouts and popups.

	@return
	@error 
} {

	set ah_base_url [ah::get_url]
	set js_file_list [split $source ","]
	set script ""
	
	foreach x $js_file_list {
		switch $x {
			"rico" { 
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}rico/rico.js\"></script> \n" 
			}
			"rounder" {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}rico/rounder.js\"></script> \n" 			}
			"overlibmws" {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}overlibmws/overlibmws.js\"></script> \n"
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}overlibmws/overlibmws_overtwo.js\"></script>\n"
			}
			"overlibmws_bubble" {
				append script "<script type=\"text/JavaScript\">var OLbubbleImageDir=\"${ah_base_url}overlibmws\";</script>\n"
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}overlibmws/overlibmws_bubble.js\"></script>\n"
			}
			"overlibmws_scroll" {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}overlibmws/overlibmws_scroll.js\"></script>\n"
			}
			"overlibmws_drag" {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}overlibmws/overlibmws_draggable.js\"></script>\n"
			}
			default {
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}prototype/prototype.js\"></script> \n"
				append script "<script type=\"text/javascript\" src=\"${ah_base_url}scriptaculous/scriptaculous.js\"></script> \n"		
			}
		}
	}

	return $script
}

ad_proc -public ah::generate_autosuggest_array {
    {-array_list {}}
    {-sql_query {}}
} {
    Generates a javascript array for inclusion in a page header.
    This array will be used as values for the autosuggestbox.
    Array is a two-dimensional array with first elements the word
    for autosuggesting and the second is for the description

    @author Deds Castillo (deds@i-manila.com.ph)
    @creation-date 2006-06-21

    @param array_list a list of lists which will be constructed
                      as the javascript array. this takes priority
                      over sql_query parameter.
    @param sql_query  sql query to pass to db_list_of_lists to generate
                      the array
} {
    if {[llength $array_list]} {
	set suggestion_list $array_list
    } elseif {![string equal $sql_query {}]} {
	set suggestion_list [db_list_of_lists get_array_list $sql_query]
    } else {
	# just do something for failover
	set suggestion_list {}
    }

    set suggestions_stub {}
    
    append suggestions_stub "
function AUTOSuggestions() {
    this.auto = \[
    "

set suggestion_formatted_list {}
foreach suggestion $suggestion_list {
    lappend suggestion_formatted_list "\[\"[lindex $suggestion 0]\",\"[lindex $suggestion 1]\"\]"
}

append suggestions_stub [join $suggestion_formatted_list ","]

append suggestions_stub "
    \];
}
"
append suggestions_stub {
    AUTOSuggestions.prototype.requestSuggestions = function (oAutoSuggestControl /*:AutoSuggestControl*/,
							     bTypeAhead /*:boolean*/) {
								 var aSuggestions = [];
								 var aDescriptions = [];
								 var sTextboxValue = oAutoSuggestControl.textbox.value.toLowerCase();
								  
								 if (sTextboxValue.length > 0){
								          
								          //search for matching states
									  for (var i=0; i < this.auto.length; i++) {
														    if (this.auto[i][0].toLowerCase().indexOf(sTextboxValue) == 0) {
															aSuggestions.push(this.auto[i][0]);
															aDescriptions.push(this.auto[i][1]);
														    }
														}
								      }
								  
								  //provide suggestions to the control
								 oAutoSuggestControl.autosuggest(aSuggestions, aDescriptions, bTypeAhead);
							     };
}
 
return $suggestions_stub

}