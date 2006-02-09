ad_library {

	Library for Ajax Helper Procs
 	based on

    @author Hamilton Chua (ham@soluiongrove.com)
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

ad_proc -public ah::js_sources {
	{-default:boolean}
	{-source ""}
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

	@param source The caller can specify which set of javascript source files to load. 
		Valid values include 
		"rounder" : to load the rico corner rounder functions only, use this if you are working primarily with scriptaculous, 
		"rico" : to load the rico javascript library, 
		"overlibws" : to load the overlibmws javascript files for dhtml callouts and popups.

	@return 

	@error 

} {
	set ah_base_url [ah::get_url]
	set script ""
	set loaded [list]

	if { $default_p } {
		# load prototype and scriptaculous js files
		append script "<script type=\"text/javascript\" src=\"${ah_base_url}prototype/prototype.js\"></script> \n"
		append script "<script type=\"text/javascript\" src=\"${ah_base_url}scriptaculous/builder.js\"></script> \n"
		append script "<script type=\"text/javascript\" src=\"${ah_base_url}scriptaculous/controls.js\"></script> \n"
		append script "<script type=\"text/javascript\" src=\"${ah_base_url}scriptaculous/dragdrop.js\"></script> \n"
		append script "<script type=\"text/javascript\" src=\"${ah_base_url}scriptaculous/effects.js\"></script> \n"
		append script "<script type=\"text/javascript\" src=\"${ah_base_url}scriptaculous/slider.js\"></script> \n"
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
					# put javascript here to link to overlibmws javascript files
					# add code to initialize
					append script "<script language=\"JavaScript\" type=\"text/JavaScript\">var OLbubbleImageDir=\"${ah_base_url}overlibmws\";</script>"
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}overlibmws/overlibmws.js\"></script> \n"
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}overlibmws/overlibmws_bubble.js\"></script>\n"
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}overlibmws/overlibmws_overtwo.js\"></script>\n"
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}overlibmws/overlibmws_scroll.js\"></script>\n"
					append script "<script type=\"text/javascript\" src=\"${ah_base_url}overlibmws/overlibmws_draggable.js\"></script>\n"
				}
				default {
					# invalid value for source
				}
			}
		}
	}

	return $script

}

ad_proc -public ah::enclose_in_script {
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

ad_proc -public ah::ajaxrequest {
	-url:required
	{-pars ""}
	{-options ""}
} {
	Returns javascript that calls the prototype javascript library's ajax request (Ajax.Request) object.
	The Ajax.Request object will only perform an xmlhttp request to a url. 
	If you prefer to perform an xmlhttp request and then update the contents of a < div >, look at ajaxupdate.
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
	set script "new Ajax.Request('$url',{$preoptions})"
}

ad_proc -public ah::ajaxupdate {
	-container:required
	-url:required
	{-pars ""}
	{-options ""}
	{-effect "Appear"}
	{-effectopts ""}
	{-enclose:boolean}
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
	set preoptions "asynchronous:'true',method:'post'"

	if { [exists_and_not_null pars] } { 
		append preoptions ",parameters:$pars"
	}
	if { [exists_and_not_null options] } { append preoptions ",$options" }

	set effects_script [ah::effects -element $container -effect $effect -options $effectopts]	
	append preoptions ",onSuccess: function(t) { $effects_script }"

	set script "new Ajax.Updater ('$container','$url',{$preoptions}); \n"
	
	if { $enclose_p } { set script [ah::enclose_in_script -script ${script} ] }

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

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-01-16

	@param type this is passed to the overlibmws script, refer to overlib documentation for possible values.
	@param text the text that will appear in the popup.
	@param textsize teh size of the text in the popup

	@return 

	@error 

} {
	set script "onmouseover=\"overlib('$text', BUBBLE, BUBBLETYPE, '$type', TEXTSIZE, '$textsize');\" onmouseout=\"nd();\""
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
	set request [ah::ajaxrequest -url $url -pars '$pars' -options "onSuccess: function(t) { overlib(t.responseText, BUBBLE, BUBBLETYPE, '$type', TEXTSIZE, '$textsize'); }" ]
	set script "onmouseover=\"$request\" onmouseout=\"nd();\"" 
	return $script
}

ad_proc -public ah::effects {
	-element:required
	{-effect "Appear"}
	{-options ""}
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

	set script "new Effect.$effect\('$element',\{$options\}\)"
	return $script
}

ad_proc -public ah::draggable {
	-element:required
	{-options "revert:'true'"}
} {
	The parameters are passed directly to the scriptaculous script. 
	Parameters and options are case sensitive, refer to scriptaculous documentation.
	http://wiki.script.aculo.us/scriptaculous/show/Draggables

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-01-24

	@param element the page element that you want to apply the effect to
	@param options specify the scriptaculous options

	@return 

	@error 

} {
	set script "new Draggable \('$element',\{$options\}\)"
	return $script
}


ad_proc -public ah::sortable {
	-element:required
	{-options ""}
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
	set script "Sortable.create\('$element', \{$options\}\); \n"
	return $script
}

ad_proc -public ah::rounder {
	-element:required
	{-options ""}
} {
	Generates javascript to round html div elements.
	Parameters are case sensitive.
	http://encytemedia.com/blog/articles/2005/12/01/rico-rounded-corners-without-all-of-rico

	@author Hamilton Chua (ham@solutiongrove.com)	
	@creation-date 2006-01-24

	@param element the page element that you want the corners rounded
	@param options specify the options for rounding the element

} {
	set script "Rico.Corner.round('$element', \{$options\}); \n"
	return $script
}