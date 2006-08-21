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
package org.seasar.flex2.rpc.remoting.security.realm.impl;

import java.util.Map;

import org.seasar.flex2.rpc.remoting.security.RemotingServicePrincipal;
import org.seasar.flex2.rpc.remoting.security.realm.impl.AbstractRemotingServiceRealmImpl;

public class HashMapRealmImpl extends AbstractRemotingServiceRealmImpl {

    private Map userMap;

    private Map userRoleMap;

    public RemotingServicePrincipal authenticate(final String name, final String password) {
        RemotingServicePrincipal principal = null;
        if (password.equalsIgnoreCase(getPassword(name))) {
            principal = createPrincipal(name,getRole(name));
        }
        return principal;
    }

    public boolean hasRole(final RemotingServicePrincipal principal, final String role) {
        boolean hasRole = false;
        if (userRoleMap.containsKey(principal.getName())) {
            hasRole = role.equalsIgnoreCase(getRole(principal.getName()));
        }
        return hasRole;
    }

    public void setUserMap(Map userMap) {
        this.userMap = userMap;
    }

    public void setUserRoleMap(Map userRoleMap) {
        this.userRoleMap = userRoleMap;
    }

    protected String getPassword(String userid) {
        return (String) userMap.get(userid);
    }

    protected String getRole(String name) {
        return (String) userRoleMap.get(name);
    }
}
