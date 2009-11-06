package org.seasar.akabana.yui.air.core
{
    import flash.events.Event;
    
    import mx.core.Container;
    import mx.core.Window;
    import mx.managers.ISystemManager;
    
    import org.seasar.akabana.yui.framework.core.YuiFrameworkContainer;

    public class Window extends mx.core.Window
    {
        public override function set systemManager(value:ISystemManager):void
        {
            if( super.systemManager != value ){
                super.systemManager = value;
                YuiFrameworkContainer.yuicontainer.addExternalSystemManager(value);
            }
        }
    }
}