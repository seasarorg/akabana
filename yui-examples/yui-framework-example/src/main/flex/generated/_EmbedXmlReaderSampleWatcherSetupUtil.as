






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
public class _EmbedXmlReaderSampleWatcherSetupUtil extends Sprite
    implements mx.binding.IWatcherSetupUtil
{
    public function _EmbedXmlReaderSampleWatcherSetupUtil()
    {
        super();
    }

    public static function init(fbs:IFlexModuleFactory):void
    {
        import EmbedXmlReaderSample;
        (EmbedXmlReaderSample).watcherSetupUtil = new _EmbedXmlReaderSampleWatcherSetupUtil();
    }

    public function setup(target:Object,
                          propertyGetter:Function,
                          bindings:Array,
                          watchers:Array):void
    {
        import mx.core.UIComponentDescriptor;
        import mx.containers.Panel;
        import mx.core.DeferredInstanceFromClass;
        import mx.utils.ObjectProxy;
        import __AS3__.vec.Vector;
        import mx.binding.IBindingClient;
        import mx.controls.TextArea;
        import mx.controls.Tree;
        import org.seasar.akabana.yui.resources.embed.EmbedXmlReader;
        import mx.containers.HDividedBox;
        import mx.core.ClassFactory;
        import mx.core.IFactory;
        import mx.core.DeferredInstanceFromFunction;
        import mx.utils.UIDUtil;
        import flash.events.EventDispatcher;
        import mx.core.Application;
        import mx.binding.BindingManager;
        import mx.core.IDeferredInstance;
        import mx.core.IPropertyChangeNotifier;
        import flash.events.IEventDispatcher;
        import mx.events.PropertyChangeEvent;
        import mx.events.FlexEvent;
        import mx.core.mx_internal;
        import mx.events.ListEvent;
        import flash.events.Event;

        // writeWatcher id=1 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[1] = new mx.binding.PropertyWatcher("selectedNode",
            {
                propertyChange: true
            }
,         // writeWatcherListeners id=1 size=1
        [
        bindings[1]
        ]
,
                                                                 propertyGetter
);

        // writeWatcher id=2 shouldWriteSelf=true class=flex2.compiler.as3.binding.XMLWatcher shouldWriteChildren=true
        watchers[2] = new mx.binding.XMLWatcher("label",
        // writeWatcherListeners id=2 size=1
        [
        bindings[1]
        ]
        );

        // writeWatcher id=0 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[0] = new mx.binding.PropertyWatcher("treeData",
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


        // writeWatcherBottom id=1 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[1].updateParent(target);

 





        // writeWatcherBottom id=2 shouldWriteSelf=true class=flex2.compiler.as3.binding.XMLWatcher
        watchers[1].addChild(watchers[2]);

 





        // writeWatcherBottom id=0 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[0].updateParent(target);

 





    }
}

}
