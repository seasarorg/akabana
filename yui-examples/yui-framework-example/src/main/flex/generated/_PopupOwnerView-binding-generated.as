

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.core.IPropertyChangeNotifier;
import mx.events.PropertyChangeEvent;
import mx.utils.ObjectProxy;
import mx.utils.UIDUtil;

import mx.controls.Button;
import mx.effects.Fade;

class BindableProperty
{
	/**
	 * generated bindable wrapper for property fadeIn (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'fadeIn' moved to '_1282133823fadeIn'
	 */

    [Bindable(event="propertyChange")]
    public function get fadeIn():mx.effects.Fade
    {
        return this._1282133823fadeIn;
    }

    public function set fadeIn(value:mx.effects.Fade):void
    {
    	var oldValue:Object = this._1282133823fadeIn;
        if (oldValue !== value)
        {
            this._1282133823fadeIn = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "fadeIn", oldValue, value));
        }
    }

	/**
	 * generated bindable wrapper for property show (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'show' moved to '_3529469show'
	 */

    [Bindable(event="propertyChange")]
    public function get show():mx.controls.Button
    {
        return this._3529469show;
    }

    public function set show(value:mx.controls.Button):void
    {
    	var oldValue:Object = this._3529469show;
        if (oldValue !== value)
        {
            this._3529469show = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "show", oldValue, value));
        }
    }



}
