package examples.security.realm.impl;

import org.seasar.extension.unit.S2TestCase;
import org.seasar.flex2.rpc.remoting.security.RemotingServicePrincipal;
import org.seasar.flex2.rpc.remoting.security.realm.RemotingServiceRealm;

public class JdbcRealImplTest extends S2TestCase {
	
	    private final static String PATH = "s2flex2-ana-realm-test.dicon";
	    
	    private RemotingServiceRealm remotingServiceRealm;
	    
	    private RemotingServicePrincipal remotingServicePricipal;
	    
	    protected void setUp() throws Exception {
	        include(PATH);
	    }
	    public void testRealmAuthenticated(){
	    	assertNotNull("realm implementation is not null",remotingServiceRealm);
	    	assertTrue("realm Implementation is JdbcRealm",remotingServiceRealm instanceof RemotingServiceRealm);
	    	assertTrue("realmIsAuthenticated",remotingServiceRealm.authenticate("admin", "adminpassword"));
	    	
	    }
	    public void testHasRole(){
	    	assertNotNull("realm implementation is not null",remotingServiceRealm);
	    	assertTrue("hasRole",remotingServiceRealm.hasRole(remotingServicePricipal, "admin"));
	    	assertTrue("hasRole",remotingServiceRealm.hasRole(remotingServicePricipal, "manager"));
	    	assertFalse("hasRole=false",remotingServiceRealm.hasRole(remotingServicePricipal, "hoge"));

	    }
	    
	    public void testGetRole(){
	    	assertSame("Test getRole ",remotingServiceRealm.getRole("admin") ,"admin");
	    	assertNotSame("Test getRole always returns [admin]",remotingServiceRealm.getRole("admin") ,"manager");
	    }
}
