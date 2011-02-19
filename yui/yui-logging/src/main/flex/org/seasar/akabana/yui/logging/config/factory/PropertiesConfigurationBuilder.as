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
package org.seasar.akabana.yui.logging.config.factory
{
    import mx.resources.IResourceBundle;

    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.logging.category.SimpleCategory;
    import org.seasar.akabana.yui.logging.config.AppenderConfig;
    import org.seasar.akabana.yui.logging.config.CategoryConfig;
    import org.seasar.akabana.yui.logging.config.Configuration;
    import org.seasar.akabana.yui.logging.config.LayoutConfig;
    import org.seasar.akabana.yui.logging.config.LevelConfig;
    import org.seasar.akabana.yui.logging.config.ParamConfig;
    import org.seasar.akabana.yui.util.StringUtil;

    internal class PropertiesConfigurationBuilder{

        private static var PREFIX:String = "log4yui.";

        private static var APPENDER:String = "appender";

        private static var CATEGORY:String = "category";

        private static var ROOT_LOGGER:String = "rootLogger";

        private static var LAYOUT:String = "layout";

        private static var VALUE:String = "value";

        public static var LOG4YUI_ROOT_LOGGER:String = PREFIX + ROOT_LOGGER;

        private static var PACKAGE_ROOT:String = "";

        private static var rootCategoryConfig:CategoryConfig;

        private static var currentConfiguration:Configuration;

        public static function create(propertiesFile:IResourceBundle):Configuration{
            currentConfiguration = new Configuration();
            build( parseProperties( propertiesFile.content ) );
            return currentConfiguration;
        }

        private static function build( configTree:Object ):void{
            buildAppender( configTree[APPENDER] );
            buildRootLogger( configTree[ROOT_LOGGER] );
            buildCategories( PACKAGE_ROOT, configTree[CATEGORY] );
        }

        private static function buildRootLogger( rootLogger:Object ):void{
            var categoryConfig:CategoryConfig =
                configureCategory(
                    ROOT_LOGGER, rootLogger[VALUE] as String,
                    SimpleCategory
                    );
            currentConfiguration.root =
                rootCategoryConfig =
                    categoryConfig;
        }

        private static function buildCategories( packeageName:String, categoryConfigTree:Object ):void{
            for( var key:String in categoryConfigTree ){
                if( key != VALUE ){
                    buildCategories(
                        packeageName.length > 0 ? packeageName+"."+key : key,
                        categoryConfigTree[key]
                    );
                } else {
                    var categoryConfig:CategoryConfig =
                        configureCategory(
                            packeageName,
                            categoryConfigTree[key],
                            rootCategoryConfig.clazz
                            );

                    currentConfiguration.categoryMap[ categoryConfig.name ] = categoryConfig;
                }
            }
        }

        private static function configureCategory( packeageName:String, info:String, categoryClass:Class=null):CategoryConfig{
            var categoryConfig:CategoryConfig = new CategoryConfig();
            var infoSplits:Array = info.split(",");
            //level
            if( infoSplits.length > 0 ){
                categoryConfig.level = new LevelConfig();
                categoryConfig.level.value = StringUtil.trim(infoSplits[0]);
            } else {
                categoryConfig.level = rootCategoryConfig.level;
            }
            //appender
            if( infoSplits.length > 1 ){
                categoryConfig.appenderRef = StringUtil.trim(infoSplits[1]);
            } else {
                categoryConfig.appenderRef = rootCategoryConfig.appenderRef;
            }
            //name
            categoryConfig.name = packeageName;
            //class
            if( categoryClass != null ){
                categoryConfig.clazz = categoryClass;
            }

            return categoryConfig;
        }

        private static function buildAppender( appenderConfigTree:Object ):void{
            var appenderConfig:AppenderConfig;
            var appender_:Object;
            for( var key:String in appenderConfigTree ){
                appender_ = appenderConfigTree[ key ];

                appenderConfig = new AppenderConfig();
                appenderConfig.clazz = ClassRef.classLoader.findClass(appender_[VALUE]);
                appenderConfig.name = key;
                appenderConfig.layout = configureLayout( appender_[ LAYOUT ] );

                currentConfiguration.appenderMap[ key ] = appenderConfig;
            }
        }

        private static function configureLayout( layout:Object ):LayoutConfig{
            var layoutConfig:LayoutConfig = new LayoutConfig();
            layoutConfig.clazz = ClassRef.classLoader.findClass(layout[VALUE]);

            for( var key:String in layout ){
                if( key == VALUE ){
                    continue;
                }
                var parmaConfig:ParamConfig = new ParamConfig();
                parmaConfig.name = key;
                parmaConfig.value = layout[ key ][ VALUE ];
                layoutConfig.paramMap[ key ] = parmaConfig;
            }

            return layoutConfig;
        }

        private static function parseProperties( propertyMap:Object ):Object{
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
                temp[VALUE] = propertyMap[ key ]
            }
            return configTree;
        }

    }
}