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
                .add(new WaitCommand(500))
                .add(new SimpleCommand())
                .add(new WaitCommand(1000))
                .childComplete(childCommandCompleteHandler)                 
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
