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
    public class PropertyRef extends AnnotatedObjectRef
    {
        
        private var _isReadable:Boolean;

        public function get isReadable():Boolean{
            return _isReadable;
        }
        
        private var _isWriteable:Boolean;

        public function get isWriteable():Boolean{
            return _isWriteable;
        }
        
        private var _type:String;

        public function get type():String{
            return _type;
        }
        
        public function get typeClassRef():ClassRef{
            return ClassRef.getReflector(type);
        }
        
        private var _declaredBy:String;

        public function get declaredBy():String{
            return _declaredBy;
        }
        
        public function PropertyRef( describeTypeXml:XML )
        {
            super( describeTypeXml );
            assembleMetadataRef( describeTypeXml );
            assembleThis( describeTypeXml );
        }
        
        public function toString():String{
            return name + "{type=" + _type + ", declaredBy=" + _declaredBy + ", isReadable=" + _isReadable + ", isWriteable=" + _isWriteable + "}";
        }
        
        private function assembleThis( rootDescribeTypeXml:XML ):void{
            var access:String = rootDescribeTypeXml.@access.toString();
            _isReadable = ( access == "readonly" || access == "readwrite" );
            _isWriteable = ( access == "writeonly" || access == "readwrite" );
            _type = getTypeString(rootDescribeTypeXml.@type.toString());
            _declaredBy = getTypeString(rootDescribeTypeXml.@declaredBy.toString());
        }
    }
}