package root.yui.example.service;

import java.util.List;

import org.seasar.flex2.rpc.remoting.service.annotation.RemotingService;
import org.seasar.framework.beans.util.BeanMap;

import root.yui.example.entity.Emp;

@RemotingService
public class EmpService  extends AbstractService<Emp> {

    public Emp findById(Long id) {
        return select().id(id).getSingleResult();
    }

    public List<Emp> searchByName(String name) {
    	BeanMap map = new BeanMap();
    	map.put("empName_LIKE", name+"%");
        return findByCondition(map);
    }
    
	public int remove(Long id) {
		Emp emp = findById(id);
		return delete(emp);
	}
	
	public List<Emp> fill(){
		return selectAll();
	}
	
	public List<Emp> selectAll(){
		return findAll();
	}
	
}