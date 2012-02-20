package examples.yui.viewstack.action
{
    import examples.yui.viewstack.helper.ViewStackTestSubHelper;

    public class ViewStackTestSubAction
    {
        public var helper:ViewStackTestSubHelper;

        public function ViewStackTestSubAction()
        {
        }

        public function backButton_clickHandler():void
        {
            trace("backButton");
            helper.back();
        }

    }
}