package examples.yui.helloworld.action
{
    import examples.yui.helloworld.helper.HelloWorldHelper;
    
    import flash.events.MouseEvent;
    
    import mx.controls.Alert;
    
    public class HelloWorldAction {
        
        public var helloWorldHelper:HelloWorldHelper;
        
        public function showHelloWorldClickHandler( event:MouseEvent ):void{
            helloWorldHelper.showAlert("showHelloWorldクリックされました。");
        }
    }
}