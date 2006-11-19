package examples.flex2.check.service.impl;

import org.seasar.flex2.rpc.remoting.service.annotation.RemotingService;

import examples.flex2.check.service.ExceptionService;

@RemotingService
public class ExceptionServiceImpl implements ExceptionService {

	public void getExService(String serviceName) {
		if(true){
			throw new RuntimeException(serviceName + " is null",new NullPointerException("causeException"));
		}
	}

}
