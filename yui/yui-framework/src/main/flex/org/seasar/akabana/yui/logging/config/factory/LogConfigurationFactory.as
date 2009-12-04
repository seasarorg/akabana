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
    
    import mx.resources.IResourceManager;
    import mx.resources.ResourceBundle;
    import mx.resources.ResourceManager;
    
    import org.seasar.akabana.yui.logging.config.Configuration;
	
	[ResourceBundle("log4yui")]
    public class LogConfigurationFactory implements IConfigurationFactory {

        [ResourceBundle("log4yui")]
        private static var propertiesConfigFile:ResourceBundle;
        
        public function create():Configuration{
            if( propertiesConfigFile == null ){
    			var resourceManager:IResourceManager = ResourceManager.getInstance();
    			var localeChain:Array = resourceManager.localeChain;
    			var configuration:Configuration;
    			if( localeChain != null && localeChain.length > 0 ){
    			    propertiesConfigFile = resourceManager.getResourceBundle(localeChain[0],"log4yui") as ResourceBundle;
    			} else {
    			    propertiesConfigFile = resourceManager.getResourceBundle(null,"log4yui") as ResourceBundle;
    			    if( propertiesConfigFile == null ){
    			        throw new IllegalOperationError("NOT FOUND log4yui.properties");
    			    }
    			}
            }
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