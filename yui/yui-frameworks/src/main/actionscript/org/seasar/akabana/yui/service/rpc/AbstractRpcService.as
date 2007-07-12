/*
 * Copyright 2004-2007 the Seasar Foundation and the Others.
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
    import org.seasar.akabana.yui.service.Service;

    public dynamic class AbstractRpcService extends Proxy implements Service {
        
        public var operations:Dictionary;
        
        protected var destination_:String;
        
        protected var requestTimeout_:int; 
                     
        private var innerEventdispatcher:EventDispatcher;

        public function AbstractRpcService(){
            super();
            operations = new Dictionary();
            innerEventdispatcher = new EventDispatcher();
        }
        
        public function get destination():String{
            return destination_;
        }
        
        [Inspectable(type="String")]
        public function set destination( destination:String ):void{
            destination_ = destination;
        }
        
        public function get requestTimeout():int{
            return requestTimeout_;
        }
        
        [Inspectable(type="number")]
        public function set requestTimeout( requestTimeout:int ):void{
            requestTimeout_ = requestTimeout;
        }
    	
    	public function addOperation( operationName:String, operation:Operation = null, resultHandler:Function = null, faultHandler:Function = null ):void{
    	    if( operation != null ){
    	        operations[ operationName ] = operation;
    	    } else {
    	        operations[ operationName ] = createOperation( operationName );
    	    }
    	    if( resultHandler != null ){
    	        operations[ operationName ].addResponseHandler(resultHandler,faultHandler);
    	    }
    	}
    	
    	public function getOperation( name:String ):Operation{
    	    return operations[ name ];
    	}
    	
    	public function hasOperation( name:String ):Boolean{
    	    return operations.hasOwnProperty( name );
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
	    
	    protected function createOperation( operationName:String ):AbstractRpcOperation{
	        return null;
	    }
	    
    	protected function invokeOperation( operationName:String, operationArgs:Array ):PendingCall{
            return null;
    	}
	    
	    flash_proxy override function callProperty(methodName:*, ...args):* {
	        if( destination_ == null || destination_.length <= 0 ){
		        throw new Error("接続サービス名が指定されていません。");
	        }
	        return invokeOperation( QName(methodName).localName, args );
    	}
    }
}