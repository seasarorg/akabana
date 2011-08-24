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
package org.seasar.akabana.yui.framework.message
{
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;
    
    import mx.resources.ResourceManager;
    
    import org.seasar.akabana.yui.util.StringUtil;
    
    use namespace flash_proxy;
    
    [Bindable]
    public dynamic class Messages extends Proxy {
        
        private var _bundleName:String;
        
        public function Messages(bundleName:String){
            _bundleName = bundleName;
        }
        
        flash_proxy override function getProperty(name:*):* {
            return ResourceManager.getInstance().getString(_bundleName,name.toString());
        }
        
        flash_proxy override function setProperty(name:*, value:*):void {
        }        
        
        flash_proxy override function hasProperty(name:*):Boolean {
            return true;
        }     
        
        public function getMessage( resourceName:String,...parameters ):String{
            return substitute(
                        ResourceManager.getInstance().getString(_bundleName,resourceName),
                        parameters
                    );
        }
        
        protected function substitute(str:String, ... args):String{
            return StringUtil.substitute.apply( null, [str].concat( args ));
        }           
    }
}