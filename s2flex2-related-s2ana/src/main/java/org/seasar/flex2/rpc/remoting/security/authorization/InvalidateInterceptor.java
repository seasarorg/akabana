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
package org.seasar.flex2.rpc.remoting.security.authorization;

import org.aopalliance.intercept.MethodInvocation;
import org.seasar.flex2.rpc.remoting.security.authentication.RemotingServiceAuthenticationContext;
import org.seasar.framework.aop.interceptors.AbstractInterceptor;
import org.seasar.security.authentication.AuthenticationContextResolver;

public class InvalidateInterceptor extends AbstractInterceptor {

    private static final long serialVersionUID = -9148338075349463864L;

    private AuthenticationContextResolver authenticationContextResolver;

    public Object invoke(final MethodInvocation invocation) throws Throwable {
        Object result = null;

        try {
            result = invocation.proceed();
        } finally {
            final RemotingServiceAuthenticationContext authContext = (RemotingServiceAuthenticationContext) authenticationContextResolver
                    .resolve();
            authContext.invalidate();
        }

        return result;
    }

    public void setAuthenticationContextResolver(
            AuthenticationContextResolver authenticationContextResolver) {
        this.authenticationContextResolver = authenticationContextResolver;
    }
}
