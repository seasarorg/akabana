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
package org.seasar.akabana.yui.service.rpc {
    
    import flash.net.ObjectEncoding;
    
    import org.seasar.akabana.yui.logging.Logger;
    import org.seasar.akabana.yui.service.error.IllegalGatewayError;
    import org.seasar.akabana.yui.service.util.GatewayUtil;
    
    
    public class RemotingConnectionFactory {
        
        private static const _logger:Logger = Logger.getLogger(RemotingConnectionFactory);
        
        private static const gatewayUrlToRc:Object = {};
        
        public static function createConnection( gatewayUrl:String, destination:String ):RemotingConnection{
            if( gatewayUrl == null ){
                gatewayUrl = GatewayUtil.resolveGatewayUrl( destination );            
            }
CONFIG::DEBUG{
            _logger.debug( destination + " service gateway is " + gatewayUrl);
}
            if( gatewayUrl == null ){
                throw new IllegalGatewayError(gatewayUrl);
            }
            var connection:RemotingConnection = gatewayUrlToRc[ gatewayUrl ];
            if( connection == null ){            
                connection = new RemotingConnection();
    			connection.objectEncoding = ObjectEncoding.AMF3;
    			
    			if( gatewayUrl != null ){
                    connection.connect( gatewayUrl );			    
                } else {
    			    throw new IllegalGatewayError(gatewayUrl);
    			}
    			
    			gatewayUrlToRc[ gatewayUrl ] = connection;
            }
			return connection;
        }
    }
}