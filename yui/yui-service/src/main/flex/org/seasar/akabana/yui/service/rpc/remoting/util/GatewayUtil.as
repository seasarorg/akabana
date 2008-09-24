package org.seasar.akabana.yui.service.rpc.remoting.util
{
    import org.seasar.akabana.yui.mx.util.ApplicationUtil;
    import org.seasar.akabana.yui.util.URLUtil;
    
    public class GatewayUtil
    {
        public static var defaultGateway:String;
        
        private static const REMOTING_PREFIX:String = "remoting.";
        
        private static const DEFAULT_GATEWAY:String = REMOTING_PREFIX + "defaultGateway";
        
        public static function resolveGatewayUrl( destination:String ):String{
            var gatewayUrl:String = null;
            do{ 
                gatewayUrl = ApplicationUtil.getParameterValue(REMOTING_PREFIX + destination );
                if( gatewayUrl != null ){
                    break;
                }

                gatewayUrl = GatewayUtil.defaultGateway;
                if( gatewayUrl != null ){
                    break;
                }
                
                gatewayUrl = ApplicationUtil.getParameterValue( DEFAULT_GATEWAY );
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
            var url:String = ApplicationUtil.loadedUrl;
            
            if( URLUtil.isValidHttpUrl(url)){
                gatewayUrl = url.substring(0, url.lastIndexOf("/")+1 ) + "gateway";
            }
                        
            return gatewayUrl;
        }
    }
}