

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.core.IPropertyChangeNotifier;
import mx.events.PropertyChangeEvent;
import mx.utils.ObjectProxy;
import mx.utils.UIDUtil;

import mx.controls.Button;
import mx.effects.Fade;
import examples.yui.helloworld.ui.MyPanel;
import mx.controls.TextInput;
import mx.validators.Validator;
import mx.controls.RadioButtonGroup;

class BindableProperty
{
	/**
	 * generated bindable wrapper for property controlButton (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'controlButton' moved to '_398606063controlButton'
	 */

    [Bindable(event="propertyChange")]
    public function get controlButton():mx.controls.Button
    {
        return this._398606063controlButton;
    }

    public function set controlButton(value:mx.controls.Button):void
    {
    	var oldValue:Object = this._398606063controlButton;
        if (oldValue !== value)
        {
            this._398606063controlButton = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "controlButton", oldValue, value));
        }
    }

	/**
	 * generated bindable wrapper for property fadeOut (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'fadeOut' moved to '_1091436750fadeOut'
	 */

    [Bindable(event="propertyChange")]
    public function get fadeOut():mx.effects.Fade
    {
        return this._1091436750fadeOut;
    }

    public function set fadeOut(value:mx.effects.Fade):void
    {
    	var oldValue:Object = this._1091436750fadeOut;
        if (oldValue !== value)
        {
            this._1091436750fadeOut = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "fadeOut", oldValue, value));
        }
    }

	/**
	 * generated bindable wrapper for property inputData (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'inputData' moved to '_1706477204inputData'
	 */

    [Bindable(event="propertyChange")]
    public function get inputData():mx.controls.TextInput
    {
        return this._1706477204inputData;
    }

    public function set inputData(value:mx.controls.TextInput):void
    {
    	var oldValue:Object = this._1706477204inputData;
        if (oldValue !== value)
        {
            this._1706477204inputData = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "inputData", oldValue, value));
        }
    }

	/**
	 * generated bindable wrapper for property inputDataValidator (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'inputDataValidator' moved to '_464942306inputDataValidator'
	 */

    [Bindable(event="propertyChange")]
    public function get inputDataValidator():mx.validators.Validator
    {
        return this._464942306inputDataValidator;
    }

    public function set inputDataValidator(value:mx.validators.Validator):void
    {
    	var oldValue:Object = this._464942306inputDataValidator;
        if (oldValue !== value)
        {
            this._464942306inputDataValidator = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "inputDataValidator", oldValue, value));
        }
    }

	/**
	 * generated bindable wrapper for property inputText (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'inputText' moved to '_1706957847inputText'
	 */

    [Bindable(event="propertyChange")]
    public function get inputText():mx.controls.TextInput
    {
        return this._1706957847inputText;
    }

    public function set inputText(value:mx.controls.TextInput):void
    {
    	var oldValue:Object = this._1706957847inputText;
        if (oldValue !== value)
        {
            this._1706957847inputText = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "inputText", oldValue, value));
        }
    }

	/**
	 * generated bindable wrapper for property panel (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'panel' moved to '_106433028panel'
	 */

    [Bindable(event="propertyChange")]
    public function get panel():examples.yui.helloworld.ui.MyPanel
    {
        return this._106433028panel;
    }

    public function set panel(value:examples.yui.helloworld.ui.MyPanel):void
    {
    	var oldValue:Object = this._106433028panel;
        if (oldValue !== value)
        {
            this._106433028panel = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "panel", oldValue, value));
        }
    }

	/**
	 * generated bindable wrapper for property radiogroup1 (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'radiogroup1' moved to '_164873549radiogroup1'
	 */

    [Bindable(event="propertyChange")]
    public function get radiogroup1():mx.controls.RadioButtonGroup
    {
        return this._164873549radiogroup1;
    }

    public function set radiogroup1(value:mx.controls.RadioButtonGroup):void
    {
    	var oldValue:Object = this._164873549radiogroup1;
        if (oldValue !== value)
        {
            this._164873549radiogroup1 = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "radiogroup1", oldValue, value));
        }
    }

	/**
	 * generated bindable wrapper for property remove (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'remove' moved to '_934610812remove'
	 */

    [Bindable(event="propertyChange")]
    public function get remove():mx.controls.Button
    {
        return this._934610812remove;
    }

    public function set remove(value:mx.controls.Button):void
    {
    	var oldValue:Object = this._934610812remove;
        if (oldValue !== value)
        {
            this._934610812remove = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "remove", oldValue, value));
        }
    }

	/**
	 * generated bindable wrapper for property showHelloWorld (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'showHelloWorld' moved to '_39953597showHelloWorld'
	 */

    [Bindable(event="propertyChange")]
    public function get showHelloWorld():mx.controls.Button
    {
        return this._39953597showHelloWorld;
    }

    public function set showHelloWorld(value:mx.controls.Button):void
    {
    	var oldValue:Object = this._39953597showHelloWorld;
        if (oldValue !== value)
        {
            this._39953597showHelloWorld = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "showHelloWorld", oldValue, value));
        }
    }



}
