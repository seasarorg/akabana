
import mx.rpc.events.ResultEvent;
import mx.rpc.events.FaultEvent;
import mx.controls.Alert;
import mx.collections.ArrayCollection;
    
public function onResult(event:ResultEvent):void{
    datagrid.dataProvider = new ArrayCollection( event.result as Array );
    endTime = new Date();
    elapsedTime = endTime.getTime() - startTime.getTime();
}
public function onFault(event:FaultEvent):void{
	Alert.show("error=" +event);
}