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
package org.seasar.akabana.yui.framework.convention
{
    import flash.display.DisplayObject;
    
    import org.seasar.akabana.yui.core.ns.handler;

CONFIG::FP10{
    import __AS3__.vec.Vector;
}

    [ExcludeClass]
    public class NamingConvention {

        public static const VIEW:String = "view";
        public static const HELPER:String = "helper";
        public static const ACTION:String = "action";
        public static const SERVICE:String = "service";
        public static const COMMAND:String = "command";
        public static const VALIDATOR:String = "validator";
        public static const BEHAVIOR:String = "behavior";

        public static const VIEW_SUFFIX:String = "View";
        public static const HELPER_SUFFIX:String = "Helper";
        public static const ACTION_SUFFIX:String = "Action";
        public static const SERVICE_SUFFIX:String = "Service";
        public static const COMMAND_SUFFIX:String = "Command";
        public static const VALIDATOR_SUFFIX:String = "Validator";
        public static const BEHAVIOR_SUFFIX:String = "Behavior";
        
        public static const VIEW_NAME_REG_SUFFIX:String = VIEW_SUFFIX+"|"+VIEW_SUFFIX+"_.+?";
        public static const VIEW_PATH_REG:RegExp = new RegExp("^(.+)\." + VIEW +"\.(.+?)" + VIEW_NAME_REG_SUFFIX + PATH_REG_SUFFIX );// /^(.+)\.view\.(.+?)(View|View_.+?)$/;
        public static const HELPER_PATH_REG:RegExp = new RegExp("^(.+)\." + HELPER +"\.(.+?)" + HELPER_SUFFIX + PATH_REG_SUFFIX );// /^(.+)\.helper\.(.+?)Helper$/;
        public static const ACTION_PATH_REG:RegExp = new RegExp("^(.+)\." + ACTION +"\.(.+?)" + ACTION_SUFFIX + PATH_REG_SUFFIX );// /^(.+)\.action\.(.+?)Action$/;

        public static const HANDLER_SUFFIX:String = "Handler";
        public static const OWN_HANDLER_PREFIX:String = "on";

        public static const EVENT_SEPARETOR:String = "_";

        private static const DOT:String = ".";
        private static const PATH_REG_PREFIX:String = "^\\.";
        private static const PATH_REG_MIDDLE:String = "\\..+?";
        private static const PATH_REG_SUFFIX:String = "$";
        private static const VAR_NAME_REG_PREFIX:String = "^.+?";
        private static const VAR_NAME_REG_SUFFIX:String = "$";

CONFIG::FP9{
        protected var _conventions:Array;

        public function get conventions():Array{
            return _conventions;
        }

        public function set conventions( value:Array ):void{
            _conventions = value;
        }
}
CONFIG::FP10{
        protected var _conventions:Vector.<String>;

        public function get conventions():Vector.<String>{
            return _conventions;
        }

        public function set conventions( value:Vector.<String> ):void{
            _conventions = value;
        }
}

        public function NamingConvention(){
        }

        public function getActionClassName( viewClassName:String ):String{
            return changeViewPackageTo( viewClassName, ACTION, ACTION_SUFFIX );
        }

        public function getHelperClassName( viewClassName:String ):String{
            return changeViewPackageTo( viewClassName, HELPER, HELPER_SUFFIX);
        }

        public function getValidatorClassName( viewClassName:String ):String
        {
            return changeViewPackageTo( viewClassName, VALIDATOR, VALIDATOR_SUFFIX );
        }
        
        public function getBehaviorClassName( viewClassName:String ):String
        {
            return changeViewPackageTo( viewClassName, BEHAVIOR, BEHAVIOR_SUFFIX );
        }
        
        public function getHandlerSuffix():String{
            return HANDLER_SUFFIX;
        }

        public function getOwnHandlerPrefix():String{
            return OWN_HANDLER_PREFIX;
        }

        public function getComponentName(component:DisplayObject):String{
            var componentName:String = component.name;
            return componentName;
        }
        
        public function isHelperName( varName:String ):Boolean{
            return checkVarName(varName,HELPER_SUFFIX);
        }
        
        public function isActionName( varName:String ):Boolean{
            return checkVarName(varName,ACTION_SUFFIX);
        }

        public function isViewClassName( className:String ):Boolean{
            return checkClassFullName(className,VIEW,VIEW_NAME_REG_SUFFIX);
        }

        public function isHelperClassName( className:String ):Boolean{
            return checkClassFullName(className,HELPER,HELPER_SUFFIX);
        }

        public function isActionClassName( className:String ):Boolean{
            return checkClassFullName(className,ACTION,ACTION_SUFFIX);
        }

        public function isServiceClassName( className:String ):Boolean{
            return checkClassName(className,SERVICE_SUFFIX);
        }

        public function isCommandClassName( className:String ):Boolean{
            return checkClassName(className,COMMAND_SUFFIX);
        }

        public function isValidatorClassName( className:String ):Boolean{
            return checkClassFullName(className,VALIDATOR,VALIDATOR_SUFFIX);
        }

        public function isBehaviorClassName( className:String ):Boolean{
            return checkClassFullName(className,BEHAVIOR,BEHAVIOR_SUFFIX);
        }
        
        public function getEventName(functionName:String,functionUri:String,componentName:String):String {
            const ns:Namespace = handler;
            const eventWord:String = functionName.substr(componentName.length);
            const handlerIndex:int = eventWord.lastIndexOf(getHandlerSuffix());
            var result:String = null;
            
            if(eventWord.charAt(0) == EVENT_SEPARETOR) {
                if(functionUri == ns.uri) {
                    result = eventWord.substring(1);
                } else {
                    result = eventWord.substring(1,handlerIndex);
                }
            } else {
                if(functionUri == ns.uri) {
                    result = eventWord.substr(0,1).toLocaleLowerCase() + eventWord.substring(1);
                } else {
                    result = eventWord.substr(0,1).toLocaleLowerCase() + eventWord.substring(1,handlerIndex);
                }
            }
            return result;
        }
        
        public function isHelperOfView(viewClassName:String,helperClassName:String):Boolean{
            var result:Boolean = false;
            var viewHelperClassName:String = getHelperClassName(viewClassName);
            var viewHelperName:String = viewHelperClassName.substring(0,viewHelperClassName.lastIndexOf(HELPER_SUFFIX));
            result = helperClassName.indexOf(viewHelperName) == 0;
            
            return result;
        }
        
        public function isValidatorOfView(viewClassName:String,validatorClassName:String):Boolean{
            var result:Boolean = false;
            if( isValidatorClassName(validatorClassName)){
                var viewvalidatorName:String = viewClassName.substring(0,viewClassName.lastIndexOf(VIEW_SUFFIX));
                viewvalidatorName = viewvalidatorName.replace(VIEW,VALIDATOR);
                result = validatorClassName.indexOf(viewvalidatorName) == 0;
            }
            return result;
        }
        
        public function isBehaviorOfView(viewClassName:String,behaviorClassName:String):Boolean{
            var result:Boolean = false;
            if( isBehaviorClassName(behaviorClassName)){
                var viewBehaviorName:String = viewClassName.substring(0,viewClassName.lastIndexOf(VIEW_SUFFIX));
                viewBehaviorName = viewBehaviorName.replace(VIEW,BEHAVIOR);
                result = behaviorClassName.indexOf(viewBehaviorName) == 0;
            }
            return result;
        }
        
        protected function checkClassFullName( className:String, packageName:String, suffix:String ):Boolean{
            var isTarget:Boolean = false;
            for each( var rootPath:String in _conventions ){
                if( className.indexOf(rootPath) == 0 ){
                    var subPath:String = className.substring(rootPath.length);
                    var regexp_:String = PATH_REG_PREFIX + packageName + PATH_REG_MIDDLE + suffix + PATH_REG_SUFFIX;
                    if( subPath.search(new RegExp(regexp_)) == 0 ){
                        isTarget = true;
                        break;
                    }
                }
            }

            return isTarget;
        }
        
        protected function checkClassName( className:String, suffix:String ):Boolean{
            var isTarget:Boolean = (className.lastIndexOf(suffix) == (className.length - suffix.length));
            
            return isTarget;
        }

        protected function checkVarName( varName:String, suffix:String ):Boolean{
            var isTarget:Boolean = false;

            var regexp_:String = VAR_NAME_REG_PREFIX + suffix + VAR_NAME_REG_SUFFIX;
            if( varName.search(new RegExp(regexp_)) == 0 ){
                isTarget = true;
            }

            return isTarget;
        }

        protected function changeViewPackageTo( viewName:String, packageName:String, suffix:String ):String{
            var classPathArray:Array = viewName.match(VIEW_PATH_REG);
            return classPathArray[1] + DOT + packageName + DOT + classPathArray[2] + suffix;
        }
    }
}