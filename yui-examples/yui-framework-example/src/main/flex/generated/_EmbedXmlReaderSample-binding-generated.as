

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.core.IPropertyChangeNotifier;
import mx.events.PropertyChangeEvent;
import mx.utils.ObjectProxy;
import mx.utils.UIDUtil;

import XML;
import mx.controls.Tree;

class BindableProperty
{
	/**
	 * generated bindable wrapper for property myTree (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'myTree' moved to '_1060028566myTree'
	 */

    [Bindable(event="propertyChange")]
    public function get myTree():mx.controls.Tree
    {
        return this._1060028566myTree;
    }

    public function set myTree(value:mx.controls.Tree):void
    {
    	var oldValue:Object = this._1060028566myTree;
        if (oldValue !== value)
        {
            this._1060028566myTree = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "myTree", oldValue, value));
        }
    }

	/**
	 * generated bindable wrapper for property selectedNode (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'selectedNode' moved to '_1754640579selectedNode'
	 */

    [Bindable(event="propertyChange")]
    public function get selectedNode():XML
    {
        return this._1754640579selectedNode;
    }

    public function set selectedNode(value:XML):void
    {
    	var oldValue:Object = this._1754640579selectedNode;
        if (oldValue !== value)
        {
            this._1754640579selectedNode = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "selectedNode", oldValue, value));
        }
    }

	/**
	 * generated bindable wrapper for property treeData (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'treeData' moved to '_1385683048treeData'
	 */

    [Bindable(event="propertyChange")]
    public function get treeData():XML
    {
        return this._1385683048treeData;
    }

    public function set treeData(value:XML):void
    {
    	var oldValue:Object = this._1385683048treeData;
        if (oldValue !== value)
        {
            this._1385683048treeData = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "treeData", oldValue, value));
        }
    }



}
