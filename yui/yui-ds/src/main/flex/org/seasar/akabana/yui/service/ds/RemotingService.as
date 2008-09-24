/*
 * Copyright 2004-2008 the Seasar Foundation and the Others.
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
    
    import mx.core.Application;
    import mx.core.Container;
    import mx.core.mx_internal;
    import mx.events.FlexEvent;
    import mx.messaging.Channel;
    import mx.messaging.ChannelSet;
    import mx.messaging.channels.AMFChannel;
    import mx.messaging.channels.SecureAMFChannel;
    import mx.rpc.remoting.mxml.RemoteObject;
    
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.rpc.remoting.util.GatewayUtil;
    
    public dynamic class RemotingService extends RemoteObject implements Service {
        
        public var channelName:String;
        
        private var gatewayUrl_:String;
        
        private var parentApplication:Application;

        public function get name():String{
            return destination;
        }
        
        public override function set destination(value:String):void{
            super.destination = value;
            if( mx_internal::id != null ){
                initEndpoint();
            }
        }
        
        public function RemotingService( id:String = null ){
            if( id != null ){
                mx_internal::id = destination;
            }
        }
        
        public override function initialized(document:Object, id:String):void
        {
            super.initialized(document,id);       
            
            if( document is Application ){
                parentApplication = document as Application;
            } else {
                parentApplication = Container(document).parentApplication as Application;
            }
            parentApplication.addEventListener(FlexEvent.CREATION_COMPLETE,preinitializeHandler,false,int.MAX_VALUE,true);
        }
        
        private function preinitializeHandler( event:FlexEvent ):void{
            if( destination == null || destination.length == 0){
                mx_internal::asyncRequest.destination = mx_internal::id;
            }
            initEndpoint();
        }
        
        protected function initEndpoint():void{
            endpoint = GatewayUtil.resolveGatewayUrl( destination );
            if (endpoint != null)
            {
                var chan:Channel;
                if (endpoint.indexOf("https") == 0)
                {
                    chan = new SecureAMFChannel("https-amf", endpoint);
                } else {
                    chan = new AMFChannel("http-amf", endpoint);
                }
                channelSet = new ChannelSet();
                channelSet.addChannel(chan);
            }
        }
    }
}