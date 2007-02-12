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
package org.seasar.flex2.rpc.remoting.security.authentication;

import org.seasar.extension.unit.S2TestCase;

public class Amf0RemotingServiceAuthenticationContextTest extends S2TestCase {
    private final static String PATH = "s2flex2-ana-amf0test.dicon";
    
    private RemotingServiceAuthenticationContext context;

    protected void setUp() throws Exception {
        include(PATH);
    }
    
    public void testIsAuthenticated(){
        assertTrue("1",context.isAuthenticated());
    }

    public void testIsUserInRole(){
        assertFalse("1",context.isUserInRole("user"));
        assertTrue("2",context.isUserInRole("adminrole"));
    }
}
