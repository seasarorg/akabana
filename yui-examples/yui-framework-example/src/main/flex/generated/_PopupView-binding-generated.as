

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.core.IPropertyChangeNotifier;
import mx.events.PropertyChangeEvent;
import mx.utils.ObjectProxy;
import mx.utils.UIDUtil;

import mx.controls.Button;

class BindableProperty
{
	/**
	 * generated bindable wrapper for property say (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'say' moved to '_113643say'
	 */

    [Bindable(event="propertyChange")]
    public function get say():mx.controls.Button
    {
        return this._113643say;
    }

    public function set say(value:mx.controls.Button):void
    {
    	var oldValue:Object = this._113643say;
        if (oldValue !== value)
        {
            this._113643say = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "say", oldValue, value));
        }
    }



}
