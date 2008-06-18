package org.seasar.akabana.yui.core.reflection
{
    
    public class FunctionRef extends AnnotatedObjectRef
    {
        
        private var _parameters:Array;

        public function get parameters():Array{
            return _parameters;
        }
        
        private var _parameterMap:Object;
        
        private var _returnType:String;

        public function get returnType():String{
            return _returnType;
        }
        
        private var _isReturnAnyType:Boolean;
        
        public function get isReturnAnyType():Boolean{
            return _isReturnAnyType;
        }
        
        private var _declaredBy:String;

        public function get declaredBy():String{
            return _declaredBy;
        }
        
        public function FunctionRef( describeTypeXml:XML )
        {
            super( describeTypeXml );
            assembleMetadataRef( describeTypeXml );
            assembleParameter( describeTypeXml );
            assembleThis( describeTypeXml );
        }
        
        public function getFunction( object:Object ):Function{
            return object[ _name ];
        }
        
        public function toString():String{
            return name + "{ returnType=" + _returnType + ", declaredBy=" + _declaredBy + ", isReturnAnyType=" + _isReturnAnyType + "}(" + _parameters + ")";
        }
        
        private function assembleThis( rootDescribeTypeXml:XML ):void{
            var access:String = rootDescribeTypeXml.@access.toString();
            _returnType = getTypeString(rootDescribeTypeXml.@returnType.toString());
            _declaredBy = getTypeString(rootDescribeTypeXml.@declaredBy.toString());
            
            _isReturnAnyType = ( _returnType == "*" );
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
    }
}