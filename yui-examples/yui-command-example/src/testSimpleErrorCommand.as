package
{
    import example.command.SimpleErrorCommand;
    
    import flash.display.Sprite;
    import flash.utils.getTimer;
    
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class testSimpleErrorCommand extends Sprite {

        public function testSimpleErrorCommand(){
            var command1:Command = new SimpleErrorCommand()
                .setCompleteEventListener(commandCompleteHandler)
                .setErrorEventListener(commandErrorHandler)
                .start();        
        }

        public function commandCompleteHandler(event:CommandEvent):void{
            trace(getTimer()+event);
        }

        public function commandErrorHandler(event:CommandEvent):void{
            trace(getTimer()+event);
        }
    }
}
