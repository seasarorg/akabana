package examples.flex2.add.service.impl;

import examples.flex2.add.dto.AddDto;
import org.seasar.flex2.rpc.remoting.service.annotation.RemotingService;
import org.seasar.flex2.util.data.storage.StorageType;
import org.seasar.flex2.util.data.transfer.annotation.Export;
import org.seasar.flex2.util.data.transfer.annotation.Import;
/**
 * @org.seasar.flex2.rpc.remoting.service.annotation.RemotingService
 *
 */
@RemotingService
public class AbstractService {

	protected AddDto addDto;
	
	
    /**
     * 
     * @ Export(storage = "session") 
     */
    @Export(storage = StorageType.SESSION)
	public AddDto getAddDto() {
		return addDto;
	}

    /**
     * 
     * @ Import(storage = "session") 
     */
    @Import(storage = StorageType.SESSION)
	public void setAddDto(AddDto addDto) {
		this.addDto = addDto;
	}
	
	
}
