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
package org.seasar.akabana.yui.service.rpc {

    import flash.net.ObjectEncoding;
    import flash.utils.Dictionary;
    
    import org.seasar.akabana.yui.framework.logging.debug;
    import org.seasar.akabana.yui.service.ServiceGatewayUrlResolver;
    import org.seasar.akabana.yui.service.error.IllegalGatewayError;

    [ExcludeClass]
    public final class RemotingConnectionFactory {

        private static const GATEWAY_RC_REF_CACHE:Dictionary = new Dictionary();

        public static function createConnection( gatewayUrl:String, destination:String ):RemotingConnection{
            if( gatewayUrl == null ){
                gatewayUrl = ServiceGatewayUrlResolver.resolve( destination );
            }
CONFIG::DEBUG{
            debug( RemotingConnectionFactory, destination + " service gateway is " + gatewayUrl);
}
            if( gatewayUrl == null ){
                throw new IllegalGatewayError(gatewayUrl);
            }
            var rc:RemotingConnection = null;
			
			if( gatewayUrl in GATEWAY_RC_REF_CACHE ){
				rc = GATEWAY_RC_REF_CACHE[ gatewayUrl ];
			} else {
				rc = new RemotingConnection();
				rc.objectEncoding = ObjectEncoding.AMF3;

                if( gatewayUrl != null ){
					rc.connect( gatewayUrl );
                } else {
                    throw new IllegalGatewayError(gatewayUrl);
                }

				GATEWAY_RC_REF_CACHE[ gatewayUrl ] = rc;
            }

            return rc;
        }
    }
}