

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.core.IPropertyChangeNotifier;
import mx.events.PropertyChangeEvent;
import mx.utils.ObjectProxy;
import mx.utils.UIDUtil;

import examples.yui.popup.view.PopupOwnerView;

class BindableProperty
{
	/**
	 * generated bindable wrapper for property rootView (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'rootView' moved to '_166793561rootView'
	 */

    [Bindable(event="propertyChange")]
    public function get rootView():examples.yui.popup.view.PopupOwnerView
    {
        return this._166793561rootView;
    }

    public function set rootView(value:examples.yui.popup.view.PopupOwnerView):void
    {
    	var oldValue:Object = this._166793561rootView;
        if (oldValue !== value)
        {
            this._166793561rootView = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "rootView", oldValue, value));
        }
    }



}