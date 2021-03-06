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
package jp.akb7.yui.logging
{
    import flash.errors.IllegalOperationError;
    import flash.utils.getDefinitionByName;
    
    import mx.core.ClassFactory;
    import mx.core.IFactory;
    
    import jp.akb7.yui.core.ClassLoader;
    import jp.akb7.yui.core.reflection.ClassRef;
    import jp.akb7.yui.core.YuiFrameworkController;
    import jp.akb7.yui.core.logging.ILogger;
    import jp.akb7.yui.core.logging.ILoggerFactory;
    
    public final class Logging {
        
        private static const DEFAULT_LOGGER_FACTORY:ILoggerFactory = new SimpleLoggerFactory();
        
        private static var _loggerFactory:ILoggerFactory;
        
        public static function getLogger(target:Object):ILogger{
            return _loggerFactory.getLogger(target);
        }
        
        public static function initialize():void{
            var clazz:Class = null;
            try{
                clazz = findClass("org.seasar.akabana.yui.logging.LoggerFactory");
            } catch( e:Error ){
            }
            if( clazz == null ){
                _loggerFactory = DEFAULT_LOGGER_FACTORY;
            } else {
                _loggerFactory = new clazz() as ILoggerFactory;
            }
        }
    }
}