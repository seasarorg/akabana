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
        
        protected var url:URLRequest;
        
        public function URLLoaderCommand(url:URLRequest=null,dataFormat:String="text"){
            super();
            this.url = url;
            this.dataFormat = dataFormat;
        }
        
        public function getRequest():URLRequest{
            return url;
        }
                
        protected override function doRun(...args):void{
            var req:URLRequest;
            if( args.length > 0 ){
                req = args[0];
            } else {
                req = url;
            }
            if( loader == null ){
                loader = createURLLoader();
            }
            addListeners(loader);
            loader.load(req);
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