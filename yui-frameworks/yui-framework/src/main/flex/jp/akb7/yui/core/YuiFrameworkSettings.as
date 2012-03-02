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
package jp.akb7.yui.core
{
    import mx.core.IMXMLObject;
    import mx.styles.CSSStyleDeclaration;
    import mx.styles.IStyleClient;
    
    import jp.akb7.yui.YuiFrameworkGlobals;
    import jp.akb7.yui.core.mixin.YuiFrameworkMixin;
    import jp.akb7.yui.core.ns.yui_internal;
    import jp.akb7.yui.message.MessageManager;
    
    [Style(name="namingConventionClass", inherit="no", type="Class")]
    [Style(name="frameworkBridgePlugin", inherit="no", type="Class")]
    [Style(name="autoMonitoring", inherit="no", type="Boolean")]
    public final class YuiFrameworkSettings implements IMXMLObject,IStyleClient
    {
        {
            YuiFrameworkMixin;
            MessageManager;
        }
        
        /**
         * @private
         */
        private var _styles:Object = {};
        
        /**
         * @private
         */
        private var _autoMonitoring:Boolean = true;
        
        /**
         * 
         * @return 
         * 
         */
        public function get isAutoMonitoring():Boolean
        {
            return _autoMonitoring;
        }
        
        /**
         * 
         * 
         */
        public function YuiFrameworkSettings(){
            YuiFrameworkGlobals.yui_internal::setSettings( this );
        }

        /**
         * 
         * @param document
         * @param id
         * 
         */
        public function initialized(document:Object, id:String):void{
        }
        
        /**
         * 
         * @return 
         * 
         */
        public function get styleName():Object{
            return null;
        }
            
        /**
         * 
         * @param value
         * 
         */
        public function set styleName(value:Object):void{}
                
        /**
         * 
         * @param styleProp
         * 
         */
        public function styleChanged(styleProp:String):void{}
        
        
        /**
         * 
         * @return 
         * 
         */
        public function get className():String{
            return "YuiFrameworkSettings";
        }
        
        /**
         * 
         * @return 
         * 
         */
        public function get inheritingStyles():Object{
            return {};
        }
        
        /**
         * 
         * @param value
         * 
         */
        public function set inheritingStyles(value:Object):void{}
        
        /**
         * 
         * @return 
         * 
         */
        public function get nonInheritingStyles():Object{
            return _styles;
        }
        
        /**
         * 
         * @param value
         * 
         */
        public function set nonInheritingStyles(value:Object):void{}
        
        /**
         * @private 
         */
        private var _styleDeclaration:CSSStyleDeclaration;
        /**
         * 
         * @return 
         * 
         */
        public function get styleDeclaration():CSSStyleDeclaration{
            return _styleDeclaration;
        }
        
        /**
         * 
         * @param value
         * 
         */
        public function set styleDeclaration(value:CSSStyleDeclaration):void{}
        
        /**
         * 
         * @param styleProp
         * @return 
         * 
         */
        public function getStyle(styleProp:String):*{
            return _styles[styleProp];
        }
        
        /**
         * 
         * @param styleProp
         * @param newValue
         * 
         */
        public function setStyle(styleProp:String, newValue:*):void{
            _styles[styleProp] = newValue;
            if( styleProp == "autoMonitoring"){
                _autoMonitoring = newValue as Boolean;
            }
        }
            
        /**
         * 
         * @param styleProp
         * 
         */
        public function clearStyle(styleProp:String):void{}
            
        /**
         * 
         * @return 
         * 
         */
        public function getClassStyleDeclarations():Array{
            return [];
        }
            
        /**
         * 
         * @param styleProp
         * @param recursive
         * 
         */
        public function notifyStyleChangeInChildren(styleProp:String,recursive:Boolean):void{}
            
        /**
         * 
         * @param recursive
         * 
         */
        public function regenerateStyleCache(recursive:Boolean):void{}
            
        /**
         * 
         * @param effects
         * 
         */
        public function registerEffects(effects:Array /* of String */):void{}
    }
}