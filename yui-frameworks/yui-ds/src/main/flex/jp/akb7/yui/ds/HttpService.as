/*
* Copyright 2004-2011 the Seasar Foundation and the Others.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
* either express or implied. See the License for the specific language
* governing permissions and limitations under the License.
*/
package jp.akb7.yui.ds
{
    import flash.utils.Dictionary;
    import flash.utils.flash_proxy;
    import flash.utils.getTimer;
    
    import mx.core.IMXMLObject;
    import mx.core.mx_internal;
    import mx.rpc.AbstractOperation;
    import mx.rpc.AsyncToken;
    import mx.rpc.http.HTTPMultiService;
    
    import jp.akb7.yui.service.IManagedService;
    import jp.akb7.yui.service.OperationCallBack;
    import jp.akb7.yui.service.IPendingCall;
    import jp.akb7.yui.service.IService;
    import jp.akb7.yui.service.ServiceGatewayUrlResolver;
    import jp.akb7.yui.service.ServiceManager;
    import jp.akb7.yui.ds.local.LocalOperation;
    
    use namespace flash_proxy;
    use namespace mx_internal;
    
    public dynamic class HttpService extends HTTPMultiService implements IManagedService, IMXMLObject {
        
        private var _responderOwner:Object;
        
        private var _isInitialzed:Boolean;
        
        private var _pendingCallMap:Dictionary;
        
        private var _name:String;
                
        public function get name():String{
            return _name;
        }
        
        public function set name(value:String):void{
            _name = value;
        }
        
        public function HttpService(rootURL:String=null, destination:String=null){
            super(rootURL, destination);
            _pendingCallMap = new Dictionary();
        }
        
        public function initialized(document:Object, id:String):void{
            if( baseURL == null && name != null){
                baseURL = ServiceGatewayUrlResolver.resolve( name );
            }
            ServiceManager.addService( this );
        }
        
        public override function getOperation(name:String):AbstractOperation{
            var opeObj:Object = _operations[name];
            var ope:AbstractOperation = null;
            if( opeObj != null && opeObj is AbstractOperation){
                ope = opeObj as AbstractOperation; 
            }
            if (ope == null)
            {
                if( baseURL == null ){
                    baseURL = ServiceGatewayUrlResolver.resolve( destination );
                }
                if( ServiceGatewayUrlResolver.isLocalUrl(baseURL) ){
                    ope = new LocalOperation(this, name, baseURL);
                    _operations[name] = ope;
                } else {
                    ope = super.getOperation(name);
                }
            }
            return ope;
        }
        
        public function finalizeResponder(responder:Object):void{
            for( var item:* in _pendingCallMap ){
                var pc:DsPendingCall = item as DsPendingCall;
                if( pc != null && pc.getResponder() === responder){
                    pc.clear();
                }
            }
        }
        
        public function finalizePendingCall(pc:IPendingCall):void{
            if( pc != null ){
                _pendingCallMap[ pc ] = null;
                delete _pendingCallMap[ pc ];
            }
        }
        
        public function invokeMethod(name:String,args:Array):IPendingCall{
            return internalInvoke(name,args);
        }
        
        protected function internalInvoke(operationName:String,args:Array):DsPendingCall{
            if( baseURL == null && name != null){
                baseURL = ServiceGatewayUrlResolver.resolve( name );
            }
            
            var asyncToken:AsyncToken = super.callProperty.apply(null, [operationName].concat(args));
            
            asyncToken.message.destination = destination;
            var result:DsPendingCall = new DsPendingCall(asyncToken.message);
            result.setInternalAsyncToken(asyncToken,getOperation(operationName));
            
            if( OperationCallBack.invokeCallBack != null ){
                OperationCallBack.invokeCallBack.apply(null,[this.name+"."+operationName,args]);
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