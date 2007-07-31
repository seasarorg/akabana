package examples.yui.helloworld.logic
{
    import examples.yui.helloworld.view.DynamicHelloWorldView;
    
    import flash.events.MouseEvent;
    import examples.yui.helloworld.view.HelloWorldView;
    
    public class DynamicHelloWorldViewLogic {
        
        [View]
        public var dynamicHelloWorldView:DynamicHelloWorldView;

        public function createViewClickHandler( event:MouseEvent ):void{
            var helloWorldView:HelloWorldView = new HelloWorldView();
            helloWorldView.name = "helloWorldView";
            dynamicHelloWorldView.parent.addChild(helloWorldView);
        }
    }
}