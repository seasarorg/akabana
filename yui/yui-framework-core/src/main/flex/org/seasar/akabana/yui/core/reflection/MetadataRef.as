package org.seasar.akabana.yui.core.reflection
{
    
    public class MetadataRef extends ObjectRef
    {

        private var _args:Array;

        public function get args():Array{
            return _args;
        }
        
        private var _argMap:Object;
        
        public function MetadataRef( describeTypeXml:XML )
        {
            super( describeTypeXml );
            assembleArgs( describeTypeXml );
        }
        
        public function hasArgs():Boolean{
            return _args.length() > 0;
        }
        
        public function getArgValue( key:String ):Object{
            return _argMap[ key ];
        }
        
        public function toString():String{
            var toString_:String = "[" + name + "]{";
            
            for( var key:String in _argMap ){
                toString_ += key + ":" + _argMap[ key ] + ",";
            }
            
            toString_ += "}";
                
            return toString_;
        }
        
        private function assembleArgs( rootDescribeTypeXml:XML ):void{
            _args = [];
            _argMap = {};
               
            var argsXMLList:XMLList = rootDescribeTypeXml.arg;
            for each( var argXML:XML in argsXMLList ){
                var name:String = argXML.@key.toString();
                var value:Object = argXML.@value.toString();
                
                _args.push( name );
                _argMap[ name ] = value;
            }
        }
    }
}