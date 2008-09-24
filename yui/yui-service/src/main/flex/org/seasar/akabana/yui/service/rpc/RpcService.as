package org.seasar.akabana.yui.service.rpc
{
    import org.seasar.akabana.yui.service.Operation;
    import org.seasar.akabana.yui.service.Service;

    public interface RpcService extends Service
    {
        function addOperation( operationName:String ):void;
        
        function getOperation( operationName:String ):Operation;
        
        function hasOperation( operationName:String ):Boolean;
    }
}