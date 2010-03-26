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
package org.seasar.akabana.yui.logging.config.factory
{
    import flash.errors.IllegalOperationError;
    import flash.system.ApplicationDomain;

    import mx.managers.ISystemManager;
    import mx.managers.SystemManagerGlobals;
    import mx.resources.IResourceManager;
    import mx.resources.ResourceBundle;
    import mx.resources.ResourceManager;

    import org.seasar.akabana.yui.logging.config.Configuration;

    [ExcludeClass]
    [ResourceBundle("log4yui")]
    public class LogConfigurationFactory implements IConfigurationFactory {

        private static var propertiesConfigFile:ResourceBundle;

        private static function loadResourceBundle(bundleName:String):ResourceBundle {
            var locale:String = getCurrentLocale(SystemManagerGlobals.topLevelSystemManagers[0] as ISystemManager);

            var resourceBundleClassName:String = locale + "$" + bundleName + "_properties";
            var bundleClass:Class = null;
            var appDomain:ApplicationDomain  = ApplicationDomain.currentDomain;

            if(appDomain.hasDefinition(resourceBundleClassName))
            {
                bundleClass = appDomain.getDefinition(resourceBundleClassName) as Class;
            }

            if( !bundleClass ){
                resourceBundleClassName = bundleName + "_properties";

                if(appDomain.hasDefinition(resourceBundleClassName)) {
                    bundleClass = appDomain.getDefinition(resourceBundleClassName) as Class;
                }
            }

            var result:ResourceBundle = new bundleClass() as ResourceBundle;
            return result;
        }

        private static function getCurrentLocale(sm:ISystemManager):String
        {
            var result:String = "en_US";
            var compiledLocales:Array = sm.info()["compiledLocales"];
            if (compiledLocales != null && compiledLocales.length == 1){
                result = compiledLocales[0] as String;
            }
            return result;
        }

        public function create():Configuration {
            if(propertiesConfigFile == null) {
                var resourceManager:IResourceManager = ResourceManager.getInstance();
                var localeChain:Array = resourceManager.localeChain;
                var configuration:Configuration;

                if(localeChain != null && localeChain.length > 0) {
                    propertiesConfigFile = resourceManager.getResourceBundle(localeChain[0],"log4yui") as ResourceBundle;
                } else {
                    propertiesConfigFile = loadResourceBundle("log4yui");

                    if(propertiesConfigFile == null) {
                        throw new IllegalOperationError("NOT FOUND log4yui.properties");
                    }
                }
            }

            if(hasConfiguration()) {
                configuration = PropertiesConfigurationBuilder.create(propertiesConfigFile);
            }
            return configuration;
        }

        private function hasConfiguration():Boolean {
            return propertiesConfigFile.content.hasOwnProperty(PropertiesConfigurationBuilder.LOG4YUI_ROOT_LOGGER);
        }
    }
}