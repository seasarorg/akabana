package org.seasar.akabana.yui.service.util
{
    import org.seasar.akabana.yui.core.Environment;
    import org.seasar.akabana.yui.util.URLUtil;

    [ExcludeClass]
    public class GatewayUtil
    {
        public static var defaultGateway:String;

        public static const DEFAULT_GATEWAY_URL:String = "defaultGatewayUrl";

        public static function resolveGatewayUrl( destination:String ):String{
            var result:String = null;
            do{
                result = Environment.getParameterValue( destination );
                if( result != null ){
                    break;
                }

                result = GatewayUtil.defaultGateway;
                if( result != null ){
                    break;
                }

                result = Environment.getParameterValue( DEFAULT_GATEWAY_URL );
                if( result != null ){
                    GatewayUtil.defaultGateway = result;
                    break;
                }

            } while( false );

            return result;
        }
    }
}