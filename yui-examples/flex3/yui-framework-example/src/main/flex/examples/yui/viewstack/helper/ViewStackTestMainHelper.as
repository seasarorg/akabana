package examples.yui.viewstack.helper
{
    import examples.yui.viewstack.view.ViewStackTestMainView;

    import mx.containers.ViewStack;

    public class ViewStackTestMainHelper
    {
        public var view:ViewStackTestMainView;

        public function ViewStackTestMainHelper()
        {
        }

        public function next():void{
            var vs:ViewStack = view.owner as ViewStack;
            vs.selectedIndex++;
        }
    }
}