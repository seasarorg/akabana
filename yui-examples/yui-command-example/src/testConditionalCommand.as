package
{
    import example.StatefullData;
    import example.command.SimpleCommand;
    import example.command.TraceCommand;
    
    import flash.display.Sprite;
    import flash.utils.getTimer;
    
    import org.seasar.akabana.yui.command.ConditionalCommand;
    import org.seasar.akabana.yui.command.SequenceCommand;
    import org.seasar.akabana.yui.command.WaitCommand;
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class testConditionalCommand extends Sprite {

        public function testConditionalCommand(){
              
            var s:Command = new SequenceCommand()
                .add(new WaitCommand(500))
                .add(
                    new ConditionalCommand()
                        .setTarget(new StatefullData())
                        .addCaseCommand("1",new TraceCommand("1"))
                        .addCaseCommand("2",new TraceCommand("2"))
                        .addCaseCommand("3",new TraceCommand("3"))
                        .setDefaultCommand(new WaitCommand(1000))
                    )
                .add(new SimpleCommand())
                .complete(commandCompleteHandler)
                .error(commandErrorHandler)         
                .start();
        }

        public function childCommandCompleteHandler(event:CommandEvent):void{
            log("child"+event);
        }

        public function commandCompleteHandler(event:CommandEvent):void{
            log(event);
        }        
                
        public function commandErrorHandler(event:CommandEvent):void{
            log(event);
        }
    }
}
