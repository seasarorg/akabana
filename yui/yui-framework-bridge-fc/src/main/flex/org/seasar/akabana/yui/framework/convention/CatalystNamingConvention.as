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
    
    import mx.core.UIComponent;
    
    import org.seasar.akabana.yui.util.StringUtil;

    [ExcludeClass]
    public final class CatalystNamingConvention extends NamingConvention {
        
        public override function getComponentName( target:DisplayObject ):String{
            var component:UIComponent = target as UIComponent;
            var componentName:String = null;
            if( component != null ){
                do{
                    {
                        if( component.id != null ){
                            componentName = component.id;
                            break;                        
                        }
                    }
                    {
                        var accName:String = component.accessibilityName;
                        if( accName != null && accName.length > 0 ){
                            componentName = component.name = accName;
                            break;
                        }
                    }
                    {
                        var skinClass:String = getCanonicalName(component.getStyle("skinClass"));
                        if( skinClass != null && skinClass.indexOf("components") == 0 ){
                            skinClass = StringUtil.toLowerCamel(skinClass.replace(/components\./,""));
                            componentName = component.name = skinClass;
                            break;
                        }
                    }
                    {
                        componentName = component.name;
                    }
                }while(false);
            }
            return componentName;
        }

        protected override function checkClassFullName( className:String, packageName:String, suffix:String ):Boolean{
            if( className.indexOf("components") == 0 ){
                return super.checkClassFullName(className.replace(/components/,_conventions[0]+"."+VIEW),packageName,suffix);
            } else {
                return super.checkClassFullName(className,packageName,suffix);
            }
        }

        protected override function checkVarName( varName:String, suffix:String ):Boolean{
            if( varName.indexOf("components") == 0 ){
                return super.checkVarName(varName,suffix);
            } else {
                return super.checkVarName(varName,suffix);
            }
        }

        protected override function changeViewPackageTo( className:String, packageName:String, suffix:String ):String{
            if( className.indexOf("components") == 0 ){
                return super.changeViewPackageTo(className.replace(/components/,_conventions[0]+"."+VIEW),packageName,suffix);
            } else {
                return super.changeViewPackageTo(className,packageName,suffix);
            }
        }
    }
}