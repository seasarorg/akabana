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
package org.seasar.akabana.yui.service {

    import flash.utils.Dictionary;
    
    import org.seasar.akabana.yui.service.event.FaultEvent;
    import org.seasar.akabana.yui.service.event.ResultEvent;

    public class AbstractResponder implements Responder {

        public var resultFunctionDef:Dictionary;

        public var faultFunctionDef:Dictionary;

        public function AbstractResponder( resultFunction:Function, faultFunction:Function = null, weakReference:Boolean=false){         
            resultFunctionDef = new Dictionary(weakReference);
            resultFunctionDef[ resultFunction ] = weakReference;           
            faultFunctionDef = new Dictionary(weakReference);
            if( faultFunction != null ){
                faultFunctionDef[ faultFunction ] = weakReference;
            }
        }

        public function onResult( result:ResultEvent ):void{
        }

        public function onFault( fault:FaultEvent ):void{
        }
        
        protected function callResultFunction(...args):void{
            var result:* = null;
            for( result in resultFunctionDef ){
                (result as Function).apply(null,args);
            }
            clearHandlers();
        }

        protected function callFaultFunction(...args):void{
            var result:* = null;
            for( result in faultFunctionDef ){
                (result as Function).apply(null,args);
            }
            clearHandlers();
        }
                
        protected function clearHandlers():void{
            resultFunctionDef = null;
            faultFunctionDef = null;
        }
    }
}