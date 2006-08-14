package org.seasar.flex2.rpc.remoting.security.realm.impl;

import java.util.Map;

import org.seasar.flex2.rpc.remoting.security.RemotingServicePrincipal;
import org.seasar.flex2.rpc.remoting.security.realm.impl.AbstractRemotingServiceRealmImpl;

public class HashMapRealmImpl extends AbstractRemotingServiceRealmImpl {

    private Map userMap;

    private Map userRoleMap;

    public RemotingServicePrincipal authenticate(final String userid, final String password) {
        RemotingServicePrincipal principal = null;
        if (password.equalsIgnoreCase(getPassword(userid))) {
            principal = createPrincipal(userid,principal.getRole());
        }
        return principal;
    }

    public boolean hasRole(final RemotingServicePrincipal principal, final String role) {
        boolean hasRole = false;
        if (userRoleMap.containsKey(principal.getName())) {
            hasRole = role.equalsIgnoreCase(getRole(principal));
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

    protected String getRole(RemotingServicePrincipal principal) {
        return (String) userRoleMap.get(principal.getName());
    }
}
