package org.seasar.akabana.yui.framework.message
{
    import mx.resources.ResourceManager;
    import org.seasar.akabana.yui.core.yui_internal;
    
    import org.seasar.akabana.yui.util.StringUtil;
    
    
    [ResourceBundle("messages")]    
    [ResourceBundle("application")] 
    [ResourceBundle("errors")]
    [ResourceBundle("yui_framework")]    
    public class MessageManager {
        public static var messages:Messages = new Messages("messages");
        public static var application:Messages = new Messages("application");
        public static var errors:Messages = new Messages("errors");
        yui_internal static var yuiframework:Messages = new Messages("yui_framework");
    }
}