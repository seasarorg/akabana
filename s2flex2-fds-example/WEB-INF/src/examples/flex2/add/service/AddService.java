package examples.flex2.add.service;

import examples.flex2.add.dto.AddDto;

public interface AddService {

    public int calculate(int arg1, int arg2);
    
    public AddDto calculate2(AddDto addDto);
    
    public AddDto getAddDtoData();
}
