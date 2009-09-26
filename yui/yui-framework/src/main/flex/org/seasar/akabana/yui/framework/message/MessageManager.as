package org.seasar.akabana.yui.framework.message
{
    import mx.resources.ResourceManager;
    
    import org.seasar.akabana.yui.util.StringUtil;
    
    
    [ResourceBundle("messages")]    
    [ResourceBundle("application")]
    [ResourceBundle("yui_framework")]    
    public class MessageManager {
        public static var messages:Messages = new Messages("messages");
        public static var application:Messages = new Messages("application");
        public static var yuiframework:Messages = new Messages("yui_framework");
    }
}