package examples.yui.helloworld.helper
{
    import examples.yui.helloworld.view.HelloWorldView;
    
    import mx.controls.Alert;
    
    public class HelloWorldHelper
    {
        public var view:HelloWorldView;
        
        
        public function showAlert( message:String ):void{
            Alert.show(message,"message");
        }

    }
}