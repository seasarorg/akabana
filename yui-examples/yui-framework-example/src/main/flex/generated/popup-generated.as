
/**
 * 	Generated by mxmlc 2.0
 *
 *	Package:	
 *	Class: 		popup
 *	Source: 	D:\profile\yui-frameworks\workspace1\yui-frameworks-examples\src\main\flex\popup.mxml
 *	Template: 	flex2/compiler/mxml/gen/ClassDef.vm
 *	Time: 		2009.12.04 22:45:24 JST
 */

package 
{

import examples.yui.popup.action.PopupAction;
import examples.yui.popup.action.PopupOwnerAction;
import examples.yui.popup.view.PopupOwnerView;
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
import mx.core.Application;
import mx.core.ClassFactory;
import mx.core.DeferredInstanceFromClass;
import mx.core.DeferredInstanceFromFunction;
import mx.core.IDeferredInstance;
import mx.core.IFactory;
import mx.core.IPropertyChangeNotifier;
import mx.core.UIComponentDescriptor;
import mx.core.mx_internal;
import mx.styles.*;
import org.seasar.akabana.yui.framework.core.YuiFrameworkSettings;


[SWF( heightPercent='100%', widthPercent='100%')]
[Frame(extraClass="_popup_FlexInit")]

[Frame(factoryClass="_popup_mx_managers_SystemManager")]


//	begin class def

public class popup
	extends mx.core.Application
{

	//	instance variables
/**
 * @private
 **/
	public var _popup_YuiFrameworkSettings1 : org.seasar.akabana.yui.framework.core.YuiFrameworkSettings;

	[Bindable]
/**
 * @private
 **/
	public var rootView : examples.yui.popup.view.PopupOwnerView;


	//	type-import dummies


	//	Container document descriptor
private var _documentDescriptor_ : mx.core.UIComponentDescriptor = 
new mx.core.UIComponentDescriptor({
  type: mx.core.Application
  ,
  propertiesFactory: function():Object { return {
    childDescriptors: [
      new mx.core.UIComponentDescriptor({
        type: examples.yui.popup.view.PopupOwnerView
        ,
        id: "rootView"
        ,
        propertiesFactory: function():Object { return {
          percentHeight: 100.0,
          percentWidth: 100.0,
          minHeight: 600,
          minWidth: 800
        }}
      })
    ]
  }}
})

	//	constructor (Flex display object)
    /**
     * @private
     **/
	public function popup()
	{
		super();

		mx_internal::_document = this;

		//	our style settings


		//	ambient styles
		mx_internal::_popup_StylesInit();

		//	properties
		this.layout = "absolute";
		_popup_YuiFrameworkSettings1_i();

		//	events

	}

	//	initialize()
    /**
     * @private
     **/
	override public function initialize():void
	{
 		mx_internal::setDocumentDescriptor(_documentDescriptor_);



		super.initialize();
	}

	//	scripts
	//	end scripts


    //	supporting function definitions for properties, events, styles, effects
private function _popup_YuiFrameworkSettings1_i() : org.seasar.akabana.yui.framework.core.YuiFrameworkSettings
{
	var temp : org.seasar.akabana.yui.framework.core.YuiFrameworkSettings = new org.seasar.akabana.yui.framework.core.YuiFrameworkSettings();
	_popup_YuiFrameworkSettings1 = temp;
	temp.initialized(this, "_popup_YuiFrameworkSettings1")
	return temp;
}



	//	initialize style defs for popup

	mx_internal static var _popup_StylesInit_done:Boolean = false;

	mx_internal function _popup_StylesInit():void
	{
		//	only add our style defs to the StyleManager once
		if (mx_internal::_popup_StylesInit_done)
			return;
		else
			mx_internal::_popup_StylesInit_done = true;

		var style:CSSStyleDeclaration;
		var effects:Array;

		// PopupOwnerView
		style = StyleManager.getStyleDeclaration("PopupOwnerView");
		if (!style)
		{
			style = new CSSStyleDeclaration();
			StyleManager.setStyleDeclaration("PopupOwnerView", style, false);
		}
		if (style.factory == null)
		{
			style.factory = function():void
			{
				this.action = examples.yui.popup.action.PopupOwnerAction;
			};
		}
		// global
		style = StyleManager.getStyleDeclaration("global");
		if (!style)
		{
			style = new CSSStyleDeclaration();
			StyleManager.setStyleDeclaration("global", style, false);
		}
		if (style.factory == null)
		{
			style.factory = function():void
			{
				this.fontSize = 18;
			};
		}
		// PopupView
		style = StyleManager.getStyleDeclaration("PopupView");
		if (!style)
		{
			style = new CSSStyleDeclaration();
			StyleManager.setStyleDeclaration("PopupView", style, false);
		}
		if (style.factory == null)
		{
			style.factory = function():void
			{
				this.action = examples.yui.popup.action.PopupAction;
			};
		}

		StyleManager.mx_internal::initProtoChainRoots();
	}


	//	embed carrier vars
	//	end embed carrier vars


//	end class def
}

//	end package def
}