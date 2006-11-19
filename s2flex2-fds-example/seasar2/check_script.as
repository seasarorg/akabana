// ActionScript file
import examples.flex2.check.dto.CheckDto;

import mx.controls.Alert;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectUtil;
import mx.collections.ArrayCollection;

[Bindable]
public var checkDto:CheckDto;
[Bindable]
public var checkDtoList:ArrayCollection;

public function getCheckDto():void{
	checkDtoService.getCheckDto();
}
public function getCheckList():void{
    debug.text = "stat：" + getTimer() + "\n";
	checkDtoServiceList.getCheckDtoList();
}
private function initApp():void
{
	var foo:CheckDto = new CheckDto();
	checkDtoList = new ArrayCollection();
}
public function onListResult(event:ResultEvent):void{
    debug.text += "end：" + getTimer() + "\n";
	this.checkDtoList=event.result as ArrayCollection;
}
public function onResult(event:ResultEvent):void{
	this.checkDto=event.result as CheckDto;
	array_txt.text=ObjectUtil.toString(checkDto.stringArray);
	list_txt.text=ObjectUtil.toString(checkDto.list);
}
public function onFault(event:FaultEvent):void{
	Alert.show("error=" +event);
}