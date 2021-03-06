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
package jp.akb7.yui.convention
{
    import flash.display.DisplayObject;
    
    import mx.core.UIComponent;
    
    import jp.akb7.yui.util.StringUtil;

    [ExcludeClass]
    public final class Flex4NamingConvention extends NamingConvention {
        
        public override function getComponentName( target:DisplayObject ):String{
            var component:UIComponent = target as UIComponent;
            var componentName:String = null;
            if( component != null ){
                componentName = component.id;
                if( componentName == null ){
                    componentName = component.name;
                }
            }
            return componentName;
        }
    }
}