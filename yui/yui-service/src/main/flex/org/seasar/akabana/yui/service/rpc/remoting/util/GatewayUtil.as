package org.seasar.akabana.yui.service.rpc.remoting.util
{
    import org.seasar.akabana.yui.core.Environment;
    import org.seasar.akabana.yui.util.URLUtil;
    
    public class GatewayUtil
    {
        public static var defaultGateway:String;
        
        private static const REMOTING_PREFIX:String = "remoting.";
        
        private static const DEFAULT_GATEWAY:String = REMOTING_PREFIX + "defaultGateway";
        
        public static function resolveGatewayUrl( destination:String ):String{
            var gatewayUrl:String = null;
            do{ 
                gatewayUrl = Environment.getParameterValue(REMOTING_PREFIX + destination );
                if( gatewayUrl != null ){
                    break;
                }

                gatewayUrl = GatewayUtil.defaultGateway;
                if( gatewayUrl != null ){
                    break;
                }
                
                gatewayUrl = Environment.getParameterValue( DEFAULT_GATEWAY );
                if( gatewayUrl != null ){
                    GatewayUtil.defaultGateway = gatewayUrl;
                    break;
                }
                
                gatewayUrl = resolveGatewayUrlByURL();
                
                
            } while( false );
            
            return gatewayUrl;
        }

        private static function resolveGatewayUrlByURL():String{
            var gatewayUrl:String = null;
            var url:String = Environment.url;
            
            if( URLUtil.isValidHttpUrl(url)){
                gatewayUrl = url.substring(0, url.lastIndexOf("/")+1 ) + "gateway";
            }
                        
            return gatewayUrl;
        }
    }
}