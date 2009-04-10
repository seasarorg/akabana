package example.command
{
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.core.impl.AbstractSubCommand;

    public class SimpleSubCommand extends AbstractSubCommand
    {
        public override function start(...args):Command
        {
            dispatchCompleteEvent("value");            
            return this;
        }        
    }
}