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
        private static const DOT:String = ".";

        protected static function changeViewPackageTo( viewName:String, packageName:String, suffix:String ):String{
            var classPathArray:Array = viewName.match(/^(.+)\.view\.(.+?)View$/);
            return classPathArray[1] + DOT + packageName + DOT + classPathArray[2] + suffix;
        }
                
        private var _conventions:Array;

        public function get conventions():Array{
            return _conventions;
        }
        
        public function set conventions( value:Array ):void{
            _conventions = value;
        }
                
        public function NamingConvention()
        {
        }

        public function getViewPackageName():String{
            return "view";
        }

        public function getHelperPackageName():String{
            return "helper";
        }

        public function getActionPackageName():String{
            return "action";
        }

        public function getServicePackageName():String{
            return "service";
        }
        
        public function getLogicPackageName():String{
            return "logic";
        }
        
        public function getValidatorPackageName():String{
            return "validator";
        }
        
        public function getViewSuffix():String{
            return "View";
        }

        public function getHelperSuffix():String{
            return "Helper";
        }

        public function getActionSuffix():String{
            return "Action";
        }

        public function getServiceSuffix():String{
            return "Service";
        }
        
        public function getLogicSuffix():String{
            return "Logic";
        }
        
        public function getValidatorSuffix():String{
            return "Validator";
        }

        public function getViewName( name:String ):String{
            var viewName:String = null;
            
            var classPathArray:Array = name.match(/^(.+)\.helper\.(.+?)Helper$/);
            if( classPathArray.length <= 1 ){
                classPathArray = name.match(/^(.+)\.action\.(.+?)Action$/);
            }
            if( classPathArray.length > 1 ){
                viewName = classPathArray[1] + DOT + getViewPackageName() + DOT + classPathArray[classPathArray.length-1] + getViewSuffix();                
            }
            return viewName;
        }

        public function getActionName( viewName:String ):String{
            return changeViewPackageTo( viewName, getActionPackageName(), getActionSuffix() );            
        }
        
        public function getHelperName( viewName:String ):String{
            return changeViewPackageTo( viewName, getHelperPackageName(), getHelperSuffix()); 
        }
		
		public function getLogicName( viewName:String ):String
		{
            return changeViewPackageTo( viewName, getLogicPackageName(), getLogicSuffix() ); 
		}

        public function getValidatorName( viewName:String ):String
        {
            return changeViewPackageTo( viewName, getValidatorPackageName(), getValidatorSuffix() ); 
        }		
		
        public function isViewName( className:String ):Boolean{
            return isTargetName(className,getViewPackageName(),getViewSuffix());
        }
        
        public function isViewHelperName( className:String ):Boolean{
            return isTargetName(className,getHelperPackageName(),getHelperSuffix());
        }

        public function isActionName( className:String ):Boolean{
            return isTargetName(className,getActionPackageName(),getActionSuffix());
        }        

        public function isServiceName( className:String ):Boolean{
            return isTargetName(className,getServicePackageName(),getServiceSuffix());
        }
        
        public function isLogicName( className:String ):Boolean{
            return isTargetName(className,getLogicPackageName(),getLogicSuffix());
        }

        public function isValidatorName( className:String ):Boolean{
            return isTargetName(className,getValidatorPackageName(),getViewSuffix());
        }        
        
        public function isTargetClassName( className:String ):Boolean{
            var isTarget:Boolean = false;
            
            for each( var rootPath:String in _conventions ){
                if( className.indexOf(rootPath) == 0 ){
                    isTarget = true;
                    break;
                }
            }
            
            return isTarget;  
        }
        
        protected function isTargetName( className:String, packageName:String, suffix:String ):Boolean{
            var isTarget:Boolean = false;
            
            for each( var rootPath:String in _conventions ){
                if( className.indexOf(rootPath) == 0 ){
                    var subPath:String = className.substring(rootPath.length);
                    var regexp_:String = "^\\." + packageName + "\\..+?" + suffix + "$";
                    if( subPath.search(new RegExp(regexp_)) == 0 ){
                        isTarget = true;
                        break;
                    }
                }
            }
            
            return isTarget;
        }

    }
}