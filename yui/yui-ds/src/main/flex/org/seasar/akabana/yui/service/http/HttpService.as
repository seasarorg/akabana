package org.seasar.akabana.yui.service.http
{
    import flash.utils.Dictionary;
    import flash.utils.flash_proxy;
    import flash.utils.getTimer;
    
    import mx.core.Container;
    import mx.core.UIComponent;
    import mx.core.mx_internal;
    import mx.events.FlexEvent;
    import mx.rpc.AsyncToken;
    import mx.rpc.http.mxml.HTTPMultiService;
    
    import org.seasar.akabana.yui.service.DsPendingCall;
    import org.seasar.akabana.yui.service.OperationWatcher;
    import org.seasar.akabana.yui.service.PendingCall;
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.ServiceManager;
    
    use namespace flash_proxy;
    use namespace mx_internal;
    
    public dynamic class HttpService extends HTTPMultiService implements Service
    {
        
        private var _responderOwner:Object;
        
        private var _isInitialzed:Boolean;
        
        private var _pendingCallMap:Dictionary;
        
        private var _name:String;
                
        public function get name():String
        {
            return _name;
        }
        
        public function set name(value:String):void
        {
            _name = value;
        }
        
        public function HttpService(rootURL:String=null, destination:String=null)
        {
            super(rootURL, destination);
            _pendingCallMap = new Dictionary();
        }

        public override function initialized(document:Object, id:String):void
        {
            super.initialized(document,id);
            
            ServiceManager.addService( this );
        }
        
        public function deletePendingCallOf(responder:Object):void{
            for( var item:* in _pendingCallMap ){
                var pc:DsPendingCall = item as DsPendingCall;
                if( pc != null && pc.getResponder() === responder){
                    pc.clear();
                }
            }
        }
        
        public function deleteCallHistory(pc:PendingCall):void{
            if( pc != null ){
                _pendingCallMap[ pc ] = null;
                delete _pendingCallMap[ pc ];
            }
        }
        
        protected function internalInvoke(operationName:String,args:Array):DsPendingCall{
            var asyncToken:AsyncToken = super.callProperty.apply(null, [operationName].concat(args));
            asyncToken.message.destination = destination;
            var result:DsPendingCall = new DsPendingCall(asyncToken.message);
            result.setInternalAsyncToken(asyncToken,getOperation(operationName));
            
            if( OperationWatcher.invokeCallBack != null ){
                OperationWatcher.invokeCallBack.apply(null,[this.name+"."+operationName,args]);
            }
            if( result != null ){
                _pendingCallMap[ result ] = getTimer();
            }
            return result;
        }
        
        flash_proxy override function callProperty(name:*, ... args:Array):*{
            return internalInvoke((name as QName).localName,args);
        }
    }
}