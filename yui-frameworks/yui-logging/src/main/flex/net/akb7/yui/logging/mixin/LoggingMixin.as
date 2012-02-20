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
package net.akb7.yui.logging.mixin
{
    import flash.net.registerClassAlias;
    
    import mx.core.IFlexModuleFactory;
    
    import net.akb7.yui.logging.LogManager;
    import net.akb7.yui.logging.LoggerFactory;
    import net.akb7.yui.logging.config.ConfigurationProvider;
    import net.akb7.yui.logging.config.factory.LogConfigurationFactory;

    [ExcludeClass]
    [Mixin]
    /**
     * LogginMixin初期設定用Mixinクラス
     *
     * @author $Author: e1arkw $
     * @version $Revision: 1316 $
     */
    public class LoggingMixin{
        {
            LogConfigurationFactory;
            registerClassAlias(ConfigurationProvider.FACTORY_CLASS_NAME,LogConfigurationFactory);
            registerClassAlias("org.seasar.akabana.yui.logging.LoggerFactory",LoggerFactory);
        }

        public static function init( flexModuleFactory:IFlexModuleFactory ):void{            
            LogManager.init();
        }
    }
}