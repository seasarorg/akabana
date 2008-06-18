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
    
    import mx.core.Container;
    import mx.core.IMXMLObject;
    
    import org.seasar.akabana.yui.service.ServiceRepository;
    import org.seasar.akabana.yui.service.rpc.remoting.RemotingService;

    public class RemotingService extends org.seasar.akabana.yui.service.rpc.remoting.RemotingService implements IMXMLObject {

        protected var parent_:Container;
        
        protected var id_:String;

        public function get id():String{
            return id_;
        }

        public function get parent():Container{
            return parent_;
        }

        public function RemotingService(){
            super('');
        }
        
        public function initialized(document:Object, id:String):void{
            parent_ = document as Container;
            id_ = id;
            ServiceRepository.addService(this);
        }
    }
}