package examples.command.command
{
    import org.seasar.akabana.yui.command.SequenceCommand;
    import org.seasar.akabana.yui.command.SwitchCommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;
    
    public class SampleSwitchCommand extends SequenceCommand
    {
        public function SampleSwitchCommand()
        {
            super();
            add( new RandomDataCommnad() );
            add(
                new SwitchCommand()
                    .caseCommand( "high", new TraceCommand())
                    .caseCommand( "low", new TraceCommand())
                    .complete(on_completeHandler)
            )
            .complete(on_completeHandler);
        }
        
        private function on_completeHandler(event:CommandEvent):void
        {
            trace(event.command);
        }
    }
}