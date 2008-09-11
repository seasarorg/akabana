package org.seasar.akabana.yui.mx.util
{
    import mx.formatters.DateFormatter;
    
    public class DateFormatterUtil
    {
        private static var dateFormatter:DateFormatter = new DateFormatter();
        
        public static function format( value:Date, format:String):String{
            dateFormatter.formatString = format;
            return dateFormatter.format(value);
        }

    }
}