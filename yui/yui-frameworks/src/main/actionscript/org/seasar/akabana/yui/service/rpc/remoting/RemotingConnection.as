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

    import flash.net.NetConnection;

    public class RemotingConnection extends NetConnection{

        private var originalUrl_:String;

        private var append_:String=null;
        
        public override function connect( url:String, ...rest):void{
            originalUrl_ = url;
            super.connect( url, rest);
        }
        
        protected function reconnect( newUri:String ):void{
            if( this.uri != null ){
                this.close();
            }
            this.connect( newUri );
        }
        
        public function AppendToGatewayUrl(append:String):void{ 
            append_ = append;
            reconnect( originalUrl_ + append_ );
        }
        
        public function ReplaceGatewayUrl(url:String):void{
            reconnect(url);
        }

        public override function addHeader(operation:String,mustUnderstand:Boolean=false,param:Object=null):void{
            super.addHeader(operation,mustUnderstand,param);
        }

        public function get connectedUrl():String{
            var url:String = originalUrl_;
            if( append_ != null){
                url += append_;
            }
            return url;
        }
    }
}