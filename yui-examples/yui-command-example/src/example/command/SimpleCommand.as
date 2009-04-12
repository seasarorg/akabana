package example.command
{
    import org.seasar.akabana.yui.command.core.impl.AbstractCommand;
    
    public class SimpleCommand extends AbstractCommand
    {
        protected override function doRun(...args):void{
            trace("command:",this);
            complete("value");            
        }        
    }
}