package org.seasar.akabana.yui.core.reflection
{    
    public class Constructor extends ObjectRef
    {
        public var concreteClass:Class;

        private var _parameters:Array;

        public function get parameters():Array{
            return _parameters;
        }
        
        private var _parameterMap:Object;
        
        public function Constructor( describeTypeXml:XML ){
            super( describeTypeXml );
            
            if( describeTypeXml.constructor.length > 0 ){
                assembleParameter( describeTypeXml.constructor[0] );
            }
        }
        
        public function toString():String{
            var toString_:String = "[" + name + "](";
            
            for( var key:String in _parameterMap ){
                toString_ += _parameterMap[ key ];
            }
            
            toString_ += ")";
                
            return toString_;
        }
        
        private function assembleParameter( rootDescribeTypeXml:XML ):void{
            _parameters = [];
            _parameterMap = {};
            
            var parameterRef:ParameterRef = null;
            var parametersXMLList:XMLList = rootDescribeTypeXml.parameter;
            for each( var parameterXML:XML in parametersXMLList ){
                parameterRef = new ParameterRef(parameterXML);
                
                _parameters.push( parameterRef );
                _parameterMap[ parameterRef.name ] = parameterRef;
            }
        }

        protected override function getName( rootDescribeTypeXml:XML ):String{
            return getTypeString(rootDescribeTypeXml.@type.toString()); 
        }
        
    }
}