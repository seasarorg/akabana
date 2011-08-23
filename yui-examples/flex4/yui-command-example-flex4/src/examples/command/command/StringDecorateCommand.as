package examples.command.command
{
    import org.seasar.akabana.yui.command.Command;

    public class StringDecorateCommand extends Command
    {
        protected override function run():void{
            result = "[" + argument + "]";
        }
    }
}