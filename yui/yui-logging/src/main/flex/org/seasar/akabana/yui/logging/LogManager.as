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
package org.seasar.akabana.yui.logging
{   
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.logging.config.AppenderConfig;
    import org.seasar.akabana.yui.logging.config.CategoryConfig;
    import org.seasar.akabana.yui.logging.config.Configuration;
    import org.seasar.akabana.yui.logging.config.ConfigurationProvider;
    import org.seasar.akabana.yui.logging.config.LayoutConfig;
    import org.seasar.akabana.yui.logging.config.ParamConfig;
    
    public class LogManager
    {
        private static var CACHE:Object= {};
        
        private static var APPENDER_CACHE:Object= {};
        
        private static var CATEGORY_CACHE:Object= {};
        
        private static var CATEGORY_NAME:Array = [];
        
        private static var ROOT_LOGGER:Category;
        
        private static var VALUE:String = "value";
        
        private static const logManager:LogManager = new LogManager();
        
        public static function init():void{
            YuiLoggingClasses;
            logManager.init(ConfigurationProvider.createConfiguration());
        }
        
        public static function getLogger( targetClass:Class ):Logger{
            return logManager.getLogger( targetClass );
        }
        
        private final function init(configuration:Configuration):void{    
            configure( configuration );
        }
        
        private final function configure( configuration:Configuration ):void{
            configureAppenders( configuration.appenderMap );
            configureRootLogger( configuration.root );
            configureCategories(configuration.categoryMap);
            
            CATEGORY_NAME.sort(Array.DESCENDING);
        }
        
        private final function configureAppenders( appenderConfigMap:Object ):void{
            var appender:Appender;
            for each( var appenderConfig:AppenderConfig in appenderConfigMap ){
                var appenderClass:Class = appenderConfig.clazz;
                appender = new appenderClass() as Appender;
                
                if( appender != null ){
                    appender.layout = configureLayout( appenderConfig.layout);                    
                }
                
                APPENDER_CACHE[ appenderConfig.name ] = appender;
            }
        }

        private final function configureLayout( layoutConfig:LayoutConfig ):Layout{
            var layout:Layout = ClassRef.getReflector(layoutConfig.clazz).newInstance() as Layout;
            
            for each( var param:ParamConfig in layoutConfig.paramMap ){
                if( Object(layout).hasOwnProperty( param.name )){
                    layout[ param.name ] = param.value;
                }
            }
            
            return layout;
        }
        
        private final function configureRootLogger( categoryConfig:CategoryConfig ):void{
            ROOT_LOGGER = configureCategory( categoryConfig );
        }
        
        private final function configureCategory( categoryConfig:CategoryConfig ):Category{
            var category:Category = ClassRef.getReflector(categoryConfig.clazz).newInstance() as Category;
            category.level = Level.getLevel(categoryConfig.level.value);

            category.appender = APPENDER_CACHE[categoryConfig.appenderRef] as Appender;
            
            CATEGORY_NAME.push( categoryConfig.name );
            CATEGORY_CACHE[ categoryConfig.name ] = category;
            
            return category;
        }

        private final function configureCategories( categoryConfigMap:Object ):void{
            for each( var categoryConfig:CategoryConfig in categoryConfigMap ){
                configureCategory( categoryConfig );
            }
        }
        
        private final function getLogger( targetClass:Class ):Logger{
            
            var fullClassName:String = ClassRef.getQualifiedClassName(targetClass);
            var logger_:Logger = CACHE[ fullClassName ];
            
            if( logger_ == null ){
                
                var category:Category = null;
                for each( var categoryName:String in CATEGORY_NAME ){
                    if( fullClassName.indexOf(categoryName) == 0 ){
                        category = CATEGORY_CACHE[ categoryName ];
                        break;
                    }
                }
                if( category == null ){
                    category = ROOT_LOGGER;
                }
                
                logger_ = new Logger();
                logger_.name = fullClassName.substring(fullClassName.lastIndexOf(".")+1);
                logger_.level = category.level;
                logger_.appender = category.appender;
                
                CACHE[ fullClassName ] = logger_;
            }
                        
            return logger_;
        }
    }
}