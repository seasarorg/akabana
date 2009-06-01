package example.command
{
    import org.seasar.akabana.yui.command.core.impl.AbstractSubCommand;

    public class SimpleSubCommand extends AbstractSubCommand
    {
        
        protected override function run(...args):void
        {
            done("value");
        }        
    }
}