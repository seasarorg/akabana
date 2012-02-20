package examples.yui.viewstack.helper
{
    import examples.yui.viewstack.view.ViewStackTestSubView;

    import mx.containers.ViewStack;

    public class ViewStackTestSubHelper
    {
        public var view:ViewStackTestSubView;

        public function ViewStackTestSubHelper()
        {
        }

        public function back():void{
            var vs:ViewStack = view.owner as ViewStack;
            vs.selectedIndex--;
        }

    }
}