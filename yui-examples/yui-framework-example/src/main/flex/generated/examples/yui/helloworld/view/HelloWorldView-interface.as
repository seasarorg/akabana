
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
import mx.containers.VBox;
import mx.controls.Button;
import mx.controls.RadioButtonGroup;
import mx.controls.TextInput;
import mx.core.ClassFactory;
import mx.core.DeferredInstanceFromClass;
import mx.core.DeferredInstanceFromFunction;
import mx.core.IDeferredInstance;
import mx.core.IFactory;
import mx.core.IPropertyChangeNotifier;
import mx.core.mx_internal;
import mx.effects.Fade;
import mx.styles.*;
import mx.validators.Validator;
import mx.containers.ControlBar;
import mx.states.SetProperty;
import mx.containers.VBox;
import mx.states.Transition;
import mx.states.State;
import mx.controls.RadioButton;

public class HelloWorldView extends mx.containers.VBox
{
	public function HelloWorldView() {}

	[Bindable]
	public var fadeOut : mx.effects.Fade;
	[Bindable]
	public var inputDataValidator : mx.validators.Validator;
	[Bindable]
	public var panel : examples.yui.helloworld.ui.MyPanel;
	[Bindable]
	public var inputText : mx.controls.TextInput;
	[Bindable]
	public var inputData : mx.controls.TextInput;
	[Bindable]
	public var showHelloWorld : mx.controls.Button;
	[Bindable]
	public var radiogroup1 : mx.controls.RadioButtonGroup;
	[Bindable]
	public var controlButton : mx.controls.Button;
	[Bindable]
	public var remove : mx.controls.Button;

	mx_internal var _bindings : Array;
	mx_internal var _watchers : Array;
	mx_internal var _bindingsByDestination : Object;
	mx_internal var _bindingsBeginWithWord : Object;


}}
