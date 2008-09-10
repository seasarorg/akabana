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
package org.seasar.akabana.yui.service.rpc.remoting.mxml {
    
    import flash.display.DisplayObjectContainer;
    
    import mx.core.IMXMLObject;
    
    import org.seasar.akabana.yui.service.ServiceRepository;
    import org.seasar.akabana.yui.service.rpc.remoting.RemotingService;

    [Event(name="invoke", type="org.seasar.akabana.yui.service.event.InvokeEvent")]
    [Event(name="fault", type="org.seasar.akabana.yui.service.event.FaultEvent")]
    [Event(name="result", type="org.seasar.akabana.yui.service.event.ResultEvent")]
    public class RemotingService extends org.seasar.akabana.yui.service.rpc.remoting.RemotingService implements IMXMLObject {

        YuiCoreClasses;

        protected var parent_:DisplayObjectContainer;
        
        protected var id_:String;

        public function get id():String{
            return id_;
        }

        public function get parent():DisplayObjectContainer{
            return parent_;
        }

        public function RemotingService(){
            super('');
        }
        
        public function initialized(document:Object, id:String):void{
            parent_ = document as DisplayObjectContainer;
            id_ = id;
            ServiceRepository.addService(this);
        }
    }
}