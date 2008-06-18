/*
 * Copyright 2004-2008 the Seasar Foundation and the Others.
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