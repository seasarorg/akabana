

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.core.IPropertyChangeNotifier;
import mx.events.PropertyChangeEvent;
import mx.utils.ObjectProxy;
import mx.utils.UIDUtil;

import mx.validators.StringValidator;

class BindableProperty
{
	/**
	 * generated bindable wrapper for property inputText (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'inputText' moved to '_1706957847inputText'
	 */

    [Bindable(event="propertyChange")]
    public function get inputText():mx.validators.StringValidator
    {
        return this._1706957847inputText;
    }

    public function set inputText(value:mx.validators.StringValidator):void
    {
    	var oldValue:Object = this._1706957847inputText;
        if (oldValue !== value)
        {
            this._1706957847inputText = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "inputText", oldValue, value));
        }
    }



}
