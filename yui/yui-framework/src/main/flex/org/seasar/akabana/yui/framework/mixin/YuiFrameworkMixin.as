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
package org.seasar.akabana.yui.framework.mixin
{
CONFIG::FP10{
	import __AS3__.vec.Vector;
}
	import flash.net.registerClassAlias;

	import mx.core.IFlexModuleFactory;
	import mx.managers.ISystemManager;

	import org.seasar.akabana.yui.core.yui_internal;
	import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
	import org.seasar.akabana.yui.framework.bridge.FrameworkBridge;
	import org.seasar.akabana.yui.framework.core.YuiFrameworkContainer;
	import org.seasar.akabana.yui.logging.LogManager;
	import org.seasar.akabana.yui.logging.config.ConfigurationProvider;
	import org.seasar.akabana.yui.logging.config.factory.LogConfigurationFactory;

    [ExcludeClass]
	[Mixin]
	[ResourceBundle("conventions")]
	/**
	 * YuiFramework初期設定用Mixinクラス
	 *
	 * @author $Author$
	 * @version $Revision$
	 */
	public class YuiFrameworkMixin
	{
		{
			LogConfigurationFactory;
			registerClassAlias(ConfigurationProvider.FACTORY_CLASS_NAME,LogConfigurationFactory);
		}

		private static var _this:YuiFrameworkMixin;

		private static var _container:YuiFrameworkContainer;

        public static function init( flexModuleFactory:IFlexModuleFactory ):void{
            LogManager.init();

            _this = new YuiFrameworkMixin();
            _container = new YuiFrameworkContainer();
            YuiFrameworkGlobals.yui_internal::frameworkBridge = FrameworkBridge.initialize();

            if( flexModuleFactory is ISystemManager ){
            	var systemManager_:ISystemManager = flexModuleFactory as ISystemManager;
                _container.yui_internal::monitoringSystemManager(systemManager_);
            }
        }
	}
}