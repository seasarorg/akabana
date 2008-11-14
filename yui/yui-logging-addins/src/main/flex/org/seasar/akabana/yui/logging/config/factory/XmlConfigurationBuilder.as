package org.seasar.akabana.yui.logging.config.factory
{
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.logging.appender.SimpleAppender;
    import org.seasar.akabana.yui.logging.category.SimpleCategory;
    import org.seasar.akabana.yui.logging.config.AppenderConfig;
    import org.seasar.akabana.yui.logging.config.CategoryConfig;
    import org.seasar.akabana.yui.logging.config.Configuration;
    import org.seasar.akabana.yui.logging.config.LayoutConfig;
    import org.seasar.akabana.yui.logging.config.LevelConfig;
    import org.seasar.akabana.yui.logging.config.ParamConfig;
    import org.seasar.akabana.yui.logging.layout.SimpleLayout;
    import org.seasar.akabana.yui.util.StringUtil;
    
    internal class XmlConfigurationBuilder{
        
        private static var ATT_CLASS:String = "@class";
        
        private static var ATT_NAME:String = "@name";
        
        private static var ATT_VALUE:String = "@value";
        
        private static var ATT_REF:String = "@ref";
        
        private static var PREFIX:String = "log4yui.";
        
        private static var APPENDER:String = "appender";
        
        private static var APPENDER_REF:String = "appender-ref";
        
        private static var CATEGORY:String = "category";
        
        private static var ROOT_LOGGER:String = "rootLogger";
        
        private static var ROOT:String = "root";
        
        private static var LEVEL:String = "level";
        
        private static var LAYOUT:String = "layout";
    
        private static var PACKAGE_ROOT:String = "";
        
        private static var rootCategoryConfig:CategoryConfig;
        
        private static var currentConfiguration:Configuration;
            
        public static function create(xml:XML):Configuration{
            currentConfiguration = new Configuration();
            build( xml );
            return currentConfiguration;
        }
    
        private static function build( configTree:XML ):void{
            buildAppender( configTree[APPENDER] );
            buildRootLogger( configTree[ROOT] );
            buildCategories( configTree[CATEGORY] );
        }
    
        private static function buildRootLogger( rootLogger:XMLList ):void{
            var categoryConfig:CategoryConfig = configureCategory(rootLogger[0]);
            categoryConfig.name = ROOT_LOGGER;
            currentConfiguration.root = 
                rootCategoryConfig = 
                    categoryConfig;
        }
    
        private static function buildCategories( categoryConfigTree:XMLList ):void{
            for each( var category:XML in categoryConfigTree ){
                var categoryConfig:CategoryConfig = configureCategory(category);
                currentConfiguration.categoryMap[ categoryConfig.name ] = categoryConfig;
            }
        }
        
        private static function configureCategory( categoryXML:XML ):CategoryConfig{
            var categoryConfig:CategoryConfig = new CategoryConfig();
            //level
            var levelXMLList:XMLList = categoryXML[LEVEL];
            if( levelXMLList.length() > 0 ){
                categoryConfig.level = new LevelConfig();
                categoryConfig.level.value = StringUtil.trim(levelXMLList[0][ATT_VALUE].toString());
            } else {
                categoryConfig.level = rootCategoryConfig.level;
            }
            //appender
            var appenderRefXMLList:XMLList = categoryXML[APPENDER_REF];
            if( appenderRefXMLList.length() > 0 ){
                categoryConfig.appenderRef = StringUtil.trim(appenderRefXMLList[0][ATT_REF].toString());
            } else {
                categoryConfig.appenderRef = rootCategoryConfig.appenderRef;
            }
            //name
            categoryConfig.name = categoryXML[ATT_NAME].toString();
            //class
            var className:String = categoryXML[ATT_CLASS].toString();
            if( className != null && className.length > 0 ){
                categoryConfig.clazz = ClassRef.classLoader.findClass(className);
            } else {
                categoryConfig.clazz = SimpleCategory;
            }
                
            return categoryConfig;
        }
    
        private static function buildAppender( appenderConfigTree:XMLList ):void{
            var appenderConfig:AppenderConfig;
            for each( var appender:XML in appenderConfigTree ){
                appenderConfig = new AppenderConfig();
                appenderConfig.name = appender[ATT_NAME].toString();
                appenderConfig.layout = configureLayout( appender[ LAYOUT ] );                    

                var className:String = appender[ATT_CLASS].toString();
                if( className != null && className.length > 0 ){
                    appenderConfig.clazz = ClassRef.classLoader.findClass(className);
                } else {
                    appenderConfig.clazz = SimpleAppender;
                }
                
                currentConfiguration.appenderMap[ appenderConfig.name ] = appenderConfig;
            }
        }
    
        private static function configureLayout( layoutConfigTree:XMLList ):LayoutConfig{
            var layoutConfig:LayoutConfig = new LayoutConfig();
            if( layoutConfigTree.length() > 0 ){
                var layout:XML = layoutConfigTree[0];

                var className:String = layout[ATT_CLASS].toString();
                if( className != null && className.length > 0 ){
                    layoutConfig.clazz = ClassRef.classLoader.findClass(className);
                } else {
                    layoutConfig.clazz = SimpleLayout;
                }

                for each( var param:XML in layout.param ){
                    var parmaConfig:ParamConfig = new ParamConfig();
                    parmaConfig.name = param[ ATT_NAME ].toString();
                    parmaConfig.value = param[ ATT_VALUE ].toString();
                    
                    layoutConfig.paramMap[ parmaConfig.name ] = parmaConfig;
                }
            }
            return layoutConfig;
        }

    }
}