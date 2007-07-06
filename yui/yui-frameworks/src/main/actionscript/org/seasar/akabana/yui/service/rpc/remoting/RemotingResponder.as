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
package org.seasar.akabana.yui.service.rpc.remoting {
    
    import org.seasar.akabana.yui.service.rpc.event.RpcFaultEvent;
    import org.seasar.akabana.yui.service.rpc.event.RpcResultEvent;
    import org.seasar.akabana.yui.service.rpc.RpcResponder;

    public class RemotingResponder implements RpcResponder {
        
		protected var resultFunction:Function;
		
		protected var faultFunction:Function;
		
		public function RemotingResponder( resultFunction:Function, faultFunction:Function = null){
			this.resultFunction = resultFunction;
			this.faultFunction = faultFunction;
		}
		
		public function onResult( resultEvent:RpcResultEvent ):void{
			resultFunction.call( null, resultEvent );
		}
		
		public function onFault( faultEvent:RpcFaultEvent ):void{
			if( faultFunction != null ){
				faultFunction.call( null, faultEvent );
			}
		}
    }
}