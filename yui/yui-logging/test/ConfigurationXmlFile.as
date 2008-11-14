package org.seasar.akabana.yui.logging.config
{
    internal class ConfigurationXmlFile
    {

        [Embed(source='log4yui.xml', mimeType='application/octet-stream')]
        private static const log4yuiConfigXml:Class;
                
        public static function parse():void{
            
        }
    }
}