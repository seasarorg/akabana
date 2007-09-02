package examples.security.realm.dao;

import org.seasar.dao.annotation.tiger.Arguments;
import org.seasar.dao.annotation.tiger.S2Dao;
import org.seasar.dao.annotation.tiger.Sql;

import examples.security.realm.entity.UserRoles;

@S2Dao(bean=UserRoles.class)
public interface UserRolesDao {

	public UserRoles[] selectAll();

	@Arguments( { "USER_ID", "ROLENAME" })
	public UserRoles selectById(String userId, String rolename);

	public int insert(UserRoles roles);

	//public int update(UserRoles roles);

	//public int delete(UserRoles roles);

	//@Arguments({"USER_ID"})
	@Sql("SELECT rolename from User_Roles where user_Id=?")
	public UserRoles[] getRole(String userId);
	
	//@Arguments( { "USER_ID", "ROLENAME" })
	@Sql("SELECT COUNT(*) FROM USER_ROLES where user_Id=? and roleName=?")
	public int hasRole(String userId,String roleName);
}
