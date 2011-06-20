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
package org.seasar.akabana.yui.service
{
    import flash.events.EventDispatcher;
    
    import org.seasar.akabana.yui.core.error.NotFoundError;
    import org.seasar.akabana.yui.core.event.MessageEvent;
    import org.seasar.akabana.yui.service.ServiceManager;
    import org.seasar.akabana.yui.service.event.FaultEvent;
    import org.seasar.akabana.yui.service.event.ResultEvent;
    import org.seasar.akabana.yui.service.resonder.Responder;
    
    public class ServiceMethod extends EventDispatcher implements Responder{
        
        protected var _serviceName:String;
        
        protected var _methodName:String;
        
        protected var _service:Service;
        
        public function get service():Service{
            return _service;
        }
        
        public function ServiceMethod(serviceName:String=null,methodName:String=null){
            if( serviceName != null && methodName != null ){
                init(serviceName,methodName);
            }
        }

        public function init(serviceName:String,methodName:String):void{
            _serviceName = serviceName;
            _methodName = methodName;
        }
        
        public function call(...args):void{
            if( _service == null ){
                _service = ServiceManager.getService(_serviceName);
                if( _service == null ){
                    throw new NotFoundError(this,_serviceName);
                }
            }
            _service
                .invokeMethod(_methodName,args)
                .setResponder(this);
        }
        
        public function onResult( resultEvent:ResultEvent ):void{
            var newEvent:MessageEvent = new MessageEvent(resultEvent.type,resultEvent.result);
            dispatchEvent(newEvent);
        }
        
        public function onFault( faultEvent:FaultEvent ):void{
            var newEvent:MessageEvent = new MessageEvent(faultEvent.type,faultEvent.faultStatus);
            dispatchEvent(newEvent);
        }
    }
}