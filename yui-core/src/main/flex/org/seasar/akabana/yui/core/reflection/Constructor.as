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
    public final class Constructor extends ObjectRef
    {
        private var _concreteClass:Class;

        public function get concreteClass():Class{
            return _concreteClass;
        }

        private var _parameters:Array;

        public function get parameters():Array{
            return _parameters;
        }
        
        private var _parameterMap:Object;

        public function get parameterMap():Object{
            return _parameterMap;
        }
                
        public function Constructor( describeTypeXml:XML, concreteClass:Class ){
            super( describeTypeXml );
            _concreteClass = concreteClass;
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