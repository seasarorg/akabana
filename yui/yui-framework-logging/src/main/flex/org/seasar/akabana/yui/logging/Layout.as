package org.seasar.akabana.yui.logging
{
    public interface Layout
    {
        function format( event:LoggingEvent ):String;

        function get header():String;
        function set header( value:String ):void;

        function get footer():String;
        function set footer( value:String ):void;
    }
}