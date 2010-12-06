/*
 * Copyright 2004-2010 the Seasar Foundation and the Others.
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
package org.seasar.akabana.yui.service.rpc {

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;
    
    import org.seasar.akabana.yui.service.Operation;
    import org.seasar.akabana.yui.service.PendingCall;
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.error.IllegalDestinationError;

    use namespace flash_proxy;

    [ExcludeClass]
    public dynamic class AbstractRpcService extends Proxy implements Service {

        protected static const OBJECT_FUNCTION_MAP:Object = {
            hasOwnProperty:true,
            isPrototypeOf:true,
            propertyIsEnumerable:true,
            setPropertyIsEnumerable:true,
            toString:true,
            valueOf:true
        };

        public var operations:Dictionary;

        protected var _destination:String;

        protected var _requestTimeout:int;

        protected var _credentialsUsername:String;

        protected var _credentialsPassword:String;

        protected var innerEventdispatcher:EventDispatcher;

        protected var _gatewayUrl:String;
        
        public function get gatewayUrl():String{
            return _gatewayUrl;
        }
        
        public function set gatewayUrl( gatewayUrl:String):void{
            _gatewayUrl = gatewayUrl;
        }
        
        public function get name():String{
            return _destination;
        }

        public function get destination():String{
            return _destination;
        }

        [Inspectable(type="String")]
        public function set destination( destination:String ):void{
            _destination = destination;
        }

        public function get requestTimeout():int{
            return _requestTimeout;
        }

        [Inspectable(type="number")]
        public function set requestTimeout( requestTimeout:int ):void{
            _requestTimeout = requestTimeout;
        }
        
        public function AbstractRpcService(){
            super();
            operations = new Dictionary();
            innerEventdispatcher = new EventDispatcher();
        }
        
        public function addOperation( operationName:String ):void{
            if( !hasOperation( operationName )){
                operations[ operationName ] = createOperation( operationName );
            }
        }

        public function getOperation( name:String ):Operation{
            return operations[ name ];
        }

        public function hasOperation( name:String ):Boolean{
            return operations.hasOwnProperty( name );
        }

        public function setCredentials(username:String, password:String, charset:String=null):void{
            _credentialsUsername = username;
            _credentialsPassword = password;
        }

        public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, weakRef:Boolean = false):void{
            innerEventdispatcher.addEventListener(type, listener, useCapture, priority, weakRef);
        }

        public function dispatchEvent(evt:Event):Boolean{
            return innerEventdispatcher.dispatchEvent(evt);
        }

        public function hasEventListener (type:String):Boolean{
            return innerEventdispatcher.hasEventListener(type);
        }

        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
            innerEventdispatcher.removeEventListener(type, listener, useCapture);
        }

        public function willTrigger(type:String):Boolean {
            return innerEventdispatcher.willTrigger(type);
        }

        public function deletePendingCallOf(responder:Object):void{

        }
        
        public function deleteCallHistory(pc:PendingCall):void{
            
        }

        protected function createOperation( operationName:String ):AbstractRpcOperation{
            return null;
        }

        protected function invokeOperation( operationName:String, operationArgs:Array ):PendingCall{
            return null;
        }

        flash_proxy override function callProperty(methodName:*, ...args):* {            
            if( _destination == null || _destination.length <= 0 ){
                throw new IllegalDestinationError(_destination);
            }
            return invokeOperation( QName(methodName).localName, args );
        }
    }
}