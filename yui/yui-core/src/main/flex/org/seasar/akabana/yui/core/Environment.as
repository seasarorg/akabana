package org.seasar.akabana.yui.core
{
    import flash.display.DisplayObject;

    public class Environment
    {
        private static var _parameters:Object = {};

        private static var _root:DisplayObject;

        public static function getParameterValue( parameterName:String ):String{
            return _parameters[ parameterName ];
        }

        yui_internal static function set parameters( value:Object ):void{
            _parameters = value;
        }

        public static function get root():DisplayObject{
            return _root;
        }

        yui_internal static function set root(value:DisplayObject):void{
            _root = value;
        }

        public static function get url():String{
            if( _root == null ){
                return null;
            } else {
                return _root.stage.loaderInfo.url;
            }
        }
    }
}