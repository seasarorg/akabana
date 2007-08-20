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
package org.seasar.flex2.rpc.remoting.security.authentication.impl;

import org.seasar.flex2.rpc.remoting.message.RemotingMessageConstants;
import org.seasar.flex2.rpc.remoting.message.data.Message;

public class Amf3RemotingServiceAuthenticationContextImpl extends
        RemotingServiceAuthenticationContextImpl {
    
    @Override
    protected final void doAuthenticate(final Message requestMessage) {
        final String userid = requestMessage
                .getHeader(RemotingMessageConstants.CREDENTIALS_USERNAME);
        
        if (userid != null) {
            final String password = requestMessage
                    .getHeader(RemotingMessageConstants.CREDENTIALS_PASSWORD);
            if (remotingServiceRealm.authenticate(userid, password)) {
                storage.savePrincipal(getUserPrincipalInRealm(userid));
            }
        }
    }
}