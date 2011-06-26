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
package org.seasar.akabana.yui.framework
{
CONFIG::FP10{
    import __AS3__.vec.Vector;
}

    import mx.core.IFactory;
    import mx.resources.ResourceManager;
    import mx.core.ClassFactory;
    import mx.core.IFactory;
    import mx.core.IFlexModuleFactory;
    import mx.managers.ISystemManager;
    import mx.resources.ResourceManager;
    import mx.styles.CSSStyleDeclaration;
    import mx.styles.IStyleManager2;

    import org.seasar.akabana.yui.core.ns.yui_internal;
    import org.seasar.akabana.yui.framework.bridge.FrameworkBridge;
    import org.seasar.akabana.yui.framework.convention.NamingConvention;
    import org.seasar.akabana.yui.framework.util.StyleManagerUtil;
    import org.seasar.akabana.yui.framework.core.YuiFrameworkSettings;
    
    use namespace yui_internal;

    [ExcludeClass]
    public class YuiFrameworkGlobals
    {
        private static var _frameworkBridge:FrameworkBridge;

        public static function get frameworkBridge():FrameworkBridge{
            return _frameworkBridge;
        }

        yui_internal static function set frameworkBridge(value:FrameworkBridge):void{
            _frameworkBridge = value;
        }

        private static var _namingConvention:NamingConvention;

        public static function get namingConvention():NamingConvention{
            return _namingConvention;
        }

        yui_internal static function set namingConvention( value:NamingConvention ):void{
            _namingConvention = value;
        }
		
		private static var _settings:YuiFrameworkSettings;
		
		public static function get settings():YuiFrameworkSettings{
            return _settings;
        }
        
        yui_internal static function set settings(value:YuiFrameworkSettings):void{
            _settings = value;
        }
		
        private static var _namingConventionClassFactory:IFactory;

        yui_internal static function initNamingConventionClassFactory():void{
            var styleManager:IStyleManager2 = StyleManagerUtil.getStyleManager();
            var namingConventionClassFactoryDef:CSSStyleDeclaration = styleManager.getStyleDeclaration("org.seasar.akabana.yui.framework.core.YuiFrameworkSettings");
            if( namingConventionClassFactoryDef == null ){
                _namingConventionClassFactory = new ClassFactory(NamingConvention);
            } else {
                var classFactory:Class = namingConventionClassFactoryDef.getStyle("namingConventionClass") as Class;
                _namingConventionClassFactory = new ClassFactory(classFactory);
            }
        }

        yui_internal static function initNamingConvention():void{
            initNamingConventionClassFactory();

            var namingConvention:NamingConvention = _namingConventionClassFactory.newInstance() as NamingConvention;
CONFIG::FP9{
            namingConvention.conventions = ResourceManager.getInstance().getStringArray("conventions","package");
}
CONFIG::FP10{
            namingConvention.conventions = Vector.<String>(ResourceManager.getInstance().getStringArray("conventions","package"));
}
            YuiFrameworkGlobals.yui_internal::namingConvention = namingConvention;
        }
    }
}