/*
 * Copyright 2004-2007 the Seasar Foundation and the Others.
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
package org.seasar.akabana.yui.service.rpc.remoting {
    
    import flash.net.ObjectEncoding;
    
    import org.seasar.akabana.yui.framework.application.ApplicationUtil;
    import org.seasar.akabana.yui.net.URLUtil;
    
    public class RemotingConnectionFactory {
        
        private static const REMOTING_PREFIX:String = "remoting.";
        
        private static const DEFAULT_GATEWAY:String = REMOTING_PREFIX + "defaultGateway";
        
        public static function createConnection( destination:String ):RemotingConnection{
        	var connection:RemotingConnection = new RemotingConnection();
			connection.objectEncoding = ObjectEncoding.AMF3;
			var gatewayUrl:String = resolveGatewayUrl( destination );
			if( gatewayUrl != null ){
			    connection.connect( gatewayUrl );
			} else {
			    throw new Error("gatewayUrlが設定されていません。");
			}
			
			return connection;
        }

        private static function resolveGatewayUrl( destination:String ):String{
            var gatewayUrl:String = null;
            do{ 
                gatewayUrl = ApplicationUtil.getParameterValue(REMOTING_PREFIX + destination );
                if( gatewayUrl != null ){
                    break;
                }

                gatewayUrl = resolveGatewayUrlByURL();
                if( gatewayUrl != null ){
                    break;
                }
                
                gatewayUrl = ApplicationUtil.getParameterValue( DEFAULT_GATEWAY );
                
            } while( false );
            
            return gatewayUrl;
        }

        private static function resolveGatewayUrlByURL():String{
            var gatewayUrl:String = null;
            var url:String = ApplicationUtil.getGlobalsApplication().url;
            
            if( URLUtil.isValidHttpUrl(url)){
                gatewayUrl = url.substring(0, url.lastIndexOf("/")+1 ) + "gateway";
            }
                        
            return gatewayUrl;
        }
    }
}