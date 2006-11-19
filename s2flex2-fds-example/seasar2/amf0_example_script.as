// ActionScript file
import flash.net.NetConnection;
import flash.net.ObjectEncoding;
import flash.net.Responder;
import mx.rpc.events.ResultEvent;
import examples.flex2.add.dto.AddDto;

// case1: JRun4 Integarated 
//public var gatewayURL:String = "http://localhost:8700/flex/messagebroker/amf";
// case2: Tomcat
public var gatewayURL:String ="http://localhost:8080/s2flex2-fds-example/messagebroker/amf";

public function calculateResult(result:String):void {
    sum.text = result;
}

public function calculate2Result(result:Object):void {
	var addDto:AddDto = result as AddDto;
    sum.text = String(result.sum);
}

public function calcButtonClick():void {
    var conn:NetConnection = new NetConnection();
    conn.objectEncoding = ObjectEncoding.AMF0;
    conn.connect(gatewayURL);
    var r:Responder = new Responder(calculateResult);
    conn.call("addService.calculate", r, arg1.text, arg2.text);
}

public function calcButton2Click():void {
    var conn:NetConnection = new NetConnection();
    conn.objectEncoding = ObjectEncoding.AMF0;
    conn.connect(gatewayURL);
    var r:Responder = new Responder(calculate2Result);
    var dto:AddDto = new AddDto();
    dto.arg1 = int(arg1.text);
    dto.arg2 = int(arg2.text);
    conn.call("addService.calculate2", r, dto);
}