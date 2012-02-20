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
package org.seasar.akabana.yui.framework.core
{
    import mx.core.IMXMLObject;
    import mx.styles.CSSStyleDeclaration;
    import mx.styles.IStyleClient;
    
    import org.seasar.akabana.yui.core.ns.yui_internal;
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.core.mixin.YuiFrameworkMixin;
    import org.seasar.akabana.yui.framework.message.MessageManager;
    
    [Style(name="namingConventionClass", inherit="no", type="Class")]
    [Style(name="frameworkBridgePlugin", inherit="no", type="Class")]
    [Style(name="autoMonitoring", inherit="no", type="Boolean")]
    public final class YuiFrameworkSettings implements IMXMLObject,IStyleClient
    {
        {
            YuiFrameworkMixin;
            MessageManager;
        }
        
        private var _styles:Object = {};
        
        private var _autoMonitoring:Boolean = true;
        
        public function get isAutoMonitoring():Boolean
        {
            return _autoMonitoring;
        }
        
        public function YuiFrameworkSettings(){
            YuiFrameworkGlobals.yui_internal::setSettings( this );
        }

        public function initialized(document:Object, id:String):void{
        }
        
        public function get styleName():Object{
            return null;
        }
            
        public function set styleName(value:Object):void{}
                
        public function styleChanged(styleProp:String):void{}
        
        
        public function get className():String{
            return "YuiFrameworkSettings";
        }
        
        public function get inheritingStyles():Object{
            return {};
        }
        
        public function set inheritingStyles(value:Object):void{}
        
        public function get nonInheritingStyles():Object{
            return _styles;
        }
        
        public function set nonInheritingStyles(value:Object):void{}
        
        private var _styleDeclaration:CSSStyleDeclaration;
        public function get styleDeclaration():CSSStyleDeclaration{
            return _styleDeclaration;
        }
        
        public function set styleDeclaration(value:CSSStyleDeclaration):void{}
        
        public function getStyle(styleProp:String):*{
            return _styles[styleProp];
        }
        
        public function setStyle(styleProp:String, newValue:*):void{
            _styles[styleProp] = newValue;
            if( styleProp == "autoMonitoring"){
                _autoMonitoring = newValue as Boolean;
            }
        }
            
        public function clearStyle(styleProp:String):void{}
            
        public function getClassStyleDeclarations():Array{
            return [];
        }
            
        public function notifyStyleChangeInChildren(styleProp:String,recursive:Boolean):void{}
            
        public function regenerateStyleCache(recursive:Boolean):void{}
            
        public function registerEffects(effects:Array /* of String */):void{}
    }
}