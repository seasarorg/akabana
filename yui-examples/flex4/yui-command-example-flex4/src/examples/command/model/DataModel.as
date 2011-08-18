package examples.command.model
{
    public class DataModel
    {
        public var value:int;
        
        public var type:String;
        
        public function toString():String 
        {
            return "{value:"+value+",type:"+type+"}";
        }
        
    }
}