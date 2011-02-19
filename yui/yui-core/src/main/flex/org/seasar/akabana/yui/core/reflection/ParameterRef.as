/*
 * Copyright 2004-2011 the Seasar Foundation and the Others.
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

        private var _isEvent:Boolean;

        public function get isEvent():Boolean{
            return getClassRef(_type).isEvent;
        }

        public function get isEventDispatcher():Boolean{
            return getClassRef(_type).isEventDispatcher;
        }

        public function get isDisplayObject():Boolean{
            return getClassRef(_type).isDisplayObject;
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