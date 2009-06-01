package example.command
{
    import org.seasar.akabana.yui.command.AsyncCommand;
    
    
    public class SimpleAsyncCommand extends AsyncCommand
    {
        protected override function run(...args):void{
            trace("command:",this);
            done("value");            
        }        
    }
}