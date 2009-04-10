package
{
    import example.command.SimpleCommand;
    
    import flash.display.Sprite;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.utils.getTimer;
    
    import org.seasar.akabana.yui.command.SequenceCommand;
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class testNestSequenceCommand extends Sprite {

        public function testNestSequenceCommand(){
              
            var s:Command = new SequenceCommand()
                .addCommand(new SimpleCommand())
                .addCommand(new SimpleCommand())
                .addCommand(
                    new SequenceCommand()
                        .addCommand(new SimpleCommand())
                        .addCommand(new SimpleCommand())
                        .addCommand(new SimpleCommand())
                        .setChildCompleteEventListener(childCommandCompleteHandler) 
                    )
                .addCommand(new SimpleCommand())
                .addCommand(new SimpleCommand())
                .setChildCompleteEventListener(childCommandCompleteHandler)                 
                .setCompleteEventListener(commandCompleteHandler)
                .setErrorEventListener(commandErrorHandler)         
                .start();         
        }

        public function childCommandCompleteHandler(event:CommandEvent):void{
            trace(getTimer()+"child"+event);
        }

        public function commandCompleteHandler(event:CommandEvent):void{
            trace(getTimer()+event);
        }        
                
        public function commandErrorHandler(event:CommandEvent):void{
            trace(getTimer()+event);
        }
    }
}
