package examples.yui.helloworld.logic
{
    import examples.yui.helloworld.view.HelloWorldView;
    import flash.events.MouseEvent;
    import mx.controls.Alert;
    
    public class HelloWorldAddViewLogic {
        
        [View]
        public var helloWorldView:HelloWorldAddView;

        public function onDoubleClickHandler( event:MouseEvent ):void{
        	trace("ダブルクリック","めっせーじ");
            Alert.show("ダブルクリック","めっせーじ",4.0,helloWorldView);
        }
        
        public function helloWorldPanelClickHandler( event:MouseEvent ):void{
        	trace("クリック","めっせーじ");
            Alert.show("クリック","めっせーじ",4.0,helloWorldView);
        }
        
        public function showHelloWorldClickHandler( event:MouseEvent ):void{
        	trace("ハローワールド","めっせーじ");
            Alert.show("ハローワールド","めっせーじ",4.0,helloWorldView);
            helloWorldView.removeChild(helloWorldView.helloWorldChildView);
        }
    }
}