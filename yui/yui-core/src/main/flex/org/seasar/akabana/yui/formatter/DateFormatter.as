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
package org.seasar.akabana.yui.formatter
{
    import org.seasar.akabana.yui.formatter.error.FormatError;
    import org.seasar.akabana.yui.formatter.naming.DateFormatNaming;
    import org.seasar.akabana.yui.util.StringUtil;
    
    public class DateFormatter extends StringFormatter {

        public static var dateFormatNaming:DateFormatNaming = new DateFormatNaming();
        
        private static const FILL_ZERO:String = "0";
        
        private static const FORMAT_PATTERN_CHARS:String = "Y,M,D,A,E,H,J,K,L,N,S";
        
        private static function checkFormatString(formatString:String):void{
            var formatedString:String = null;    
            var letter:String;
            var numTokens:int = 0;
            var tokens:String = "";
            
            var formatStringLen:int = formatString.length;
            for( var i:int = 0; i < formatStringLen; i++ ){
                letter = formatString.charAt(i);
                if( letter == ","){
                    continue;
                }
                if( FORMAT_PATTERN_CHARS.indexOf(letter) != -1 ){
                    numTokens++;
                    if( tokens.indexOf(letter) == -1 ){
                        tokens += letter;
                    } else {
                        if( letter != formatString.charAt(Math.max(i - 1, 0)) ){
                            throw new FormatError(formatString+" is invalid.");
                        }
                    }
                }
            }
        }
        
        private var _formatString:String;

        public function get formatString():String{
            return _formatString;
        }
    
        public function set formatString(value:String):void{
            if( value != null ){
                checkFormatString(value);
    
                _formatString = value;
                compileFormatPattern(_formatString, FORMAT_PATTERN_CHARS);                
            }
        }
                
        public function DateFormatter(formatString:String=null){
            this.formatString = formatString;
        }

        public override function format(value:Object):String{
            if( !(value is Date) ){
                return "";
            }
            
            var formatedString:String;
            if( _formatString != null && _formatString.length > 0 ){
                formatedString = formatValue(value);
            } else {
                formatedString = value.toString(); 
            }
            
            return formatedString;
        }

        protected override function extractToken(value:Object,tokenInfo:TokenInfo):String{

            var date:Date = value as Date;
            var result:String = "";            
            var tokenLen:int = tokenInfo.end - tokenInfo.begin;
            var day:int;
            var hours:int;
            
            switch (tokenInfo.token){

                case "Y":
                {
                    var year:String = date.getFullYear().toString();
                    if (tokenLen < 3){
                        return year.substr(2);
                    } else if (tokenLen > 4){
                        return StringUtil.fill(Number(year), tokenLen, FILL_ZERO);
                    } else {
                        return year;
                    }
                }
    
                case "M":
                {
                    var month:int = int(date.getMonth());
                    if (tokenLen < 3){
                        month++;
                        result += StringUtil.fill(month, tokenLen, FILL_ZERO);
                        return result;
                    } else if (tokenLen == 3){
                        return dateFormatNaming.getMonthShort(month);
                    } else {
                        return dateFormatNaming.getMonthLong(month);
                    }
                }
    
                case "D":
                {
                    day = int(date.getDate());
                    result += StringUtil.fill(day, tokenLen, FILL_ZERO);
                    return result;
                }
    
                case "E":
                {
                    day = int(date.getDay());
                    if (tokenLen < 3){
                        result += StringUtil.fill(day, tokenLen, FILL_ZERO);
                        return result;
                    } else if (tokenLen == 3){
                        return dateFormatNaming.getDayShort(day);
                    } else {
                        return dateFormatNaming.getDayLong(day);
                    }
                }
    
                case "A":
                {
                    hours = int(date.getHours());
                    if (hours < 12){
                        return dateFormatNaming.getTimeSection(0);
                    } else {
                        return dateFormatNaming.getTimeSection(1);
                    }
                }
    
                case "H":
                {
                    hours = int(date.getHours());
                    if (hours == 0){
                        hours = 24;
                    }
                    result += StringUtil.fill(hours, tokenLen, FILL_ZERO);
                    return result;
                }
    
                case "J":
                {
                    hours = int(date.getHours());
                    result += StringUtil.fill(hours, tokenLen, FILL_ZERO);
                    return result;
                }
    
                case "K":
                {
                    hours = int(date.getHours());
                    if (hours >= 12){
                        hours = hours - 12;
                    }
                    result += StringUtil.fill(hours, tokenLen, FILL_ZERO);
                    return result;
                }
    
                case "L":
                {
                    hours = int(date.getHours());
                    if (hours == 0){
                        hours = 12;
                    } else if (hours > 12){
                        hours = hours - 12;
                    }
                    result += StringUtil.fill(hours, tokenLen, FILL_ZERO);
                    return result;
                }
    
                case "N":
                {
                    var mins:int = int(date.getMinutes());
                    result += StringUtil.fill(mins, tokenLen, FILL_ZERO);
                    return result;
                }
    
                case "S":
                {
                    var sec:int = int(date.getSeconds());
                    result += StringUtil.fill(sec, tokenLen, FILL_ZERO);
                    return result;
                }
            }
    
            return result;
        }        
    }
}