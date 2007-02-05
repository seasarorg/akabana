package examples.chura.emp.dao;

import java.util.List;

import junit.textui.TestRunner;

import org.seasar.dao.unit.S2DaoTestCase;

import examples.chura.dao.EmpDao;
import examples.chura.entity.Emp;

public class EmpDaoTest extends S2DaoTestCase {

	private EmpDao empDao;

	public EmpDaoTest(String arg0) {
		super(arg0);
	}

	public void setUp() {
		include("app.dicon");
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
	
	public void testInsert() {
		Emp emp = new Emp();
		emp.setEmpno(7369);
		emp.setEname("aaa");
		empDao.insert(emp);
	}
	
	public static void main(String[] args) {
		TestRunner.run(EmpDaoTest.class);
	}
}
