package examples.chura.dao;

import java.util.List;

import examples.chura.entity.Emp;

public interface EmpDao {

	public Class BEAN = Emp.class;
	
	public List selectAll();
	
	public int insert(Emp emp);

	public int update(Emp emp);
	
	public int remove(Emp emp);
}
