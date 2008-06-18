package org.seasar.akabana.yui.logging
{
    import org.seasar.akabana.yui.logging.appender.SimpleAppender;
    import org.seasar.akabana.yui.logging.category.SimpleCategory;
    import org.seasar.akabana.yui.logging.layout.PatternLayout;
    
    public class Logger extends SimpleCategory
    {
        public static function getLogger( targetClass:Class ):Logger{
            var logger_:Logger = LogManager.getLogger(targetClass);

            return logger_;
        }
        
    }
}