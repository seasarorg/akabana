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
package org.seasar.flex2.rpc.remoting.security.factory.impl;

import org.seasar.flex2.rpc.remoting.security.RemotingServicePrincipal;
import org.seasar.flex2.rpc.remoting.security.factory.RemotingServicePrincipalFactory;
import org.seasar.flex2.rpc.remoting.security.impl.RemotingServicePrincipalImpl;
import org.seasar.framework.container.S2Container;

public class RemotingServicePrincipalFactoryImpl implements
		RemotingServicePrincipalFactory {

	private S2Container container;

	public RemotingServicePrincipal createPrincipal(final String name,
			final String role) {
		final RemotingServicePrincipalImpl principal = (RemotingServicePrincipalImpl) container
				.getComponent(RemotingServicePrincipal.class);
		principal.setName(name);
		principal.setRole(role);
		
		return principal;
	}

	public void setContainer(S2Container container) {
		this.container = container;
	}

}
