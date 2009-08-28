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
    import mx.resources.ResourceBundle;
    
    import org.seasar.akabana.yui.logging.config.Configuration;

    public class LogConfigurationFactory implements IConfigurationFactory {

        [ResourceBundle("log4yui")]
        private static var propertiesConfigFile:ResourceBundle;
        
        public function create():Configuration{
            var configuration:Configuration;
            if( hasConfiguration() ){
                configuration = PropertiesConfigurationBuilder.create(propertiesConfigFile);
            }
            return configuration;
        }
        
        private function hasConfiguration():Boolean{
			return propertiesConfigFile.content.hasOwnProperty(PropertiesConfigurationBuilder.LOG4YUI_ROOT_LOGGER);        	
        }
        
    }
}