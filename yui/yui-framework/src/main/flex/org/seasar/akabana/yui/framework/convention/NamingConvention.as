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

        public function getViewName( varName:String ):String{
            var viewName:String = null;
            
            var classPathArray:Array = varName.match(/^(.+?)Helper$/);
            if( classPathArray.length <= 1 ){
                classPathArray = varName.match(/^(.+?)Action$/);
            }
            if( classPathArray.length > 1 ){
                viewName = classPathArray[1] + getViewSuffix();                
            }
            return viewName;
        }

        public function getViewClassName( fullClassName:String ):String{
            var viewName:String = null;
            
            var classPathArray:Array = fullClassName.match(/^(.+)\.(.+)\.(.+?)Helper$/);
            if( classPathArray.length <= 1 ){
                classPathArray = fullClassName.match(/^(.+)\.action\.(.+?)Action$/);
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
		
        public function isViewClassName( className:String ):Boolean{
            return isCoustomClassName(className,getViewPackageName(),getViewSuffix());
        }

        public function isHelperClassName( className:String ):Boolean{
            return isCoustomClassName(className,getHelperPackageName(),getHelperSuffix());
        }

        public function isHelperName( varName:String ):Boolean{
            return isCoustomName(varName,getHelperSuffix());
        }

        public function isActionClassName( className:String ):Boolean{
            return isCoustomClassName(className,getActionPackageName(),getActionSuffix());
        }        

        public function isServiceClassName( className:String ):Boolean{
            return isCoustomClassName(className,getServicePackageName(),getServiceSuffix());
        }
        
        public function isLogicClassName( className:String ):Boolean{
            return isCoustomClassName(className,getLogicPackageName(),getLogicSuffix());
        }

        public function isValidatorClassName( className:String ):Boolean{
            return isCoustomClassName(className,getValidatorPackageName(),getValidatorSuffix());
        }        
        
        protected function isCoustomClassName( className:String, packageName:String, suffix:String ):Boolean{
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

        protected function isCoustomName( varName:String, suffix:String ):Boolean{
            var isTarget:Boolean = false;
            
            var regexp_:String = "^.+?" + suffix + "$";
            if( varName.search(new RegExp(regexp_)) == 0 ){
                isTarget = true;
            }
            
            return isTarget;
        }
    }
}