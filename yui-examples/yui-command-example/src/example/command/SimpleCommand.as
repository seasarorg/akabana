package example.command
{
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.core.impl.AbstractCommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class SimpleCommand extends AbstractCommand
    {
        public override function start(...args):Command
        {
            trace("command:",this);
            dispatchCompleteEvent("value");            
            return this;
        }        
    }
}