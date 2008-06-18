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
        private var _conventions:Array;
        
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

        public function getViewName( name:String ):String{
            var viewName:String = null;
            
            var classPathArray:Array = name.match(/^(.+)\.helper\.(.+?)Helper/);
            if( classPathArray.length <= 1 ){
                classPathArray = name.match(/^(.+)\.action\.(.+?)Action/);
            }
            if( classPathArray.length > 1 ){
                viewName = classPathArray[1] + ".view." + classPathArray[classPathArray.length-1] + "View";                
            }
            return viewName;
        }

        public function getActionName( viewName:String ):String{
            var classPathArray:Array = viewName.match(/^(.+)\.view\.(.+?)View$/);
            return classPathArray[1] + ".action." + classPathArray[classPathArray.length-1] + "Action";
        }
        
        public function getHelperName( viewName:String ):String{
            var classPathArray:Array = viewName.match(/^(.+)\.view\.(.+?)View$/);
            return classPathArray[1] + ".helper." + classPathArray[classPathArray.length-1] + "Helper";
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