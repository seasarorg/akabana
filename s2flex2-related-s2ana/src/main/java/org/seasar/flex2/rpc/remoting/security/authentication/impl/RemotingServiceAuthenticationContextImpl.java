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
package org.seasar.flex2.rpc.remoting.security.authentication.impl;

import java.security.Principal;

import org.seasar.flex2.rpc.remoting.message.data.Message;
import org.seasar.flex2.rpc.remoting.message.data.factory.MessageFactory;
import org.seasar.flex2.rpc.remoting.security.RemotingServicePrincipal;
import org.seasar.flex2.rpc.remoting.security.authentication.RemotingServiceAuthenticationContext;
import org.seasar.flex2.rpc.remoting.security.realm.Realm;

public class RemotingServiceAuthenticationContextImpl implements
        RemotingServiceAuthenticationContext {

	private boolean isNeedAuthentication = true;
	
    private MessageFactory messageFactory;

    private RemotingServicePrincipal principal;

    private Realm realm;

    public void authenticate(){
    	final Message requestMessage = messageFactory.createRequestMessage();
    	if( principal == null ){
	        final String userid = requestMessage.getHeader("remoteUsername");
	        if (userid != null) {
		        final String password = requestMessage.getHeader("remotePassword");
	            principal = realm.authenticate(userid, password);
	            if( principal != null ){
	            	isNeedAuthentication = false;
	            }
	        }
    	}
    }

    public Principal getUserPrincipal() {
        return principal;
    }

    public void invalidate() {
        principal = null;
        isNeedAuthentication = true;
    }

    public boolean isAuthenticated(){
    	if(isNeedAuthentication){
    		authenticate();
    	}
        return principal != null;
    }

    public boolean isUserInRole(final String role){
        boolean isUserInRole = false;
        if (isAuthenticated()) {
            if (realm.hasRole(principal, role)) {
                isUserInRole = true;
            }
        }
        return isUserInRole;
    }
    
    public void setRealm(final Realm realm) {
        this.realm = realm;
    }

	public void setMessageFactory(MessageFactory messageFactory) {
		this.messageFactory = messageFactory;
	}
}