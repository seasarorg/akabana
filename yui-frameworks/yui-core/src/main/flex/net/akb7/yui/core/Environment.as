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
package net.akb7.yui.core
{
    import flash.display.DisplayObject;
    import net.akb7.yui.core.ns.yui_internal;

    public final class Environment {
        
        private static var _parameters:Object = {};

        private static var _root:DisplayObject;

        public static function getParameterValue( parameterName:String ):String{
            return _parameters[ parameterName ];
        }

        public static function get root():DisplayObject{
            return _root;
        }
        
        public static function get url():String{
            if( _root == null ){
                return null;
            } else {
                return _root.stage.loaderInfo.url;
            }
        }
        
        yui_internal static function setParameters( value:Object ):void{
            _parameters = value;
        }
        
        yui_internal static function setRoot(value:DisplayObject):void{
            _root = value;
        }

    }
}