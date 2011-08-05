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
package org.seasar.akabana.yui.core.data
{
    import flash.net.getClassByAlias;
    import flash.utils.ByteArray;
    
    import mx.core.mx_internal;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.MetadataRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    
    [ExcludeClass]
    public final class Converter {
        
        private static var cloneBuffer:ByteArray = new ByteArray();
        
        private static var _instance:Converter;
                
        public static function getInstanceBy(toClass:Class):Converter{
            if( _instance == null ){
                _instance = new Converter();
            }
            
            return _instance;
        }
        
        public function convert(value:Object,toClass:Class):Object{
            var result:Object = null;
            if( value != null && toClass != null ){
                result = processObjectConvert(value,toClass);
            }
            
            return result;
        }
        
        protected function processObjectConvert(value:Object,toClass:Class):Object{
            var result:Object = new toClass();
            
            var toClassRef:ClassRef = ClassRef.getInstance(toClass);
            var objectCclassRef:ClassRef = ClassRef.getInstance(value);
            
            if( toClassRef.name == objectCclassRef.name ){
                return doClone(value);
            } else {
                if(!toClassRef.isInterface){
                    for each( var propertyRef:PropertyRef in toClassRef.properties ){
                        if( propertyRef.name in value ){
                            result[propertyRef.name] = processPropertyConvert(value[propertyRef.name],propertyRef.typeClassRef);
                        }
                    }
                }
            }
                
            return result;
        }
        
        protected function processPropertyConvert(value:Object,classRef:ClassRef):*{
            var result:Object;
            if( classRef.isPrimitive ){
                result = value;
            } else if( classRef.isTopLevel ){
                result = doClone(value);
            } else if( classRef.isArray ){
                result = doArrayConvert(value as Array);
            } else if( classRef.isVector ){
                result = doVectorConvert(value,classRef);
            } else {
                result = doConvertTypedObject(value,classRef);
            }
            return result;
        }
        
        protected function doClone(value:Object):*{
            if( value == null ){
                return null;
            }
            
            CONFIG::FP10 {
                cloneBuffer.clear();
            }
            CONFIG::FP9 {
                cloneBuffer = new ByteArray();
            }
            cloneBuffer.position = 0;
            
            cloneBuffer.writeObject(value);
            cloneBuffer.position = 0;
            
            var result:Object = cloneBuffer.readObject();
            
            return result;
        }
        
        protected function doArrayConvert(value:Array):*{
            return doClone(value);
        }
        
        protected function doVectorConvert(value:Object,classRef:ClassRef):*{
            if( value == null ){
                return null;
            }
            var propertyName:String = classRef.name;
            var result:Object = classRef.newInstance();
            var numLen:int = value.length;
            var className:String = propertyName.substring(ClassRef.VECTOR_CLASS.length,propertyName.length-1);
            for (var i:int = 0; i < numLen; i++)
            {
                result[i] = processPropertyConvert(value[i],getClassRef(className));
            }
            
            return result;
        }
        
        protected function doConvertTypedObject(value:Object,classRef:ClassRef):*{
            if( value == null ){
                return null;
            }
            var result:Object = processObjectConvert(value,classRef.concreteClass);
            
            return result;
        }
    }
}