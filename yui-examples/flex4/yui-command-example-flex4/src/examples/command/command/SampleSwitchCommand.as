package examples.command.command
{
    import examples.command.model.DataModel;
    
    import org.seasar.akabana.yui.command.CallBackCommand;
    import org.seasar.akabana.yui.command.SequenceCommand;
    import org.seasar.akabana.yui.command.SwitchCommand;
    import org.seasar.akabana.yui.command.WaitCommand;
    
    public class SampleSwitchCommand extends SequenceCommand
    {
        public function SampleSwitchCommand()
        {
            super();
            add( new RandomDataCommnad() );
            add( new SwitchCommand("type")
                    .caseCommand( "high", new CallBackCommand(highHandler))
                    .caseCallBack( "low", lowHandler )
            )
            add( new WaitCommand(1000));
        }
        
        private function highHandler(data:DataModel):void
        {
            data.type+="!!!!";
        }
        private function lowHandler(data:DataModel):void
        {
            trace(data);
        }
    }
}