package examples.command.command
{
    import org.seasar.akabana.yui.command.Command;

    public class TraceCommand extends Command
    {
        protected override function run(...args):void{
            result = args[0];
            trace(args);
        }
    }
}