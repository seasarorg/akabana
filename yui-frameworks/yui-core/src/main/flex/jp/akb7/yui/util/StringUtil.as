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
    import __AS3__.vec.Vector;

    public final class StringUtil {
        
        public static const EMPTY:String = "";
        
        public static const DOT:String = ".";

        public static function trim(str:String):String {
            if (str == null){
               return null;
            }

            var startIndex:int = 0;
            while( isWhitespace(str.charAt(startIndex))){
                ++startIndex;
            }

            var endIndex:int = str.length - 1;
            while( isWhitespace(str.charAt(endIndex))){
                --endIndex;
            }

            if( endIndex >= startIndex ){
                return str.slice(startIndex, endIndex + 1);
            } else {
                return EMPTY;
            }
        }
        
        public static function isEmpty(value:String):Boolean{
            return value == null || value.length == 0;
        }

        public static function isWhitespace(character:String):Boolean{
            var result:Boolean = true;
            switch( character ){
                case " ":
                case "\t":
                case "\r":
                case "\n":
                case "\f":
                    break;

                default:
                    result = false;
            }
            return result;
        }

        public static function substitute(str:String, ... rest):String{
            if( str == null ){
               return null;
            }

            var len:uint = rest.length;
            var args:Vector.<Object>;

            if( len == 1 && rest[0] is Array ){
                args = Vector.<Object>(rest[0]);
                len = args.length;
            } else {
                args = Vector.<Object>(rest);
            }

            for( var i:int = 0; i < len; i++ ){
                str = str.replace(new RegExp("\\{"+i+"\\}", "g"), args[i]);
            }

            return str;
        }

        public static function fill(value:Object, len:int, padding:String):String{
            var result:String = "";

            var valueLen:int = value.toString().length;
            if( valueLen < len){
                var paddingLen:int = len - valueLen;
                for( var i:int = 0; i < paddingLen; i++){
                    result += padding;
                }
            }

            result += value.toString();

            return result;
        }

        public static function toLowerCamel(value:String):String{
            return value.substr(0,1).toLocaleLowerCase() + value.substring(1,value.length);
        }

        public static function toUpperCamel(value:String):String{
            return value.substr(0,1).toLocaleUpperCase() + value.substring(1,value.length);
        }
    }
}
