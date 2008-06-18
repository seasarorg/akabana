package org.seasar.akabana.yui.logging.category
{
    import org.seasar.akabana.yui.logging.Appender;
    import org.seasar.akabana.yui.logging.Level;
    import org.seasar.akabana.yui.logging.LoggingEvent;
    
    public class SimpleCategory extends CategoryBase
    {
        
        public function fatal( message:String, erorr:Error = null ):void{
            if( Level.FATAL.isGreaterOrEqual( _level )){
                doLog( Level.FATAL, message, erorr);
            }
        }
        
        public function error( message:String, erorr:Error = null ):void{
            if( Level.ERROR.isGreaterOrEqual( _level )){
                doLog( Level.ERROR, message, erorr);
            }
        }
        
        public function warn( message:String, erorr:Error = null ):void{
            if( Level.WARN.isGreaterOrEqual( _level )){
                doLog( Level.WARN, message, erorr);
            }
        }
        
        public function info( message:String, erorr:Error = null ):void{
            if( Level.INFO.isGreaterOrEqual( _level )){
                doLog( Level.INFO, message, erorr);
            }
        }
                                
        public function debug( message:String, erorr:Error = null ):void{
            if( Level.DEBUG.isGreaterOrEqual( _level )){
                doLog( Level.DEBUG, message, erorr);
            }
        }       
                 
        public function trace( message:String, erorr:Error = null ):void{
            if( Level.TRACE.isGreaterOrEqual( _level )){
                doLog( _level, message, erorr);
            }
        }
        
        protected function doLog( level:Level, message:String, erorr:Error=null):void{
            callAppenders(new LoggingEvent( message, _level, this, erorr));
        }
        
        protected function callAppenders( event:LoggingEvent ):void{
            for each( var appender_:Appender in _appenders ){
                appender_.append(event);
            }
        }
    }
}