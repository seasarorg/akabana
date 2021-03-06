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
package jp.akb7.yui.core.mixin
{
    import __AS3__.vec.Vector;
    
    import flash.display.DisplayObject;
    import flash.net.registerClassAlias;
    
    import mx.core.IFlexModuleFactory;
    import mx.managers.ISystemManager;
    
    import jp.akb7.yui.YuiFrameworkGlobals;
    import jp.akb7.yui.bridge.FrameworkBridge;
    import jp.akb7.yui.core.YuiFrameworkController;
    import jp.akb7.yui.core.ns.yui_internal;

    [ExcludeClass]
    [Mixin]
    [ResourceBundle("conventions")]
    /**
     * YuiFramework初期設定用Mixinクラス
     *
     * @author $Author$
     * @version $Revision$
     */
    public final class YuiFrameworkMixin
    {
        private static var _this:YuiFrameworkMixin;

        private static var _container:YuiFrameworkController;

        public static function init( flexModuleFactory:IFlexModuleFactory ):void{            
            _this = new YuiFrameworkMixin();
            _container = new YuiFrameworkController();
            YuiFrameworkGlobals.yui_internal::setFrameworkBridge( FrameworkBridge.initialize() );

            if( flexModuleFactory is ISystemManager ){
                var systemManager_:ISystemManager = flexModuleFactory as ISystemManager;
                var root:DisplayObject = systemManager_ as DisplayObject;
                _container.yui_internal::systemManagerMonitoringStart(root);
            }
        }
    }
}