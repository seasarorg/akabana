package examples.chura.web.emp;

import java.util.List;

import org.seasar.flex2.rpc.remoting.service.annotation.RemotingService;

import examples.chura.dao.EmpDao;
import examples.chura.entity.Emp;

@RemotingService
public class EmpService {

	private EmpDao empDao;

	public List getEmpItems() {
		return empDao.selectAll();
	}

	public void setEmpDao(EmpDao empDao) {
		this.empDao = empDao;
	}

	public int insert(Emp emp) {
		return empDao.insert(emp);
	}

	public int update(Emp emp) {
		return empDao.update(emp);
	}

	public int remove(Emp emp) {
		return empDao.remove(emp);
	}
}
