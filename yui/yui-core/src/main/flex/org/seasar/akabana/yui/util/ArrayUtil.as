package org.seasar.akabana.yui.util
{
    public class ArrayUtil
    {
        public static function toUidMap(value:Array,key:String=null):Object{
            return toMap(value,"uid");
        }
        
        public static function toMap(value:Array,key:String=null):Object{
            var map:Object = null;
            if( value != null ){
                if( key == null ){
                    map = toStringMap(value);
                } else {
                    map = toObjectMap(value,key);
                }
            }
            return map;
        }
        
        private static function toStringMap(value:Array):Object{
            var map:Object = {};
            
            for each( var item:String in value ){
                map[ item ] = null;
            }
            
            return map;
        }
        
        private static function toObjectMap(value:Array,key:String):Object{
            var map:Object = {};
            
            for each( var item:Object in value ){
                if( item.hasOwnProperty( key )){
                    map[ item[key] ] = item;
                }
            }
            
            return map;
        }
    }
}