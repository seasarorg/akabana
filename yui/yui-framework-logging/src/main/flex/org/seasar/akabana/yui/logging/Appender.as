package org.seasar.akabana.yui.logging
{
    public interface Appender
    {
        function get name():String;
        function set name( value:String ):void;

        function get layout():Layout;
        function set layout( value:Layout ):void;

        function close():void;
        
        function append( event: LoggingEvent ):void;
        
    }
}