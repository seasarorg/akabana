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
package org.seasar.akabana.yui.service.rpc {
    
    import org.seasar.akabana.yui.service.Responder;
    import org.seasar.akabana.yui.service.event.FaultEvent;
    import org.seasar.akabana.yui.service.event.ResultEvent;

    public class RpcObjectResponder implements Responder {
        
        public var resultFunction:Function;
        
        public var faultFunction:Function;
        
        public function RpcObjectResponder( resultFunction:Function, faultFunction:Function = null){
            this.resultFunction = resultFunction;
            this.faultFunction = faultFunction;
        }
        
        public function onResult( result:Object ):void{
            resultFunction.call( null, result );
            resultFunction = null;
        }
        
        public function onFault( fault:Object ):void{
            if( faultFunction != null ){
                faultFunction.call( null, fault );
                faultFunction = null;
            }
        }
    }
}