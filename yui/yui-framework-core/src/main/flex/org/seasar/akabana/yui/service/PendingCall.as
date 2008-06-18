package org.seasar.akabana.yui.service
{
    public interface PendingCall
    {
        function addResponder( responder:Responder ):void;
        
        function addResponceHandler( resultHandler:Function, faultFunction:Function ):void;

        function onResult( result:* ):void;
        
        function onStatus( status:* ):void;
    }
}