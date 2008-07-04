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
    import mx.resources.ResourceBundle;
    import mx.utils.StringUtil;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.logging.category.SimpleCategory;
    
    public class LogManager
    {
        
        [ResourceBundle("log4yui")]
        private static var defaultProperties:ResourceBundle;

        private static var CACHE:Object= {};
        
        private static var APPENDER_CACHE:Object= {};
        
        private static var CATEGORY_CACHE:Object= {};
        
        private static var CATEGORY_NAME:Array = [];
        
        private static var ROOT_LOGGER:Category;
        
        private static var VALUE:String = "value";
        
        private static const logManager:LogManager = new LogManager();
        
        public static function init():void{
            YuiLoggingClasses;
            logManager.init(defaultProperties.content);
        }
        
        public static function getLogger( targetClass:Class ):Logger{
            return logManager.getLogger( targetClass );
        }
        
        private final function init(propertyMap:Object):void{    
            var configTree:Object = parsePropertyMap( propertyMap );
            configure( configTree );
        }
        
        private final function configure( configTree:Object ):void{
            configureAppender( configTree[LoggingConsts.APPENDER] );
            configureRootLogger( configTree[LoggingConsts.ROOT_LOGGER] );
            doWalkCategoryTree("",configTree[LoggingConsts.CATEGORY]);
            CATEGORY_NAME = CATEGORY_NAME.sort(Array.DESCENDING);
        }
        
        private final function configureAppender( appenderConfigTree:Object ):void{
            var appender:Appender;
            for( var key:String in appenderConfigTree ){
                
                var appenderConfig:Object = appenderConfigTree[ key ];
                
                var classRef:ClassRef = ClassRef.getReflector(appenderConfig[VALUE]);
                appender = classRef.getInstance() as Appender;
                
                if( appender != null ){
                    appender.layout = configureAppenderLayout( appenderConfig[ LoggingConsts.LAYOUT ] );                    
                }
                
                appender.name = key;
                APPENDER_CACHE[ key ] = appender;
            }
        }

        private final function configureAppenderLayout( layoutConfig:Object ):Layout{
            var classRef:ClassRef = ClassRef.getReflector(layoutConfig[VALUE]);
            var layout:Layout = classRef.getInstance() as Layout;
            
            for each( var propRef:PropertyRef in classRef.properties ){
                if( propRef.isWriteable ){
                    if( layoutConfig.hasOwnProperty( propRef.name )){
                        layout[ propRef.name ] = layoutConfig[ propRef.name ][VALUE];
                    }
                }
            }
            
            return layout;
        }
        
        private final function configureRootLogger( rootLoggerConfig:Object ):void{
            ROOT_LOGGER = configureCategory( LoggingConsts.ROOT_LOGGER, rootLoggerConfig[VALUE] as String );
        }
        
        private final function configureCategory( packeageName:String, info:String ):Category{
            var value:String = info;
            var category:Category = new SimpleCategory();
            var values:Array = value.split(",");
            if( values.length > 0 ){
                category.level = Level.getLevel(values[0]);
            } else {
                category.level = ROOT_LOGGER.level;
            }
            if( values.length > 1 ){
                category.addAppender(APPENDER_CACHE[StringUtil.trim(values[1])]);
            } else {
                var rootAppenderNum:int = ROOT_LOGGER.appenderCount;
                for( var i:int = 0; i < rootAppenderNum; i++ ){
                    category.addAppender(ROOT_LOGGER.getAppenderAt(i));
                }
            }
            category.name = packeageName;
            CATEGORY_NAME.push( packeageName );
            CATEGORY_CACHE[ packeageName ] = category;
            
            return category;
        }

        private final function doWalkCategoryTree( packeageName:String, categoryConfigTree:Object ):void{
            for( var key:String in categoryConfigTree ){
                if( key != VALUE ){
                    doWalkCategoryTree(
                        packeageName.length > 0 ? packeageName+"."+key : key,
                        categoryConfigTree[key]
                    );
                } else {
                    configureCategory( packeageName, categoryConfigTree[key]);
                }
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
                var appenderNum:int = category.appenderCount;
                for( var i:int = 0; i < appenderNum; i++ ){
                    logger_.addAppender(category.getAppenderAt(i));
                }
                
                CACHE[ fullClassName ] = logger_;
            }
                        
            return logger_;
        }

        private final function parsePropertyMap(propertyMap:Object):Object{
            var configTree:Object = {};
            for( var key:String in propertyMap ){
                var attrs:Array = key.split(".");
                var temp:Object = configTree;
                for( var i:int = 1; i < attrs.length; i++ ){
                    var attr:String = attrs[i];
                    if( !temp.hasOwnProperty(attr)){
                        temp[ attr ] = {};
                    }
                    temp = temp[ attr ];
                    if( temp is String ){
                        
                    }
                }
                temp["value"] = propertyMap[ key ]
            }
            return configTree;
        }
    }
}