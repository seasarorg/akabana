package examples.yui.helloworld.helper
{
    import examples.yui.helloworld.view.HelloWorldView;
    
    import mx.controls.Alert;
    import mx.events.EffectEvent;
    
    public class HelloWorldHelper
    {
        public var view:HelloWorldView;
                
        public function showAlert( message:String ):void{
            Alert.show(message,"message");
            view.currentState = "hideButtonState";
        }

        public function disableButton():void{
            view.showHelloWorld.enabled = false;
            view.showHelloWorld.label = "";
        }
    }
}