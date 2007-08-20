/*
 * Copyright 2004-2006 the Seasar Foundation and the Others.
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
package org.seasar.flex2.rpc.remoting.security.impl;

import java.security.Principal;

import javax.servlet.http.HttpSession;

import org.seasar.flex2.rpc.remoting.security.RemotingServicePrincipalStorage;
import org.seasar.framework.container.S2Container;

public class RemotingServicePrincipalSessionStorageImpl implements
        RemotingServicePrincipalStorage {
    
    private static final String PRINCEPAL_SESSION_KEY = "_rsPrincipal_";
    
    private S2Container container;
    
    public final Principal getUserPrincipal() {
        return (Principal) getSession().getAttribute(PRINCEPAL_SESSION_KEY);
    }
    
    public void savePrincipal(final Principal principal) {
        if (principal != null) {
            doSaveUserPrincipal(principal);
        } else {
            doRemoveUserPrincipal();
        }
    }
    
    public void setContainer(S2Container container) {
        this.container = container;
    }
    
    private final void doRemoveUserPrincipal() {
        getSession().removeAttribute(PRINCEPAL_SESSION_KEY);
    }
    
    private final void doSaveUserPrincipal(final Principal principal) {
        getSession().setAttribute(PRINCEPAL_SESSION_KEY, principal);
    }
    
    private final HttpSession getSession() {
        final HttpSession session = (HttpSession) container
                .getComponent("session");
        return session;
    }
}
