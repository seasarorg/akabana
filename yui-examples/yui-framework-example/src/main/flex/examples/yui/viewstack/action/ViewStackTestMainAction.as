package examples.yui.viewstack.action
{
    import examples.yui.viewstack.helper.ViewStackTestMainHelper;

    public class ViewStackTestMainAction
    {
        public var helper:ViewStackTestMainHelper;

        public function ViewStackTestMainAction()
        {
        }

        public function nextButton_clickHandler():void{
            trace("nextButton");
            helper.next();
        }

    }
}