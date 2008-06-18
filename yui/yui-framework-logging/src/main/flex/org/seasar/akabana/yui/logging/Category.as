package org.seasar.akabana.yui.logging
{
    public interface Category
    {
        function get name():String;
        function set name( value:String ):void;

        function get level():Level;
        function set level( value:Level ):void;
        
        function get appenderCount():int;
        
        function addAppender( appender:Appender ):void;
        function removeAppender( appender:Appender ):void;
    }
}