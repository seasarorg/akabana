/*
 * Copyright 2004-2010 the Seasar Foundation and the Others.
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
CONFIG::FP10{
    import __AS3__.vec.Vector;
}
    public class FunctionRef extends AnnotatedObjectRef
    {

CONFIG::FP9{
        private var _parameters:Array;

        public function get parameters():Array{
            return _parameters;
        }
}
CONFIG::FP10{
        private var _parameters:Vector.<ParameterRef>;

        public function get parameters():Vector.<ParameterRef>{
            return _parameters;
        }
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
            var result:Function = null;
            if( _uri == null || _uri.length == 0 ){
                result = object[ _name ];
            } else {
                var ns:Namespace = new Namespace(_uri);
                result = object.ns::[ _name ];
            }
            return result;
        }

        public function toString():String{
            return name + "{ returnType=" + _returnType + ", declaredBy=" + _declaredBy + ", isReturnAnyType=" + _isReturnAnyType + "}(" + _parameters + ")";
        }

        private function assembleThis( rootDescribeTypeXml:XML ):void{
            var access:String = rootDescribeTypeXml.@access.toString();
            _returnType = getTypeString(rootDescribeTypeXml.@returnType.toString());
            _declaredBy = getTypeString(rootDescribeTypeXml.@declaredBy.toString());

            _isReturnAnyType = ( _returnType == TYPE_ANY );
        }

        private function assembleParameter( rootDescribeTypeXml:XML ):void{
CONFIG::FP9{
            _parameters = [];
}
CONFIG::FP10{
            _parameters = new Vector.<ParameterRef>();
}
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