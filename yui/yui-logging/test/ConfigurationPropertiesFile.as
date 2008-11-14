package org.seasar.akabana.yui.logging.config
{
    import mx.resources.ResourceBundle;
    
    internal class ConfigurationPropertiesFile
    {

        [ResourceBundle("log4yui")]
        private static var defaultProperties:ResourceBundle;
                
        public static function parse():void{
            
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