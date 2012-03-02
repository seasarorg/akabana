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
package jp.akb7.yui.core.reflection
{
    [ExcludeClass]
    public final class PropertyRef extends AnnotatedObjectRef {
        
        private static const WRITE_ONLY:String = "writeonly";
        
        private static const READ_ONLY:String = "readonly";
        
        private static const READ_WRITE:String = "readwrite";

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
            return getClassRef(type);
        }

        private var _declaredBy:String;

        public function get declaredBy():String{
            return _declaredBy;
        }

        public function PropertyRef( describeTypeXml:XML ){
            super( describeTypeXml );
            assembleThis( describeTypeXml );
        }

        public function getValue( target:Object ):Object{
            var result:Object = null;
            if( _uri == null || _uri.length == 0 ){
                result = target[ _name ];
            } else {
                var ns:Namespace = new Namespace(_uri);
                result = target.ns::[ _name ];
            }
            return result;
        }

        public function setValue( target:Object, value:Object ):void{
            if( _uri == null || _uri.length == 0 ){
                target[ _name ] = value;
            } else {
                var ns:Namespace = new Namespace(_uri);
                target.ns::[ _name ] = value;
            }
        }

        private function assembleThis( rootDescribeTypeXml:XML ):void{
            var access:String = rootDescribeTypeXml.@access.toString();
            _isReadable = ( access == READ_ONLY || access == READ_WRITE );
            _isWriteable = ( access == WRITE_ONLY || access == READ_WRITE );
            _type = getTypeString(rootDescribeTypeXml.@type.toString());
            _declaredBy = getTypeString(rootDescribeTypeXml.@declaredBy.toString());
        }
    }
}