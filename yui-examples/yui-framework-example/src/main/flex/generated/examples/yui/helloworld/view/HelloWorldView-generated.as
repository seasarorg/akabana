
/**
 * 	Generated by mxmlc 2.0
 *
 *	Package:	examples.yui.helloworld.view
 *	Class: 		HelloWorldView
 *	Source: 	D:\profile\yui-frameworks\workspace1\yui-frameworks-examples\src\main\flex\examples\yui\helloworld\view\HelloWorldView.mxml
 *	Template: 	flex2/compiler/mxml/gen/ClassDef.vm
 *	Time: 		2009.12.04 21:59:09 JST
 */

package examples.yui.helloworld.view
{

import examples.yui.helloworld.ui.MyPanel;
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
import mx.binding.IBindingClient;
import mx.containers.ControlBar;
import mx.containers.VBox;
import mx.controls.Button;
import mx.controls.RadioButton;
import mx.controls.RadioButtonGroup;
import mx.controls.TextInput;
import mx.core.ClassFactory;
import mx.core.DeferredInstanceFromClass;
import mx.core.DeferredInstanceFromFunction;
import mx.core.IDeferredInstance;
import mx.core.IFactory;
import mx.core.IPropertyChangeNotifier;
import mx.core.UIComponentDescriptor;
import mx.core.mx_internal;
import mx.effects.Fade;
import mx.events.FlexEvent;
import mx.states.SetProperty;
import mx.states.State;
import mx.states.Transition;
import mx.styles.*;
import mx.validators.Validator;



//	begin class def

public class HelloWorldView
	extends mx.containers.VBox
	implements mx.binding.IBindingClient
{

	//	instance variables
/**
 * @private
 **/
	public var _HelloWorldView_SetProperty1 : mx.states.SetProperty;

	[Bindable]
/**
 * @private
 **/
	public var controlButton : mx.controls.Button;

	[Bindable]
/**
 * @private
 **/
	public var fadeOut : mx.effects.Fade;

	[Bindable]
/**
 * @private
 **/
	public var inputData : mx.controls.TextInput;

	[Bindable]
/**
 * @private
 **/
	public var inputDataValidator : mx.validators.Validator;

	[Bindable]
/**
 * @private
 **/
	public var inputText : mx.controls.TextInput;

	[Bindable]
/**
 * @private
 **/
	public var panel : examples.yui.helloworld.ui.MyPanel;

	[Bindable]
/**
 * @private
 **/
	public var radiogroup1 : mx.controls.RadioButtonGroup;

	[Bindable]
/**
 * @private
 **/
	public var remove : mx.controls.Button;

	[Bindable]
/**
 * @private
 **/
	public var showHelloWorld : mx.controls.Button;


	//	type-import dummies


	//	Container document descriptor
private var _documentDescriptor_ : mx.core.UIComponentDescriptor = 
new mx.core.UIComponentDescriptor({
  type: mx.containers.VBox
  ,
  propertiesFactory: function():Object { return {
    childDescriptors: [
      new mx.core.UIComponentDescriptor({
        type: examples.yui.helloworld.ui.MyPanel
        ,
        id: "panel"
        ,
        propertiesFactory: function():Object { return {
          childDescriptors: [
            new mx.core.UIComponentDescriptor({
              type: mx.controls.TextInput
              ,
              id: "inputText"
              ,
              propertiesFactory: function():Object { return {
                restrict: "0-9"
              }}
            })
          ,
            new mx.core.UIComponentDescriptor({
              type: mx.controls.TextInput
              ,
              id: "inputData"
            })
          ,
            new mx.core.UIComponentDescriptor({
              type: mx.controls.Button
              ,
              id: "showHelloWorld"
              ,
              propertiesFactory: function():Object { return {
                label: "はろーわーるどを表示する",
                height: 242,
                width: 402
              }}
            })
          ,
            new mx.core.UIComponentDescriptor({
              type: mx.controls.RadioButton
              ,
              propertiesFactory: function():Object { return {
                label: "Button 1",
                groupName: "radiogroup1"
              }}
            })
          ,
            new mx.core.UIComponentDescriptor({
              type: mx.controls.RadioButton
              ,
              propertiesFactory: function():Object { return {
                label: "Button 2",
                groupName: "radiogroup1"
              }}
            })
          ,
            new mx.core.UIComponentDescriptor({
              type: mx.containers.ControlBar
              ,
              propertiesFactory: function():Object { return {
                childDescriptors: [
                  new mx.core.UIComponentDescriptor({
                    type: mx.controls.Button
                    ,
                    id: "controlButton"
                  })
                ]
              }}
            })
          ]
        }}
      })
    ,
      new mx.core.UIComponentDescriptor({
        type: mx.controls.Button
        ,
        id: "remove"
        ,
        propertiesFactory: function():Object { return {
          label: "削除"
        }}
      })
    ]
  }}
})

	//	constructor (Flex display object)
    /**
     * @private
     **/
	public function HelloWorldView()
	{
		super();

		mx_internal::_document = this;

		//	our style settings
		//	initialize component styles
		if (!this.styleDeclaration)
		{
			this.styleDeclaration = new CSSStyleDeclaration();
		}

		this.styleDeclaration.defaultFactory = function():void
		{
			this.verticalAlign = "middle";
			this.horizontalAlign = "center";
		};



		//	properties
		this.percentWidth = 100.0;
		this.percentHeight = 100.0;
		this.doubleClickEnabled = true;
		this.states = [_HelloWorldView_State1_c()];
		this.transitions = [_HelloWorldView_Transition1_c()];
		_HelloWorldView_Validator1_i();
		_HelloWorldView_RadioButtonGroup1_i();

		//	events
		this.addEventListener("show", ___HelloWorldView_VBox1_show);
		this.addEventListener("hide", ___HelloWorldView_VBox1_hide);

	}

	//	initialize()
    /**
     * @private
     **/
	override public function initialize():void
	{
 		mx_internal::setDocumentDescriptor(_documentDescriptor_);

		var bindings:Array = _HelloWorldView_bindingsSetup();
		var watchers:Array = [];

		var target:HelloWorldView = this;

		if (_watcherSetupUtil == null)
		{
			var watcherSetupUtilClass:Object = getDefinitionByName("_examples_yui_helloworld_view_HelloWorldViewWatcherSetupUtil");
			watcherSetupUtilClass["init"](null);
		}

		_watcherSetupUtil.setup(this,
					function(propertyName:String):* { return target[propertyName]; },
					bindings,
					watchers);

		for (var i:uint = 0; i < bindings.length; i++)
		{
			Binding(bindings[i]).execute();
		}

		mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
		mx_internal::_watchers = mx_internal::_watchers.concat(watchers);


		super.initialize();
	}

	//	scripts
	//	end scripts


    //	supporting function definitions for properties, events, styles, effects
private function _HelloWorldView_Validator1_i() : mx.validators.Validator
{
	var temp : mx.validators.Validator = new mx.validators.Validator();
	inputDataValidator = temp;
	temp.required = true;
	temp.property = "text";
	mx.binding.BindingManager.executeBindings(this, "inputDataValidator", inputDataValidator);
	temp.initialized(this, "inputDataValidator")
	return temp;
}

private function _HelloWorldView_RadioButtonGroup1_i() : mx.controls.RadioButtonGroup
{
	var temp : mx.controls.RadioButtonGroup = new mx.controls.RadioButtonGroup();
	radiogroup1 = temp;
	temp.initialized(this, "radiogroup1")
	return temp;
}

private function _HelloWorldView_State1_c() : mx.states.State
{
	var temp : mx.states.State = new mx.states.State();
	temp.name = "hideButtonState";
	temp.overrides = [_HelloWorldView_SetProperty1_i()];
	return temp;
}

private function _HelloWorldView_SetProperty1_i() : mx.states.SetProperty
{
	var temp : mx.states.SetProperty = new mx.states.SetProperty();
	_HelloWorldView_SetProperty1 = temp;
	temp.name = "visible";
	temp.value = false;
	mx.binding.BindingManager.executeBindings(this, "_HelloWorldView_SetProperty1", _HelloWorldView_SetProperty1);
	return temp;
}

private function _HelloWorldView_Transition1_c() : mx.states.Transition
{
	var temp : mx.states.Transition = new mx.states.Transition();
	temp.effect = _HelloWorldView_Fade1_i();
	return temp;
}

private function _HelloWorldView_Fade1_i() : mx.effects.Fade
{
	var temp : mx.effects.Fade = new mx.effects.Fade();
	fadeOut = temp;
	temp.alphaFrom = 1;
	temp.alphaTo = 0;
	temp.duration = 1000;
	mx.binding.BindingManager.executeBindings(this, "fadeOut", fadeOut);
	return temp;
}

/**
 * @private
 **/
public function ___HelloWorldView_VBox1_show(event:mx.events.FlexEvent):void
{
	trace('rootView.onShow',event)
}

/**
 * @private
 **/
public function ___HelloWorldView_VBox1_hide(event:mx.events.FlexEvent):void
{
	trace('rootView.onHide',event)
}


	//	binding mgmt
    private function _HelloWorldView_bindingsSetup():Array
    {
        var result:Array = [];
        var binding:Binding;

        binding = new mx.binding.Binding(this,
            function():Object
            {
                return (showHelloWorld);
            },
            function(_sourceFunctionReturnValue:Object):void
            {
				
                _HelloWorldView_SetProperty1.target = _sourceFunctionReturnValue;
            },
            "_HelloWorldView_SetProperty1.target");
        result[0] = binding;
        binding = new mx.binding.Binding(this,
            function():Object
            {
                return (showHelloWorld);
            },
            function(_sourceFunctionReturnValue:Object):void
            {
				
                fadeOut.target = _sourceFunctionReturnValue;
            },
            "fadeOut.target");
        result[1] = binding;
        binding = new mx.binding.Binding(this,
            function():Object
            {
                return (inputData);
            },
            function(_sourceFunctionReturnValue:Object):void
            {
				
                inputDataValidator.source = _sourceFunctionReturnValue;
            },
            "inputDataValidator.source");
        result[2] = binding;

        return result;
    }

    private function _HelloWorldView_bindingExprs():void
    {
        var destination:*;
		[Binding(id='0')]
		destination = (showHelloWorld);
		[Binding(id='1')]
		destination = (showHelloWorld);
		[Binding(id='2')]
		destination = (inputData);
    }

    /**
     * @private
     **/
    public static function set watcherSetupUtil(watcherSetupUtil:IWatcherSetupUtil):void
    {
        (HelloWorldView)._watcherSetupUtil = watcherSetupUtil;
    }

    private static var _watcherSetupUtil:IWatcherSetupUtil;



	//	embed carrier vars
	//	end embed carrier vars

	//	binding management vars
    /**
     * @private
     **/
    mx_internal var _bindings : Array = [];
    /**
     * @private
     **/
    mx_internal var _watchers : Array = [];
    /**
     * @private
     **/
    mx_internal var _bindingsByDestination : Object = {};
    /**
     * @private
     **/
    mx_internal var _bindingsBeginWithWord : Object = {};

//	end class def
}

//	end package def
}
