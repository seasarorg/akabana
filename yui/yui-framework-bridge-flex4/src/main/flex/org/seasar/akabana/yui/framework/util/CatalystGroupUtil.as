/*
* Copyright 2004-2010 the Seasar Foundation and the Others.
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
package org.seasar.akabana.yui.framework.util
{
    import mx.core.IVisualElement;
    import mx.core.UIComponent;
    
    import spark.components.Group;
    
    import org.seasar.akabana.yui.framework.bridge.Flex4FrameworkBridgePlugin;
    import org.seasar.akabana.yui.framework.convention.CatalystNamingConvention;
    
    [ExcludeClass]
    public class CatalystGroupUtil
    {
        private static var bridge:Flex4FrameworkBridgePlugin = new Flex4FrameworkBridgePlugin();
        
        private static var namingConvention:CatalystNamingConvention = new CatalystNamingConvention();
        
        public static function getAllElements(container:UIComponent):Vector.<IVisualElement>{
            var result:Vector.<IVisualElement> = new Vector.<IVisualElement>();
            if( container is Group ){
                getElements(container as Group, result);
            }
            return result;
        }
        
        private static function getElements(group:Group,result:Vector.<IVisualElement>):void{
            if( group == null ){
                return;
            }
            var numElements:int = group.numElements;
            var element:IVisualElement;
            var component:UIComponent;
            var accName:String;
            var childGroupAccName:String;
            for( var i:int = 0; i < numElements; i++ ){
                element = group.getElementAt(i);
                if( bridge.isComponent(element)){
                    result.push(element);
                    
                    if( element is Group && !namingConvention.isViewClassName(getCanonicalName(element))){                        
                        getElements( element as Group, result );
                    }
                }
            }
        }
    }
}