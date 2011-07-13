package examples.command.command
{
    import org.seasar.akabana.yui.command.CallBackCommand;
    import org.seasar.akabana.yui.command.SequenceCommand;
    import org.seasar.akabana.yui.command.SwitchCommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;
    
    public class SampleSwitchCommand extends SequenceCommand
    {
        public function SampleSwitchCommand()
        {
            super();
            add( new RandomDataCommnad() );
            add( new SwitchCommand()
                    .caseCommand( "high", new CallBackCommand(traceHandler))
                    .caseCallBack( "low", traceHandler )
            )
        }
        
        private function traceHandler(data:Object):Object
        {
            trace(data);
            return data;
        }
    }
}