package
{
    import example.command.SimpleCommand;
    
    import flash.display.Sprite;
    import flash.net.URLRequest;
    import flash.utils.getTimer;
    
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class testSimpleCommand extends Sprite {

        public function testSimpleCommand(){
            var command1:Command = new SimpleCommand()
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
