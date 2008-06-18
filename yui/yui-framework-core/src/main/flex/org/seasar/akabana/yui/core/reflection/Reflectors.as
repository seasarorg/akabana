package org.seasar.akabana.yui.core.reflection
{
    
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;
    
    import org.seasar.akabana.yui.core.ClassLoader;
    
    public class Reflectors
    {
        public static var classLoader:ClassLoader = new ClassLoader();
        
        private static const cache_:Object = {};        
        
        public static function getClassReflector( target:Object ):ClassRef{

            var clazz:Class = null;
            try {
                switch( true ){
                    case ( target is Class ):{
                        clazz = target as Class;
                        break;
                    }
                    
                    case ( target is String ):{
                        clazz = classLoader.findClass(target as String);
                        break;
                    }
                    
                    default:{
                        clazz = classLoader.findClass(getQualifiedClassName(target));
                        break;
                    }
                }
            } catch( e:Error ){                
            }
            
            if( clazz != null ){
                var classRef:ClassRef = cache_[ clazz ];
                if( classRef == null ){
                    classRef = new ClassRef(clazz);                    
                    cache_[ clazz ] = classRef;
                } else {
                    trace("use cache!!!" + classRef.name);
                }                
            } else {
                //throw new Error("Class Not Found!!!");
            }
            
            return classRef;
        }
    }
}