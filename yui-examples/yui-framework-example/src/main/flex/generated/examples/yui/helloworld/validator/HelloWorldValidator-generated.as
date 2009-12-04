
/**
 * 	Generated by mxmlc 2.0
 *
 *	Package:	examples.yui.helloworld.validator
 *	Class: 		HelloWorldValidator
 *	Source: 	D:\profile\yui-frameworks\workspace1\yui-frameworks-examples\src\main\flex\examples\yui\helloworld\validator\HelloWorldValidator.mxml
 *	Template: 	flex2/compiler/mxml/gen/ClassDef.vm
 *	Time: 		2009.12.04 21:59:09 JST
 */

package examples.yui.helloworld.validator
{

import flash.accessibility.*;
import flash.debugger.*;
import flash.display.*;
import flash.errors.*;
import flash.events.*;
import flash.external.*;
import flash.filters.*;
import flash.geom.*;
import flash.media.*;
import flash.net.*;
import flash.printing.*;
import flash.profiler.*;
import flash.system.*;
import flash.text.*;
import flash.ui.*;
import flash.utils.*;
import flash.xml.*;
import mx.binding.*;
import mx.collections.ArrayCollection;
import mx.core.ClassFactory;
import mx.core.DeferredInstanceFromClass;
import mx.core.DeferredInstanceFromFunction;
import mx.core.IDeferredInstance;
import mx.core.IFactory;
import mx.core.IPropertyChangeNotifier;
import mx.core.mx_internal;
import mx.styles.*;
import mx.validators.StringValidator;



//	begin class def

public class HelloWorldValidator
	extends mx.collections.ArrayCollection
{

	//	instance variables
	[Bindable]
/**
 * @private
 **/
	public var inputText : mx.validators.StringValidator;


	//	type-import dummies



	//	constructor (non-Flex display object)
    /**
     * @private
     **/
	public function HelloWorldValidator()
	{
	    super();


		//	our style settings



		//	properties
		this.source = [_HelloWorldValidator_StringValidator1_i()];

		//	events




	}

	//	scripts
	//	end scripts


    //	supporting function definitions for properties, events, styles, effects
private function _HelloWorldValidator_StringValidator1_i() : mx.validators.StringValidator
{
	var temp : mx.validators.StringValidator = new mx.validators.StringValidator();
	inputText = temp;
	temp.property = "text";
	temp.minLength = 4;
	temp.maxLength = 8;
	temp.required = true;
	temp.tooLongError = "ながすぎー";
	temp.tooShortError = "みじかすぎー";
	temp.initialized(this, "inputText")
	return temp;
}





	//	embed carrier vars
	//	end embed carrier vars


//	end class def
}

//	end package def
}
