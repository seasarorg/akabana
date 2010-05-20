






package
{
import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.binding.ArrayElementWatcher;
import mx.binding.FunctionReturnWatcher;
import mx.binding.IWatcherSetupUtil;
import mx.binding.PropertyWatcher;
import mx.binding.RepeaterComponentWatcher;
import mx.binding.RepeaterItemWatcher;
import mx.binding.StaticPropertyWatcher;
import mx.binding.XMLWatcher;
import mx.binding.Watcher;

[ExcludeClass]
[Mixin]
public class _examples_yui_popup_view_PopupOwnerViewWatcherSetupUtil extends Sprite
    implements mx.binding.IWatcherSetupUtil
{
    public function _examples_yui_popup_view_PopupOwnerViewWatcherSetupUtil()
    {
        super();
    }

    public static function init(fbs:IFlexModuleFactory):void
    {
        import examples.yui.popup.view.PopupOwnerView;
        (examples.yui.popup.view.PopupOwnerView).watcherSetupUtil = new _examples_yui_popup_view_PopupOwnerViewWatcherSetupUtil();
    }

    public function setup(target:Object,
                          propertyGetter:Function,
                          bindings:Array,
                          watchers:Array):void
    {
        import mx.core.DeferredInstanceFromFunction;
        import flash.events.EventDispatcher;
        import mx.controls.Button;
        import mx.utils.UIDUtil;
        import mx.binding.IBindingClient;
        import mx.core.IDeferredInstance;
        import mx.core.ClassFactory;
        import mx.core.UIComponentDescriptor;
        import mx.core.mx_internal;
        import __AS3__.vec.Vector;
        import mx.events.PropertyChangeEvent;
        import mx.effects.Fade;
        import mx.core.IPropertyChangeNotifier;
        import flash.events.Event;
        import mx.core.IFactory;
        import mx.core.DeferredInstanceFromClass;
        import mx.utils.ObjectProxy;
        import mx.binding.BindingManager;
        import mx.containers.Canvas;
        import flash.events.IEventDispatcher;

        // writeWatcher id=0 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[0] = new mx.binding.PropertyWatcher("fadeIn",
            {
                propertyChange: true
            }
,         // writeWatcherListeners id=0 size=1
        [
        bindings[0]
        ]
,
                                                                 propertyGetter
);


        // writeWatcherBottom id=0 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[0].updateParent(target);

 





    }
}

}
