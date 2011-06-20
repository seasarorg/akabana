package examples.command.command
{
    import org.seasar.akabana.yui.command.WaitCommand;
    
    public class SampleCommand extends WaitCommand
    {
        public function SampleCommand(sleep:int=1000)
        {
            super(sleep);
        }
    }
}