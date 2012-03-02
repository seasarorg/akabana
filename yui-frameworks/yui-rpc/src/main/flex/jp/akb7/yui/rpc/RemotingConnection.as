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
package jp.akb7.yui.rpc {

    import flash.net.NetConnection;
    import flash.net.Responder;

    [ExcludeClass]
    public final dynamic class RemotingConnection extends NetConnection {

        private var originalUrl_:String;

        private var append_:String=null;

        public function RemotingConnection(){
            super();
            client = new CallBackProxy( this );
        }

        public override function call(command:String,responder:Responder,...parameters):void{
            if( append_ != null){
                reconnect( originalUrl_ + append_ );
                append_ = null;
            }
            super.call.apply( this, [command, responder].concat( parameters ));
        }

        public override function connect( url:String, ...rest):void{
            originalUrl_ = url;
            super.connect( url, rest);
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

        private function reconnect( newUri:String ):void{
            if( this.uri != null ){
                this.close();
            }
            this.connect( newUri );
        }

        public function appendToGatewayUrl(append:String):void{
            append_ = append;
        }
    }
}
import flash.utils.Proxy;
import flash.utils.flash_proxy;
import jp.akb7.yui.rpc.RemotingConnection;

dynamic class CallBackProxy extends Proxy {

    public var rc:RemotingConnection;

    function CallBackProxy( rc:RemotingConnection ){
        this.rc = rc;
    }

    override flash_proxy function hasProperty(name:*):Boolean{
        if( name == "AppendToGatewayUrl" ){
            return true;
        }
        return false;
    }

    override flash_proxy function getProperty(name:*):* {
        if( QName(name).localName == "AppendToGatewayUrl" ){
            return rc.appendToGatewayUrl as Function;
        }
        return function(...args):*{};
    }
}