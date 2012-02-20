package examples.command.command
{
    import org.seasar.akabana.yui.command.Command;

    public class TraceCommand extends Command
    {
        protected override function run():void{
            trace(argument);
        }
    }
}