package examples.flex2.param.service;

import examples.flex2.param.dto.TypeADto;
import examples.flex2.param.dto.TypeBDto;
import examples.flex2.param.dto.TypeCDto;

public interface ParamCheckService {
	public TypeCDto getTypeCDto(int index,TypeADto aDto,TypeBDto b);
}
