package
{
    import example.command.SimpleCommand;
    
    import flash.display.Sprite;
    import flash.utils.getTimer;
    
    import org.seasar.akabana.yui.command.ParallelCommand;
    import org.seasar.akabana.yui.command.WaitCommand;
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class testParallelCommand extends Sprite {

        public function testParallelCommand(){
              
            var s:Command = new ParallelCommand()
                .addCommand(new WaitCommand(100))
                .addCommand(new WaitCommand(200))
                .addCommand(new WaitCommand(800))
                .setChildCompleteEventListener(childCommandCompleteHandler)                 
                .setCompleteEventListener(commandCompleteHandler)
                .setErrorEventListener(commandErrorHandler)         
                .start();         
        }

        public function childCommandCompleteHandler(event:CommandEvent):void{
            log("child:",event);
        }

        public function commandCompleteHandler(event:CommandEvent):void{
            log("parent:",event);
        }        
                
        public function commandErrorHandler(event:CommandEvent):void{
            log("parent:",event);
        }
    }
}
