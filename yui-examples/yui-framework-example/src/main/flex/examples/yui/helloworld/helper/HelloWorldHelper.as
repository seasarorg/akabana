package examples.yui.helloworld.helper
{
    import examples.yui.helloworld.view.HelloWorldView;
    
    import mx.controls.Alert;
    
    import org.seasar.akabana.yui.framework.message.MessageManager;
    
    public class HelloWorldHelper
    {
        public var view:HelloWorldView;
                
        public function showAlert( message:String ):void{
            Alert.show(
                message,
                MessageManager.application.alert
                );
            view.currentState = "hideButtonState";
        }

        public function disableButton():void{
            view.showHelloWorld.enabled = false;
            view.showHelloWorld.label = "";
        }
    }
}