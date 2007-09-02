package examples.security.realm.impl;

import org.seasar.flex2.rpc.remoting.security.RemotingServicePrincipal;
import org.seasar.flex2.rpc.remoting.security.realm.RemotingServiceRealm;

import examples.security.realm.dao.UserDao;
import examples.security.realm.dao.UserRolesDao;
import examples.security.realm.entity.UserRoles;

public class JdbcRealmImpl implements RemotingServiceRealm {
	
	private UserDao userDao;
	private UserRolesDao userRolesDao;

	public boolean authenticate(final String userid, final String password) {		
		return userDao.authenticate(userid, password)>0;
	}
	/*
	 * @return roleName
	 * @see org.seasar.flex2.rpc.remoting.security.realm.Realm#getRole(java.lang.String)
	 */
	public String getRole(final String userId) {
		UserRoles[] roles =userRolesDao.getRole(userId);
		if(roles!=null&&roles.length>0){
			return roles[0].getRolename();
		}
		return null;
	}

	public boolean hasRole(RemotingServicePrincipal principal, String role) {
		return userRolesDao.hasRole(principal.getName(), role)>0;
	}
	
	/**
	 * @return the userDao
	 */
	public UserDao getUserDao() {
		return userDao;
	}

	/**
	 * @param userDao the userDao to set
	 */
	public void setUserDao(UserDao userDao) {
		this.userDao = userDao;
	}

	/**
	 * @return the userRolesDao
	 */
	public UserRolesDao getUserRolesDao() {
		return userRolesDao;
	}

	/**
	 * @param userRolesDao the userRolesDao to set
	 */
	public void setUserRolesDao(UserRolesDao userRolesDao) {
		this.userRolesDao = userRolesDao;
	}

}
