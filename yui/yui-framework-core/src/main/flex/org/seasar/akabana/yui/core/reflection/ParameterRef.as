package org.seasar.akabana.yui.core.reflection
{
    
    public class ParameterRef extends ObjectRef
    {
        
        private var _index:int;

        public function get index():int{
            return _index;
        }
        
        private var _type:String;

        public function get type():String{
            return _type;
        }

        private var _optional:Boolean;

        public function get optional():Boolean{
            return _optional;
        }
        
        private var _isAnyType:Boolean;
        
        public function get isAnyType():Boolean{
            return _isAnyType;
        }
        
        public function ParameterRef( describeTypeXml:XML )
        {
            super( describeTypeXml );
            assembleThis( describeTypeXml );
        }
        
        public function toString():String{
            return "[" + _index + "]{type=" + _type + ", optional=" + _optional + ", isAnyType=" + _isAnyType + "}";
        }
        
        private function assembleThis( rootDescribeTypeXml:XML ):void{
            _index = parseInt( rootDescribeTypeXml.@index.toString());
            _type = getTypeString(rootDescribeTypeXml.@type.toString());
            _optional = ( rootDescribeTypeXml.@type.toString() == "true");
            
            _isAnyType = ( _type == "*" );
        }

        protected override function getName( rootDescribeTypeXml:XML ):String{
            return rootDescribeTypeXml.@index.toString();            
        } 
    }
}