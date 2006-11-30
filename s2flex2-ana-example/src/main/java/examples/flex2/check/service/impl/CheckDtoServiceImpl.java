package examples.flex2.check.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.seasar.flex2.rpc.remoting.service.annotation.RemotingService;

import examples.flex2.check.dto.CheckDto;
import examples.flex2.check.service.CheckDtoService;

@RemotingService
public class CheckDtoServiceImpl implements CheckDtoService {

	public List getCheckDtoList() {
		List l = new ArrayList();
		List internalList = new ArrayList();
		internalList.add("red");
		internalList.add("blue");
		internalList.add("yellow");
		
		for(int i=0;i<5000;i++){
			CheckDto checkDto = new CheckDto();
			checkDto.setAddress("address"+i);
			checkDto.setB(i%2==0);
			checkDto.setCreateTime(new Date());
			checkDto.setId(i);
			checkDto.setDoubleValue(i*i+i*0.3342);
			checkDto.setMinus(i*10*-1);
			checkDto.setName("name_" +i);
			checkDto.setList(internalList);
			checkDto.setStringArray(new String[]{"one","two","three","four","five","six"});
			l.add(checkDto);
		}
		return l;
	}
	public CheckDto getCheckDto(){
		CheckDto checkDto = new CheckDto();
		checkDto.setId(1);
		checkDto.setAddress("addressData");
		checkDto.setCreateTime(new Date());
		checkDto.setB(true);
		checkDto.setDoubleValue(1.0043545454002d);
		checkDto.setMinus(-12433);
		checkDto.setName("I am CheckDto instance");
		checkDto.setStringArray(new String[]{"music","movie"});
		List list = new ArrayList();
		list.add("yes");
		list.add("no");
		list.add("both");
		checkDto.setList(list);
		return checkDto;		
	}

}
