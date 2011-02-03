package org.seasar.akabana.yui.core.data
{
    import flash.net.getClassByAlias;
    import flash.utils.ByteArray;
    
    import mx.core.mx_internal;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.MetadataRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;

    public class Converter
    {   
        private static const cloneBuffer:ByteArray = new ByteArray();
        
        private static var _instance:Converter;
                
        public static function getInstanceBy(toClass:Class):Converter
        {
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
                        result[propertyRef.name] = processPropertyConvert(value[propertyRef.name],propertyRef.typeClassRef);
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
        
        protected function doClone(value:Object):*
        {
            if( value == null ){
                return null;
            }
            cloneBuffer.clear();
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
            var vectorClass:ClassRef = getClassRef(propertyName);
            var result:Object = vectorClass.newInstance();
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