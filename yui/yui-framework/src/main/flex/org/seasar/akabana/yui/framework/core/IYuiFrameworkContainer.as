package org.seasar.akabana.yui.framework.core
{
    import mx.core.Container;
    import mx.managers.ISystemManager;
    
    public interface IYuiFrameworkContainer
    {
        function addExternalSystemManager(systemManager:ISystemManager):void;
        
        function customizeComponent( container:Container, owner:Container=null):void;
        
        function uncustomizeComponent( container:Container, owner:Container=null):void;
    }
}