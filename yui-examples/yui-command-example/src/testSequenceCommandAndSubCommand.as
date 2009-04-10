package
{
    import example.command.SimpleCommand;
    import example.command.SimpleSubCommand;
    
    import flash.display.Sprite;
    import flash.utils.getTimer;
    
    import org.seasar.akabana.yui.command.SequenceCommand;
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class testSequenceCommandAndSubCommand extends Sprite {

        public function testSequenceCommandAndSubCommand(){
              
            var s:Command = new SequenceCommand()
                .addCommand(new SimpleSubCommand())
                .addCommand(new SimpleSubCommand())
                .addCommand(new SimpleSubCommand())
                .addCommand(new SimpleSubCommand())
                .addCommand(new SimpleSubCommand())
                .setChildCompleteEventListener(childCommandCompleteHandler)                 
                .setCompleteEventListener(commandCompleteHandler)
                .setErrorEventListener(commandErrorHandler)         
                .start();         
        }

        public function childCommandCompleteHandler(event:CommandEvent):void{
            trace(getTimer()+event,"parent is " + (event.command as SimpleSubCommand).parent);
        }

        public function commandCompleteHandler(event:CommandEvent):void{
            trace(getTimer()+event);
        }        
                
        public function commandErrorHandler(event:CommandEvent):void{
            trace(getTimer()+event);
        }
    }
}
