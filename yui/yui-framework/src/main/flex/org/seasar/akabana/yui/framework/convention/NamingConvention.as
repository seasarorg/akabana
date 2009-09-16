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
package org.seasar.akabana.yui.framework.convention
{
    public class NamingConvention
    {
        public static const VIEW:String = "view";
        public static const HELPER:String = "helper";
        public static const ACTION:String = "action";
        public static const SERVICE:String = "service";
        public static const LOGIC:String = "logic";
        public static const VALIDATOR:String = "validator";
        
        public static const VIEW_SUFFIX:String = "View";
        public static const HELPER_SUFFIX:String = "Helper";
        public static const ACTION_SUFFIX:String = "Action";
        public static const SERVICE_SUFFIX:String = "Service";
        public static const LOGIC_SUFFIX:String = "Logic";
        public static const VALIDATOR_SUFFIX:String = "Validator";
        
        public static const VIEW_PATH_REG:RegExp = /^(.+)\.view\.(.+?)View$/;     
        public static const HELPER_PATH_REG:RegExp = /^(.+)\.(.+)\.(.+?)Helper$/;   
        public static const ACTION_PATH_REG:RegExp = /^(.+)\.action\.(.+?)Action$/;      
        
        public static const VIEW_NAME_REG:RegExp = /^(.+?)View$/;        
        public static const HELPER_NAME_REG:RegExp = /^(.+?)Helper$/;        
        public static const ACTION_NAME_REG:RegExp = /^(.+?)Action$/;         

        public static const HANDLER_SUFFIX:String = "Handler";
        public static const OWN_HANDLER_PREFIX:String = "on";

        private static const DOT:String = ".";
        private static const PATH_REG_PREFIX:String = "^\\.";
        private static const PATH_REG_MIDDLE:String = "\\..+?";
        private static const PATH_REG_SUFFIX:String = "$";
        private static const VAR_NAME_REG_PREFIX:String = "^.+?";
        private static const VAR_NAME_REG_SUFFIX:String = "$";
        
        protected static function changeViewPackageTo( viewName:String, packageName:String, suffix:String ):String{
            var classPathArray:Array = viewName.match(VIEW_PATH_REG);
            return classPathArray[1] + DOT + packageName + DOT + classPathArray[2] + suffix;
        }
                
        private var _conventions:Array;

        public function get conventions():Array{
            return _conventions;
        }
        
        public function set conventions( value:Array ):void{
            _conventions = value;
        }
                
        public function NamingConvention(){
        }

        public function getViewPackageName():String{
            return VIEW;
        }

        public function getHelperPackageName():String{
            return HELPER;
        }

        public function getActionPackageName():String{
            return ACTION;
        }

        public function getServicePackageName():String{
            return SERVICE;
        }
        
        public function getLogicPackageName():String{
            return LOGIC;
        }
        
        public function getValidatorPackageName():String{
            return VALIDATOR;
        }
        
        public function getViewSuffix():String{
            return VIEW_SUFFIX;
        }

        public function getHelperSuffix():String{
            return HELPER_SUFFIX;
        }

        public function getActionSuffix():String{
            return ACTION_SUFFIX;
        }

        public function getServiceSuffix():String{
            return SERVICE_SUFFIX;
        }
        
        public function getLogicSuffix():String{
            return LOGIC_SUFFIX;
        }
        
        public function getValidatorSuffix():String{
            return VALIDATOR_SUFFIX;
        }

        public function getViewName( varName:String ):String{
            var viewName:String = null;
            
            var classPathArray:Array = varName.match(HELPER_NAME_REG);
            if( classPathArray.length <= 1 ){
                classPathArray = varName.match(ACTION_NAME_REG);
            }
            if( classPathArray.length > 1 ){
                viewName = classPathArray[1] + getViewSuffix();                
            }
            return viewName;
        }

        public function getViewClassName( fullClassName:String ):String{
            var viewName:String = null;
            
            var classPathArray:Array = fullClassName.match(HELPER_PATH_REG);
            if( classPathArray.length <= 1 ){
                classPathArray = fullClassName.match(ACTION_PATH_REG);
            }
            if( classPathArray.length > 1 ){
                viewName = classPathArray[1] + DOT + getViewPackageName() + DOT + classPathArray[classPathArray.length-1] + getViewSuffix();                
            }
            return viewName;
        }

        public function getActionClassName( viewClassName:String ):String{
            return changeViewPackageTo( viewClassName, getActionPackageName(), getActionSuffix() );            
        }
        
        public function getHelperClassName( viewClassName:String ):String{
            return changeViewPackageTo( viewClassName, getHelperPackageName(), getHelperSuffix()); 
        }
		
		public function getLogicClassName( viewClassName:String ):String
		{
            return changeViewPackageTo( viewClassName, getLogicPackageName(), getLogicSuffix() ); 
		}

        public function getValidatorClassName( viewClassName:String ):String
        {
            return changeViewPackageTo( viewClassName, getValidatorPackageName(), getValidatorSuffix() ); 
        }		
        
        public function getHandlerSuffix():String{
            return HANDLER_SUFFIX;
        }

        public function getOwnHandlerPrefix():String{
            return OWN_HANDLER_PREFIX;
        }
        		
        public function isViewClassName( className:String ):Boolean{
            return checkClassFullName(className,getViewPackageName(),getViewSuffix());
        }

        public function isHelperClassName( className:String ):Boolean{
            return checkClassFullName(className,getHelperPackageName(),getHelperSuffix());
        }

        public function isHelperName( varName:String ):Boolean{
            return checkVarName(varName,getHelperSuffix());
        }

        public function isActionName( varName:String ):Boolean{
            return checkVarName(varName,getActionSuffix());
        }

        public function isActionClassName( className:String ):Boolean{
            return checkClassFullName(className,getActionPackageName(),getActionSuffix());
        }        

        public function isServiceClassName( className:String ):Boolean{
            return checkClassFullName(className,getServicePackageName(),getServiceSuffix());
        }
        
        public function isLogicClassName( className:String ):Boolean{
            return checkClassFullName(className,getLogicPackageName(),getLogicSuffix());
        }

        public function isValidatorClassName( className:String ):Boolean{
            return checkClassFullName(className,getValidatorPackageName(),getValidatorSuffix());
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

        protected function checkVarName( varName:String, suffix:String ):Boolean{
            var isTarget:Boolean = false;
            
            var regexp_:String = VAR_NAME_REG_PREFIX + suffix + VAR_NAME_REG_SUFFIX;
            if( varName.search(new RegExp(regexp_)) == 0 ){
                isTarget = true;
            }
            
            return isTarget;
        }
    }
}