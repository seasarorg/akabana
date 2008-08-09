package examples.yui.helloworld.action
{
    import examples.yui.helloworld.helper.HelloWorldHelper;
    
    import flash.events.MouseEvent;
    
    import org.seasar.akabana.yui.framework.event.FrameworkEvent;
    
    public class HelloWorldAction {
        
        public var helloWorldHelper:HelloWorldHelper;
        
        public function onApplicationStartHandler( event:FrameworkEvent ):void{
            trace( event );
        }
        
        public function showHelloWorldClickHandler( event:MouseEvent ):void{
            helloWorldHelper.showAlert("showHelloWorldクリックされました。");
        }
    }
}