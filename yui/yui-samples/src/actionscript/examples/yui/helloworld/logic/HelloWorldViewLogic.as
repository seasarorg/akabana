package examples.yui.helloworld.logic
{
    import examples.yui.helloworld.view.HelloWordView;
    import flash.events.MouseEvent;
    import mx.controls.Alert;
    
    public class HelloWorldViewLogic {
        
        [View]
        public var helloWorldView:HelloWordView;
        
        public function showHelloWorldClickHandler( event:MouseEvent ):void{
            Alert.show("はろーわーるど","めっせーじ",4.0,helloWorldView);
        }
    }
}