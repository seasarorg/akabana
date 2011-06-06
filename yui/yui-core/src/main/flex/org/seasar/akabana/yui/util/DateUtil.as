package org.seasar.akabana.yui.util
{
    public class DateUtil
    {
        private static const _ZERO:String = "0";
        
        public static function getCurrentDateString():String{
            return toDateTimeString(new Date());
        }
        
        public static function toDateString(value:Date,dateDelimiter:String="/"):String{
            return StringUtil.fill(value.fullYear,4,_ZERO) +
                    dateDelimiter +
                    StringUtil.fill(value.month+1,2,_ZERO) +
                    dateDelimiter +
                    StringUtil.fill(value.date,2,_ZERO);
        }
        
        public static function toSimpleTimeString(value:Date,timeDelimiter:String=":"):String{
            return StringUtil.fill(value.hours,2,_ZERO) +
                    timeDelimiter +
                    StringUtil.fill(value.minutes,2,_ZERO) +
                    timeDelimiter +
                    StringUtil.fill(value.seconds,2,_ZERO);
        }
        
        public static function toTimeString(value:Date,timeDelimiter:String=":",msDelimiter:String=","):String{
            return toSimpleTimeString(value,timeDelimiter)+
                    msDelimiter +
                    StringUtil.fill(value.milliseconds,3,_ZERO);
        }
        
        public static function toSimpleDateTimeString(value:Date,dateDelimiter:String="/",dateTimeDelimiter:String=" ",timeDelimiter:String=":"):String{
            return toDateString(value,dateDelimiter) + 
                    dateTimeDelimiter +
                    toSimpleTimeString(value,timeDelimiter);
        }
        
        public static function toDateTimeString(value:Date,dateDelimiter:String="/",dateTimeDelimiter:String=" ",timeDelimiter:String=":",msDelimiter:String=","):String{
            return toDateString(value,dateDelimiter) + 
                    dateTimeDelimiter +
                    toTimeString(value,timeDelimiter,msDelimiter);
        }
    }
}