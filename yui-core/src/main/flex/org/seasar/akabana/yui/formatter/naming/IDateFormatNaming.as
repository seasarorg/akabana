package org.seasar.akabana.yui.formatter.naming
{
    public interface IDateFormatNaming {

        function getMonthShort(month:int):String;

        function getMonthLong(month:int):String;

        function getDayShort(day:int):String;

        function getDayLong(day:int):String;
        
        function getTimeSection(time:int):String;        
    }
}