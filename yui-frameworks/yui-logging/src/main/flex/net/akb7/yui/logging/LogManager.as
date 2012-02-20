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
package net.akb7.yui.logging
{
    import flash.utils.getQualifiedClassName;
    
    import net.akb7.yui.logging.config.AppenderConfig;
    import net.akb7.yui.logging.config.CategoryConfig;
    import net.akb7.yui.logging.config.Configuration;
    import net.akb7.yui.logging.config.ConfigurationProvider;
    import net.akb7.yui.logging.config.LayoutConfig;
    import net.akb7.yui.logging.config.ParamConfig;

    public class LogManager
    {
        private static var CACHE:Object= {};

        private static var APPENDER_CACHE:Object= {};

        private static var CATEGORY_CACHE:Object= {};

        private static var CATEGORY_NAME:Array = [];

        private static var ROOT_LOGGER:ICategory;

        //private static var VALUE:String = "value";

        private static const LOG_MANAGER:LogManager = new LogManager();

        public static function init():void{
            LOG_MANAGER.init(ConfigurationProvider.createConfiguration());
        }

        public static function getLogger( target:Object ):Logger{
            return LOG_MANAGER.getLogger( target );
        }

        public function LogManager(){
        }

        private function init(configuration:Configuration):void{
            configureAppenders( configuration.appenderMap );
            configureRootLogger( configuration.root );
            configureCategories(configuration.categoryMap);

            CATEGORY_NAME.sort(Array.DESCENDING);
        }

        private function configureAppenders( appenderConfigMap:Object ):void{
            var appender:IAppender;
            for each( var appenderConfig:AppenderConfig in appenderConfigMap ){
                var appenderClass:Class = appenderConfig.clazz;
                appender = new appenderClass() as IAppender;

                if( appender != null ){
                    appender.layout = configureLayout( appenderConfig.layout);
                }

                APPENDER_CACHE[ appenderConfig.name ] = appender;
            }
        }

        private function configureLayout( layoutConfig:LayoutConfig ):ILayout{
            var layoutClass:Class = layoutConfig.clazz;
            var layout:ILayout = new layoutClass() as ILayout;

            for each( var param:ParamConfig in layoutConfig.paramMap ){
                if( Object(layout).hasOwnProperty( param.name )){
                    layout[ param.name ] = param.value;
                }
            }

            return layout;
        }

        private function configureRootLogger( categoryConfig:CategoryConfig ):void{
            ROOT_LOGGER = configureCategory( categoryConfig );
        }

        private function configureCategory( categoryConfig:CategoryConfig ):ICategory{
            var categoryClass:Class = categoryConfig.clazz;
            var category:ICategory = new categoryClass() as ICategory;
            category.level = Level.getLevel(categoryConfig.level.value);

            category.appender = APPENDER_CACHE[categoryConfig.appenderRef] as IAppender;

            CATEGORY_NAME.push( categoryConfig.name );
            CATEGORY_CACHE[ categoryConfig.name ] = category;

            return category;
        }

        private function configureCategories( categoryConfigMap:Object ):void{
            for each( var categoryConfig:CategoryConfig in categoryConfigMap ){
                configureCategory( categoryConfig );
            }
        }

        private function getLogger( target:Object ):Logger{
            var fullClassName:String;
            if( target is String ){
                fullClassName = target as String;
            } else {
                fullClassName = getCanonicalName(target);
            }

            var logger_:Logger = CACHE[ fullClassName ];

            if( logger_ == null ){

                var category:ICategory = null;
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