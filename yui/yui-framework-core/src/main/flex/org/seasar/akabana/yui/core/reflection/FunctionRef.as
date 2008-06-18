/*
 * Copyright 2004-2007 the Seasar Foundation and the Others.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 * either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */
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