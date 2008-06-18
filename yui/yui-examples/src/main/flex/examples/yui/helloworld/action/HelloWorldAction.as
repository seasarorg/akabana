package examples.yui.helloworld.action
{
    import examples.yui.helloworld.helper.HelloWorldHelper;
    
    import flash.events.MouseEvent;
    
    import mx.controls.Alert;
    
    public class HelloWorldAction {
        
        public var helloWorldHelper:HelloWorldHelper;

        public function onDoubleClickHandler( event:MouseEvent ):void{
            helloWorldHelper.showAlert("Viewダブルクリックされました。");
        }
        
        public function helloWorldPanelClickHandler( event:MouseEvent ):void{
            helloWorldHelper.showAlert("helloWorldPanelクリックされました。");
        }
        
        public function showHelloWorldClickHandler( event:MouseEvent ):void{
            helloWorldHelper.showAlert("showHelloWorldクリックされました。");
        }
        
        public function showHelloAddWorldClickHandler( event:MouseEvent ):void{
            helloWorldHelper.showAlert("showHelloAddWorldクリックされました。");
        }        
    }
}