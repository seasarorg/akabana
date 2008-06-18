package org.seasar.akabana.yui.core
{
    import flash.net.getClassByAlias;
    import flash.utils.getDefinitionByName;
    
    public class ClassLoader
    {
        public function findClass( name:String ):Class {
            var clazz:Class = getDefinitionByName( name ) as Class;
            if ( clazz == null ){
                clazz = getClassByAlias( name );   
            }
            return clazz;
        }
    }
}