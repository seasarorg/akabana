package examples.command.command
{
    import org.seasar.akabana.yui.command.CallBackCommand;
    import org.seasar.akabana.yui.command.SequenceCommand;
    import org.seasar.akabana.yui.command.SwitchCommand;
    import org.seasar.akabana.yui.command.WaitCommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;
    
    public class SampleSwitchCommand extends SequenceCommand
    {
        public function SampleSwitchCommand()
        {
            super();
            add( new RandomDataCommnad() );
            add( new SwitchCommand()
                    .caseCommand( "high", new CallBackCommand(highHandler))
                    .caseCallBack( "low", lowHandler )
            )
            add( new WaitCommand(1000));
        }
        
        private function highHandler(data:Object):String
        {
            return data.toString()+"!!!!";
        }
        private function lowHandler(data:Object):void
        {
            trace(data);
        }
    }
}