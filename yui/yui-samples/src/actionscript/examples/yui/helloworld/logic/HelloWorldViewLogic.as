package examples.yui.helloworld.logic
{
    import examples.yui.helloworld.view.HelloWordView;
    import flash.events.MouseEvent;
    import mx.controls.Alert;
    
    public class HelloWorldViewLogic {
        
        [View]
        public var helloWorldView:HelloWordView;

        public function onDoubleClickHandler( event:MouseEvent ):void{
            Alert.show("ダブルクリック","めっせーじ",4.0,helloWorldView);
        }
        
        public function helloWorldPanelClickHandler( event:MouseEvent ):void{
            Alert.show("クリック","めっせーじ",4.0,helloWorldView);
        }
        
        public function showHelloWorldClickHandler( event:MouseEvent ):void{
            Alert.show("ハローワールド","めっせーじ",4.0,helloWorldView);
        }
    }
}