package examples.command.action
{
    import examples.command.behavior.RootCmd1Behavior;
    import examples.command.behavior.RootCmd2Behavior;
    import examples.command.helper.RootHelper;
    
    import org.seasar.akabana.yui.command.WaitCommand;
    import org.seasar.akabana.yui.command.core.ICommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;
    import org.seasar.akabana.yui.core.ns.handler;
    
    public class RootAction
    {
        public var cmd1:RootCmd1Behavior;
        public var cmd2:RootCmd2Behavior;
    }
}