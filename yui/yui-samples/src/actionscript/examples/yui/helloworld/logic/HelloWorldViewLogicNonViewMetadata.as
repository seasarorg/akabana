package examples.yui.helloworld.logic
{
    import examples.yui.helloworld.view.HelloWorldView;
    import flash.events.MouseEvent;
    import mx.controls.Alert;
    
    public class HelloWorldViewLogicNonViewMetadata {

        public function onDoubleClickHandler( event:MouseEvent ):void{
            Alert.show("ダブルクリック","めっせーじ",4.0);
        }
        
        public function helloWorldPanelClickHandler( event:MouseEvent ):void{
            Alert.show("クリック","めっせーじ",4.0);
        }

        public function showHelloWorldClickHandler( event:MouseEvent ):void{
            Alert.show("ハローワールド View Metadaなし","めっせーじ",4.0);
        }
    }
}