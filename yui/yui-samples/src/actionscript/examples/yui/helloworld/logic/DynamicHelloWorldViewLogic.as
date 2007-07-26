package examples.yui.helloworld.logic
{
    import examples.yui.helloworld.view.DynamicHelloWorldView;
    
    import flash.events.MouseEvent;
    import examples.yui.helloworld.view.HelloWordView;
    
    public class DynamicHelloWorldViewLogic {
        
        [View]
        public var dynamicHelloWorldView:DynamicHelloWorldView;

        public function createViewClickHandler( event:MouseEvent ):void{
            var helloWorldView:HelloWordView = new HelloWordView();
            helloWorldView.name = "helloWorldView";
            dynamicHelloWorldView.parent.addChild(helloWorldView);
        }
    }
}