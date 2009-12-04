






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
public class _examples_yui_helloworld_view_HelloWorldViewWatcherSetupUtil extends Sprite
    implements mx.binding.IWatcherSetupUtil
{
    public function _examples_yui_helloworld_view_HelloWorldViewWatcherSetupUtil()
    {
        super();
    }

    public static function init(fbs:IFlexModuleFactory):void
    {
        import examples.yui.helloworld.view.HelloWorldView;
        (examples.yui.helloworld.view.HelloWorldView).watcherSetupUtil = new _examples_yui_helloworld_view_HelloWorldViewWatcherSetupUtil();
    }

    public function setup(target:Object,
                          propertyGetter:Function,
                          bindings:Array,
                          watchers:Array):void
    {
        import mx.core.UIComponentDescriptor;
        import mx.controls.RadioButtonGroup;
        import mx.core.DeferredInstanceFromClass;
        import mx.utils.ObjectProxy;
        import __AS3__.vec.Vector;
        import mx.validators.Validator;
        import mx.binding.IBindingClient;
        import examples.yui.helloworld.ui.MyPanel;
        import mx.states.Transition;
        import mx.containers.ControlBar;
        import mx.core.ClassFactory;
        import mx.core.IFactory;
        import mx.effects.Fade;
        import mx.containers.VBox;
        import mx.controls.Button;
        import mx.core.DeferredInstanceFromFunction;
        import mx.utils.UIDUtil;
        import flash.events.EventDispatcher;
        import mx.states.State;
        import mx.binding.BindingManager;
        import mx.core.IDeferredInstance;
        import mx.controls.RadioButton;
        import mx.core.IPropertyChangeNotifier;
        import flash.events.IEventDispatcher;
        import mx.events.PropertyChangeEvent;
        import mx.states.SetProperty;
        import mx.core.mx_internal;
        import mx.events.FlexEvent;
        import mx.controls.TextInput;
        import flash.events.Event;

        // writeWatcher id=0 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[0] = new mx.binding.PropertyWatcher("showHelloWorld",
            {
                propertyChange: true
            }
,         // writeWatcherListeners id=0 size=2
        [
        bindings[0],
        bindings[1]
        ]
,
                                                                 propertyGetter
);

        // writeWatcher id=1 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[1] = new mx.binding.PropertyWatcher("inputData",
            {
                propertyChange: true
            }
,         // writeWatcherListeners id=1 size=1
        [
        bindings[2]
        ]
,
                                                                 propertyGetter
);


        // writeWatcherBottom id=0 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[0].updateParent(target);

 





        // writeWatcherBottom id=1 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[1].updateParent(target);

 





    }
}

}
