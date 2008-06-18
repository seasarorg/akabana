package org.seasar.akabana.yui.logging.category
{
    import org.seasar.akabana.yui.logging.Appender;
    import org.seasar.akabana.yui.logging.Category;
    import org.seasar.akabana.yui.logging.Level;
    
    public class CategoryBase implements Category
    {
        protected var _name:String;
        
        public function get name():String{
            return _name;
        }
        
        public function set name( value:String ):void{
            this._name = value;
        }        
        
        protected var _level:Level;
        
        public function get level():Level{
            return _level;
        }
        
        public function set level( value:Level ):void{
            _level = value;
        }
        
        protected var _appenders:Array;
        
        public function get appenderCount():int{
            return _appenders.length;
        }
        
        public function CategoryBase(){
            _appenders = [];
            _level = Level.ALL;
        }
        
        public function addAppender( appender:Appender ):void{
            if( appender != null ){
                _appenders.push( appender );
            }
        }

        public function removeAppender( appender:Appender ):void{
            var appenderIndex_:int = _appenders.indexOf(appender);
            _appenders.splice(appenderIndex_,1);
        }
    }
}