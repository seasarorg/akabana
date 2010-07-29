package example.command
{
    import org.seasar.akabana.yui.command.core.impl.AbstractCommand;
    
    public class SimpleCommand extends AbstractCommand
    {
        protected override function run(...args):void{
            trace("command:",this);
            done("value");            
        }        
    }
}