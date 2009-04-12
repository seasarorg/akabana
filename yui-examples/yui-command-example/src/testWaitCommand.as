package
{
    import example.command.SimpleCommand;
    
    import flash.display.Sprite;
    import flash.utils.getTimer;
    
    import org.seasar.akabana.yui.command.SequenceCommand;
    import org.seasar.akabana.yui.command.WaitCommand;
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class testWaitCommand extends Sprite {

        public function testWaitCommand(){
              
            var s:Command = new SequenceCommand()
                .addCommand(new WaitCommand(500))
                .addCommand(new SimpleCommand())
                .addCommand(new WaitCommand(1000))
                .setChildCompleteEventListener(childCommandCompleteHandler)                 
                .setCompleteEventListener(commandCompleteHandler)
                .setErrorEventListener(commandErrorHandler)         
                .execute();
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
