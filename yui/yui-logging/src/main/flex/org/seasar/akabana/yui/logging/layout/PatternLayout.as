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
package org.seasar.akabana.yui.logging.layout
{
    import mx.formatters.DateFormatter;
    
    import org.seasar.akabana.yui.logging.LoggingEvent;
    
    /**
     * %c category name
     * %d {date-format}
     * %t trace
     * %l level 
     * %m message
     * %n 改行
     */ 
    public class PatternLayout extends LayoutBase
    {
        private static const DATE_FORMATTER:DateFormatter = new DateFormatter();
        
        private static const DATE_FORMAT:String = "YYYY/MM/DD JJ:NN:SS";
        
        public var pattern:String;

        public override function format( event:LoggingEvent ):String{
            return parse(event);
        }
        
        public function parse(event:LoggingEvent):String{
            var patternCharArray:Array = this.pattern.split("");
            var result_:String = "";
            for( var i:int = 0; i < patternCharArray.length; i++ ){
                if( patternCharArray[i] == '%' ){
                    i++;
                    if( patternCharArray[i] == '%' ){
                        result_ += "%";
                    } else {
                        switch( patternCharArray[i] ){
                            case 'c':
                                result_ += event.categoryName;
                                break;
                            case 'd':
                                var formatString:String = DATE_FORMAT;
                                if( patternCharArray[i+1] == '{'){
                                    i++;
                                    i++;
                                    while( i < patternCharArray.length && patternCharArray[i] != '}'){
                                        formatString += patternCharArray[i];
                                        i++;
                                    }
                                }
                                DATE_FORMATTER.formatString = formatString;
                                result_ = DATE_FORMATTER.format(new Date());
                                break;
                            case 't':
                                result_ += event.error != null ? event.error.getStackTrace() : "";
                                break;
                            case 'l':
                                result_ += event.level.name;
                                break;
                            case 'm':
                                result_ += event.message;
                                break;
                            case 'n':
                                result_ += '\n';
                                break;
                            default:
                                                
                        }
                    }
                } else {
                    result_ += patternCharArray[i];
                }
            }
            return result_;
        }
    }
}