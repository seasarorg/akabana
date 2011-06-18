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
package org.seasar.akabana.yui.service.rpc.responder
{
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.service.resonder.ResponderFactory;

    [ExcludeClass]
    public final class RpcResponderFactory extends ResponderFactory
    {
        public function RpcResponderFactory()
        {
            super();
            eventResoponderClassRef = getClassRef(RpcDefaultEventResponder);
            objectResponderClassRef = getClassRef(RpcObjectResponder);
            noneResponderClassRef = getClassRef(RpcNoneResponder);
        }
    }
}