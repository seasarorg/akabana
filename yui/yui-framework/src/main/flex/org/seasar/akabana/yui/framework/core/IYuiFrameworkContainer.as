package org.seasar.akabana.yui.framework.core
{
    import mx.core.UIComponent;
    import mx.managers.ISystemManager;
    
    public interface IYuiFrameworkContainer
    {
        function addExternalSystemManager(systemManager:ISystemManager):void;
        
        function customizeComponent( container:UIComponent, owner:UIComponent=null):void;
        
        function uncustomizeComponent( container:UIComponent, owner:UIComponent=null):void;
    }
}