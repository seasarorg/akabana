package example.command
{
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.core.impl.AbstractCommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class SimpleErrorCommand extends AbstractCommand
    {
        public override function start(...args):Command
        {
            dispatchErrorEvent("error message");            
            return this;
        }        
    }
}