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

    import flash.net.registerClassAlias;
    import flash.utils.flash_proxy;

    import mx.core.Application;
    import mx.core.Container;
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
    import mx.rpc.AsyncToken;
    import mx.rpc.remoting.mxml.RemoteObject;

    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.rpc.remoting.util.GatewayUtil;


    use namespace flash_proxy;
    use namespace mx_internal;

    public dynamic class RemotingService extends RemoteObject implements Service {

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

        private var parentApplication:Application;

        public function get name():String{
            return destination;
        }

        public override function set destination(value:String):void{
            super.destination = value;
            if( value != null ){
                mx_internal::id = value;
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
            parentApplication.removeEventListener( FlexEvent.CREATION_COMPLETE, preinitializeHandler, false );
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

        override flash_proxy function callProperty(name:*, ... args:Array):*{
            var asyncToken:AsyncToken = super.callProperty.apply(null, [name].concat(args));
            asyncToken.message.destination = destination;
            var result:RpcPendingCall = new RpcPendingCall(asyncToken.message);
            result.setInternalAsyncToken(asyncToken);
            return result;
        }
    }
}