/*
* Copyright 2004-2010 the Seasar Foundation and the Others.
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
package org.seasar.akabana.yui.service
{
    import mx.resources.ResourceManager;
    
    import org.seasar.akabana.yui.core.Environment;
    import org.seasar.akabana.yui.util.StringUtil;
    import org.seasar.akabana.yui.util.URLUtil;

    [ExcludeClass]
	[ResourceBundle("services")]
    public class ServiceGatewayUrlResolver
    {
        public static var defaultGateway:String;
        
        public static const GATEWAY_URL:String = "GatewayUrl";
        
		public static const DEFAULT_GATEWAY_URL:String = "default"+GATEWAY_URL;
		
		private static const SERVICES:String = "services";
		
        public static function resolve( destination:String ):String{
            var result:String = null;
            do{
				//destination gateway
                
                result = Environment.getParameterValue( destination + GATEWAY_URL );
                if( !StringUtil.isEmpty(result) ){
                    break;
                }
                
				result = ResourceManager.getInstance().getString( SERVICES, destination + GATEWAY_URL);
				if( !StringUtil.isEmpty(result) ){
					break;
				}
				
				//defaultGateway				
				result = ServiceGatewayUrlResolver.defaultGateway;
				if( !StringUtil.isEmpty(result) ){
					break;
				}
                
                result = Environment.getParameterValue( DEFAULT_GATEWAY_URL );
                if( !StringUtil.isEmpty(result) ){
                    ServiceGatewayUrlResolver.defaultGateway = result;
                    break;
                }
				
				result = ResourceManager.getInstance().getString( SERVICES, DEFAULT_GATEWAY_URL);
				if( !StringUtil.isEmpty(result) ){
					ServiceGatewayUrlResolver.defaultGateway = result;
				}

			} while( false );
			
            return result;
        }
    }
}