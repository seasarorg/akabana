package example.command
{
    import org.seasar.akabana.yui.command.core.impl.AbstractCommand;

    public class SimpleErrorCommand extends AbstractCommand
    {
        protected override function run(...args):void
        {
            failed("error message");            
        }        
    }
}