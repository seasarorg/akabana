package examples.security.realm.dao;

import org.seasar.dao.annotation.tiger.Arguments;
import org.seasar.dao.annotation.tiger.S2Dao;
import org.seasar.dao.annotation.tiger.Sql;

import examples.security.realm.entity.User;

@S2Dao(bean=User.class)
public interface UserDao {

	public User[] selectAll();

	@Arguments("ID")
	public User selectById(Integer id);

	public int insert(User user);

	public int update(User user);

	public int delete(User user);
	
	@Sql("select count(*) from User where user_id=? and password=?")
	public int authenticate(String userId,String password);
	
	

}
