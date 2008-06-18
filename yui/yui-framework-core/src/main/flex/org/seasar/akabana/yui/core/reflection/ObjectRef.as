package org.seasar.akabana.yui.core.reflection
{
    internal class ObjectRef implements Reflector
    {
        private var _describeTypeXml:XML;
        
        public function get describeType():XML{
            return _describeTypeXml;
        }        
        
        protected var _name:String;

        public function get name():String{
            return _name;
        }
        
        public function ObjectRef( describeTypeXml:XML ){
            _describeTypeXml = describeTypeXml;
            
            _name = getName( describeTypeXml );
        }
        
        protected function getName( rootDescribeTypeXml:XML ):String{
            return rootDescribeTypeXml.@name.toString();            
        }
        
        protected static function getTypeString( type:String ):String{
            if( type != "*"){
                return type.replace("::",".");    
            } else {
                return type;
            }
        }
    }
}