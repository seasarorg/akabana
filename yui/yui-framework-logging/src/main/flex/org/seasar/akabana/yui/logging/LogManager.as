package org.seasar.akabana.yui.logging
{
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;
    
    import org.seasar.akabana.yui.logging.appender.SimpleAppender;
    import org.seasar.akabana.yui.logging.layout.PatternLayout;
    
    public class LogManager
    {
        private static const CACHE:Object= {};
        
        public static function getLogger( targetClass:Class ):Logger{
            var fullClassName:String = describeType( targetClass ).@name.toString();
            var logger_:Logger = CACHE[ fullClassName ];
            
            if( logger_ == null ){
                
                var layout_:PatternLayout = new PatternLayout();
                layout_.pattern ="%d [%c] %l - %m%t";
                
                var appender_:Appender = new SimpleAppender();
                appender_.layout = layout_;
                
                logger_ = new Logger();
                logger_.name = getQualifiedClassName(targetClass);
                logger_.addAppender( appender_ );
            }
                        
            return logger_;
        }
    }
}