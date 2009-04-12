/*
 * Copyright 2004-2009 the Seasar Foundation and the Others.
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
package org.seasar.akabana.yui.command
{
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    import org.seasar.akabana.yui.command.core.impl.AbstractCommand;

    public class URLLoaderCommand extends AbstractCommand
    {
        protected var dataFormat:String;
        
        protected var loader:URLLoader;
        
        protected var urlRequest:URLRequest;
        
        public function URLLoaderCommand(urlRequest:URLRequest=null,dataFormat:String="text"){
            super();
            this.urlRequest = urlRequest;
            this.dataFormat = dataFormat;
        }
        
        public function getRequest():URLRequest{
            return urlRequest;
        }
                
        protected override function doRun(...args):void{
            var request:URLRequest;
            if( args.length > 0 ){
                request = args[0];
            } else {
                request = urlRequest;
            }
            if( loader == null ){
                loader = createURLLoader();
            }
            addListeners(loader);
            loader.load(request);
        }
        
        protected function createURLLoader():URLLoader{
            var result:URLLoader = new URLLoader();
            result.dataFormat = this.dataFormat;
            
            return result;
        }

        protected function addListeners(loader:URLLoader):void {
            loader.addEventListener(Event.COMPLETE, completeHandler);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }

        protected function removeListeners(loader:URLLoader):void {
            loader.removeEventListener(Event.COMPLETE, completeHandler);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }

        private function completeHandler(event:Event):void {
            var loader:URLLoader = URLLoader(event.target);
            loader.close();
            removeListeners(loader);
            complete(loader);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            removeListeners(loader);
            error(event);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            removeListeners(loader);
            error(event);
        }
    }
}