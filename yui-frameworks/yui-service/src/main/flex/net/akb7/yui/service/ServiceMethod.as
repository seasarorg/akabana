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
package net.akb7.yui.service
{
    import flash.events.EventDispatcher;
    
    import net.akb7.yui.core.error.NotFoundError;
    import net.akb7.yui.core.event.MessageEvent;
    import net.akb7.yui.service.event.FaultEvent;
    import net.akb7.yui.service.event.ResultEvent;
    import net.akb7.yui.service.resonder.IServiceResponder;
    
    public class ServiceMethod extends EventDispatcher implements IServiceResponder{
        
        protected var _serviceName:String;
        
        protected var _methodName:String;
        
        protected var _service:IService;
        
        public function get service():IService{
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