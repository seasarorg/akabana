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
package org.seasar.akabana.yui.service.ds {

    import flash.net.registerClassAlias;
    import flash.utils.Dictionary;
    import flash.utils.flash_proxy;
    import flash.utils.getTimer;
    
    import mx.core.UIComponent;
    import mx.core.mx_internal;
    import mx.events.FlexEvent;
    import mx.messaging.Channel;
    import mx.messaging.ChannelSet;
    import mx.messaging.channels.AMFChannel;
    import mx.messaging.channels.SecureAMFChannel;
    import mx.messaging.config.ConfigMap;
    import mx.messaging.management.Attribute;
    import mx.messaging.management.MBeanAttributeInfo;
    import mx.messaging.management.MBeanConstructorInfo;
    import mx.messaging.management.MBeanFeatureInfo;
    import mx.messaging.management.MBeanInfo;
    import mx.messaging.management.MBeanOperationInfo;
    import mx.messaging.management.MBeanParameterInfo;
    import mx.messaging.management.ObjectInstance;
    import mx.messaging.management.ObjectName;
    import mx.messaging.messages.AcknowledgeMessage;
    import mx.messaging.messages.AcknowledgeMessageExt;
    import mx.messaging.messages.AsyncMessage;
    import mx.messaging.messages.AsyncMessageExt;
    import mx.messaging.messages.CommandMessage;
    import mx.messaging.messages.CommandMessageExt;
    import mx.messaging.messages.ErrorMessage;
    import mx.messaging.messages.MessagePerformanceInfo;
    import mx.messaging.messages.RemotingMessage;
    import mx.rpc.AbstractOperation;
    import mx.rpc.AsyncToken;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.remoting.mxml.RemoteObject;
    
    import org.seasar.akabana.yui.service.ManagedService;
    import org.seasar.akabana.yui.service.OperationCallBack;
    import org.seasar.akabana.yui.service.PendingCall;
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.ServiceGatewayUrlResolver;
    import org.seasar.akabana.yui.service.ServiceManager;
    import org.seasar.akabana.yui.service.ds.local.LocalOperation;
    import org.seasar.akabana.yui.util.URLUtil;


    use namespace flash_proxy;
    use namespace mx_internal;

    public dynamic class RemotingService extends RemoteObject implements ManagedService {

        public static const HTTP_AMF_ENDPOINT_NAME:String = "http-amf";

        public static const HTTPS_AMF_ENDPOINT_NAME:String = "https-amf";

        {
            registerClassAlias( "flex.messaging.config.ConfigMap", ConfigMap);

            registerClassAlias( "flex.management.jmx.Attribute", Attribute);
            registerClassAlias( "flex.management.jmx.MBeanAttributeInfo", MBeanAttributeInfo);
            registerClassAlias( "flex.management.jmx.MBeanConstructorInfo", MBeanConstructorInfo);
            registerClassAlias( "flex.management.jmx.MBeanFeatureInfo", MBeanFeatureInfo);
            registerClassAlias( "flex.management.jmx.MBeanInfo", MBeanInfo);
            registerClassAlias( "flex.management.jmx.MBeanOperationInfo", MBeanOperationInfo);
            registerClassAlias( "flex.management.jmx.MBeanParameterInfo", MBeanParameterInfo);

            registerClassAlias( "flex.management.jmx.ObjectInstance", ObjectInstance);
            registerClassAlias( "flex.management.jmx.ObjectName", ObjectName);

            registerClassAlias( "flex.messaging.messages.AcknowledgeMessage", AcknowledgeMessage);
            registerClassAlias( "DSK", AcknowledgeMessageExt);
            registerClassAlias( "flex.messaging.messages.AsyncMessage", AsyncMessage);
            registerClassAlias( "DSA", AsyncMessageExt);
            registerClassAlias( "flex.messaging.messages.CommandMessage", CommandMessage);
            registerClassAlias( "DSC", CommandMessageExt);
            registerClassAlias( "flex.messaging.messages.ErrorMessage", ErrorMessage);
            registerClassAlias( "flex.messaging.messages.MessagePerformanceInfo", MessagePerformanceInfo);
            registerClassAlias( "flex.messaging.messages.RemotingMessage", RemotingMessage);
        }

        private var _parentApplication:UIComponent;

        private var _isInitialzed:Boolean;

        private var _pendingCallMap:Dictionary;

        public function get name():String{
            return destination;
        }

        public function RemotingService( id:String = null ){
            super( id );
            if( id != null ){
                destination = id;
                initEndpoint();
                _isInitialzed = true;
            } else {
                _isInitialzed = false;
            }
            addEventListener(FaultEvent.FAULT,function(e:FaultEvent):void{});
            _pendingCallMap = new Dictionary();
        }
        
        public override function getOperation(name:String):AbstractOperation
        {
            var o:Object = _operations[name];
            var op:AbstractOperation = null;
            if( o != null && o is AbstractOperation){
                op = o as AbstractOperation; 
            }
            if (op == null)
            {
                if( ServiceGatewayUrlResolver.isLocalUrl(endpoint) ){
                    op = new LocalOperation(this, name);
                    _operations[name] = op;
                } else {
                    op = super.getOperation(name);
                }
            }
            return op;
        }
        
        public function finalizeResponder(responder:Object):void{
            for( var item:* in _pendingCallMap ){
                var pc:DsPendingCall = item as DsPendingCall;
                if( pc != null && pc.getResponder() === responder){
                    pc.clear();
                }
            }
        }

        public function finalizePendingCall(pc:PendingCall):void{
            if( pc != null ){
                _pendingCallMap[ pc ] = null;
                delete _pendingCallMap[ pc ];
            }
        }

        public override function initialized(document:Object, id:String):void
        {
            super.initialized(document,id);

            if( document is UIComponent ){
                _parentApplication = (document as UIComponent).parentApplication as UIComponent;
            }
            _parentApplication.addEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandler,false,0,true);
            ServiceManager.addService( this );
        }

        private function creationCompleteHandler( event:FlexEvent ):void{
            _parentApplication.removeEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler, false );
            _parentApplication = null;
            if( destination == null || destination.length == 0){
                destination = mx_internal::id;
            }
        }

        protected function initEndpoint():void{
            endpoint = ServiceGatewayUrlResolver.resolve( destination );
            if (endpoint != null){
                var channel:Channel;
                if (URLUtil.isHttpsURL(endpoint)){
                    channel = new SecureAMFChannel(HTTPS_AMF_ENDPOINT_NAME, endpoint);
                } else {
                    channel = new AMFChannel(HTTP_AMF_ENDPOINT_NAME, endpoint);
                }
                channelSet = new ChannelSet();
                channelSet.addChannel(channel);
            }
        }

        protected function internalInvoke(name:QName,args:Array):DsPendingCall{
            if( !_isInitialzed ){
                _isInitialzed = true;
                initEndpoint();
            }
            var asyncToken:AsyncToken = super.callProperty.apply(null, [name].concat(args));
            asyncToken.message.destination = destination;
            var result:DsPendingCall = new DsPendingCall(asyncToken.message);
            result.setInternalAsyncToken(asyncToken,getOperation(name.localName));

            if( OperationCallBack.invokeCallBack != null ){
                var methodName:String = name.localName;
                OperationCallBack.invokeCallBack.apply(null,[destination+"."+methodName,args]);
            }
            if( result != null ){
                _pendingCallMap[ result ] = getTimer();
            }
            return result;
        }

        flash_proxy override function callProperty(name:*, ... args:Array):*{
            return internalInvoke(name,args);
        }
    }
}