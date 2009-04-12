package example.command
{
    import org.seasar.akabana.yui.command.core.impl.AbstractCommand;

    public class SimpleErrorCommand extends AbstractCommand
    {
        protected override function doRun(...args):void
        {
            error("error message");            
        }        
    }
}