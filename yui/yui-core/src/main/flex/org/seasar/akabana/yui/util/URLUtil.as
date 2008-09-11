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
package org.seasar.akabana.yui.util {
    
    import org.seasar.akabana.yui.mx.util.ApplicationUtil;
    
    public class URLUtil {
        private static const SERVER_URL_PATTERN:RegExp = /^http[s]?:\/\/.+?\//;
        
        private static const SWF_DIR_URL_PATTERN:RegExp = /^http[s]?:\/\/.+\//;
        
        private static const HTTP:String = "http";
        
        private static const SLASH:String = "/";
        
        public static function isValidHttpUrl( url:String ):Boolean{
            return isHttpURL(url) || isHttpsURL(url);
        }
        
        public static function isHttpURL( url:String ):Boolean{
            return url.indexOf("http://") == 0;
        }

        public static function isHttpsURL( url:String ):Boolean{
            return url.indexOf("https://") == 0;
        }
        
        public static function getHttpUrl( _url:String ):String{
			var httpIndex:int = _url.indexOf(HTTP);
			var _newUrl:String = null;
			switch( httpIndex ){
				case 0:
					_newUrl = _url;
					break;
				case -1:
					_newUrl = resolveUrl( _url );
					break;
				default:
				
			}
			
			return _newUrl;
        }
        
        private static function resolveUrl( _url:String ):String{
            const swfUrl:String = ApplicationUtil.loadedUrl;
            const slashIndex:int = _url.indexOf(SLASH);
            var resolvedUrl:String = null;
            var urlMatchResult:Array;
            switch( slashIndex ){
            	case 0:
            		resolvedUrl = _url.substr(1,_url.length);
					urlMatchResult = swfUrl.match(SERVER_URL_PATTERN);
					break;
            		
            	default:
         			resolvedUrl = _url;
					urlMatchResult = swfUrl.match(SWF_DIR_URL_PATTERN);
					
            		break;
            }
            
            if( urlMatchResult.length > 0 ){
                resolvedUrl = urlMatchResult[0] + resolvedUrl;
            }
            return resolvedUrl;
        }

    }
}