package examples.chura.emp.dao;

import java.util.List;

import org.seasar.dao.unit.S2DaoTestCase;

import examples.chura.dao.EmpDao;
import examples.chura.entity.Emp;

public class EmpDaoTest extends S2DaoTestCase {

	private EmpDao empDao;
	
	public void setUp() {
		include("app.dicon");
		include("jdbc.dicon");
	}

	public void setEmpDao(EmpDao empDao) {
		this.empDao = empDao;
	}

	public void testSelectAll() throws Exception {
		List list = empDao.selectAll();
		for(int i = 0; i < list.size(); i++) {
			System.out.println(((Emp)list.get(i)).getEmpno());
		}
		assertEquals(list.size(), 14);
	}
}
