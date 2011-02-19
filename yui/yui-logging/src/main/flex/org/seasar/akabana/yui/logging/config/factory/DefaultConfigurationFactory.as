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
    import org.seasar.akabana.yui.logging.appender.SimpleAppender;
    import org.seasar.akabana.yui.logging.category.SimpleCategory;
    import org.seasar.akabana.yui.logging.config.AppenderConfig;
    import org.seasar.akabana.yui.logging.config.CategoryConfig;
    import org.seasar.akabana.yui.logging.config.Configuration;
    import org.seasar.akabana.yui.logging.config.LayoutConfig;
    import org.seasar.akabana.yui.logging.config.LevelConfig;
    import org.seasar.akabana.yui.logging.config.ParamConfig;
    import org.seasar.akabana.yui.logging.layout.BasicPatternLayout;

    [ExcludeClass]
    public class DefaultConfigurationFactory implements IConfigurationFactory{

        public function create():Configuration {

            var infoLevel:LevelConfig = new LevelConfig();
            infoLevel.value = "INFO";

            var debugLevel:LevelConfig = new LevelConfig();
            debugLevel.value = "DEBUG";

            var param:ParamConfig = new ParamConfig();
            param.name = "pattern";
            param.value = "%d [%c] %l - %m%t";

            var detailParam:ParamConfig = new ParamConfig();
            param.name = "pattern";
            param.value = "%d(%t)[%c] %l - %m%t";

            var layout:LayoutConfig = new LayoutConfig();
            layout.clazz = BasicPatternLayout;
            layout.paramMap[ param.name ] = param;

            var appender:AppenderConfig = new AppenderConfig();
            appender.name = "TRACE1";
            appender.clazz = SimpleAppender;
            appender.layout = layout;

            var detailAppender:AppenderConfig = new AppenderConfig();
            detailAppender.name = "TRACE2";
            detailAppender.clazz = SimpleAppender;
            detailAppender.layout = layout;

            var category:CategoryConfig = new CategoryConfig();
            category.name = "org.seasar.akabana.yui";
            category.clazz = SimpleCategory;
            category.level = debugLevel;
            category.appenderRef = "TRACE2";

            var root:CategoryConfig = new CategoryConfig();
            root.clazz = SimpleCategory;
            root.level = infoLevel;
            root.appenderRef = "TRACE1";

            var configuration:Configuration = new Configuration();
            configuration.appenderMap[ appender.name ] = appender;
            configuration.appenderMap[ detailAppender.name ] = detailAppender;
            configuration.categoryMap[ category.name ] = category;
            configuration.root = root;

            return configuration;
        }

    }
}