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
package jp.akb7.yui.util
{
    import flash.utils.Dictionary;

    public final class ArrayUtil {
        
        private static const _UID_:String = "uid";
        
        public static function toUidMap(value:Array):Dictionary{
            return toMap(value,_UID_);
        }
        
        public static function toMap(value:Array,key:String=null):Dictionary{
            var map:Dictionary = null;
            if( value != null ){
                if( key == null ){
                    map = toStringMap(value);
                } else {
                    map = toObjectMap(value,key);
                }
            }
            return map;
        }
        
        private static function toStringMap(value:Array):Dictionary{
            var map:Dictionary = new Dictionary();
            
            for each( var item:String in value ){
                map[ item ] = null;
            }
            
            return map;
        }
        
        private static function toObjectMap(value:Array,key:String):Dictionary{
            var map:Dictionary = new Dictionary();
            
            for each( var item:Object in value ){
                if( item.hasOwnProperty( key )){
                    map[ item[key] ] = item;
                }
            }
            
            return map;
        }
    }
}