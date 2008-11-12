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
    public class StringFormatter extends Formatter{

        protected var reqFormat:String;
    
        protected var patternInfo:Array;
    
        protected function formatValue(value:Object):String {

            var curTokenInfo:TokenInfo = patternInfo[0];
            var result:String = reqFormat.substring(0, curTokenInfo.begin) + extractToken(value, curTokenInfo);
    
            var lastTokenInfo:Object = curTokenInfo;
            
            var patternInfoLen:int = patternInfo.length;
            for (var i:int = 1; i < patternInfoLen; i++)
            {
                curTokenInfo = patternInfo[i];
                
                result += reqFormat.substring(lastTokenInfo.end,curTokenInfo.begin) + extractToken(value, curTokenInfo);
                
                lastTokenInfo = curTokenInfo;
            }
            if (lastTokenInfo.end > 0 && lastTokenInfo.end != reqFormat.length)
                result += reqFormat.substring(lastTokenInfo.end);
            
            return result;
        }
        
        protected function compileFormatPattern(format:String, tokens:String):void
        {
            var start:int = 0;
            var end:int = 0;
            var index:int = 0;
            
            var tokenArray:Array = tokens.split(",");
            
            reqFormat = format;
            
            patternInfo = [];
            
            var tokenArrayLen:int = tokenArray.length;
            for (var i:int = 0; i < tokenArrayLen; i++)
            {
                start = reqFormat.indexOf(tokenArray[i]);
                if (start >= 0  && start < reqFormat.length)
                {
                    end = reqFormat.lastIndexOf(tokenArray[i]);
                    end = end >= 0 ? end + 1 : start + 1;
                    patternInfo.push( new TokenInfo( tokenArray[i], start, end));
                    index++;
                }
            }
            patternInfo.sort(compareValues);
        }
    
        private function compareValues(tokenInfoA:TokenInfo, tokenInfoB:TokenInfo):int{
            if( tokenInfoA.begin > tokenInfoB.begin ){
                return 1;
            } else if( tokenInfoA.begin < tokenInfoB.begin ){
                return -1;
            } else {
                return 0;
            }
        } 
        
        protected function extractToken(value:Object,tokenInfo:TokenInfo):String
        {
            return null;   
        }

    }
}