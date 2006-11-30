// ActionScript file
import flash.events.Event;
import flash.events.NetStatusEvent;

import mx.controls.Alert;
import mx.controls.Text;
import mx.rpc.Fault;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectUtil;

public function execute():void{
	amf.getExService("serviceName");
}
public function execute2():void{
	amf.getService("serviceName");
}
public function onResult(ret:ResultEvent):void{
}
public function onFault(ret:FaultEvent):void{
	var fault:Fault = ret.fault as Fault;
	if( fault != null ){
	    faultcode_txt.text=fault.faultCode;
	    description_txt.text=fault.faultDetail;
	    message_txt.text=fault.message;
	}
}
public function onNetStatus(event:NetStatusEvent):void{
	Alert.show(ObjectUtil.toString(event));
}