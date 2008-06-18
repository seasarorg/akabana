package org.seasar.akabana.yui.logging
{
    public class LoggingEvent
    {
        public static const startTime:Number = new Date().time;
        
        public var categoryName:String;
        
        public var level:Level;
        
        public var message:String;
        
        public var timeStamp:Number;
        
        public var error:Error;
        
        public function LoggingEvent( message:String, level:Level=null, logger:Category=null, error:Error=null){
            this.timeStamp = new Date().time;
            this.categoryName = logger.name;
            this.message = message;
            this.level = level;
            this.error = error;
        }
    }
}