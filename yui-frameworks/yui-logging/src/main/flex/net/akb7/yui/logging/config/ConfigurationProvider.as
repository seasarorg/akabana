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
package net.akb7.yui.logging.config
{
    import net.akb7.yui.core.error.ClassNotFoundError;
    import net.akb7.yui.core.reflection.ClassRef;
    import net.akb7.yui.logging.config.factory.DefaultConfigurationFactory;
    import net.akb7.yui.logging.config.factory.IConfigurationFactory;

    [ExcludeClass]
    public class ConfigurationProvider{

        public static const FACTORY_CLASS_NAME:String = "org.seasar.akabana.yui.logging.config.factory.ConfigurationFactory";

        public static function createConfiguration():Configuration{
            var configuration:Configuration = loadConfiguration();

            return configuration;

        }

        private static function loadConfiguration():Configuration{
            var configuration:Configuration;
            var factory:IConfigurationFactory;
            var factoryClass:Class = null;

            try{
                factoryClass = ClassRef.classLoader.findClass(FACTORY_CLASS_NAME);
                if( factoryClass != null ){
                    factory = new factoryClass();
                    configuration = factory.create();
                }
            } catch( e:Error ){
                e.message = "Logging ConfigurationFactory is faild.\n" + e.message;
                trace(e.getStackTrace());
            } finally {
                if( configuration == null ){
                    factory = new DefaultConfigurationFactory();
                    configuration = factory.create();
                }
            }

            return configuration;
        }
    }
}