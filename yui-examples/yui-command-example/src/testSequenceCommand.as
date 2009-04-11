package
{
    import example.command.SimpleCommand;
    import example.command.SimpleSubCommand;
    
    import flash.display.Sprite;
    
    import org.seasar.akabana.yui.command.SequenceCommand;
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class testSequenceCommand extends Sprite {

        public function testSequenceCommand(){
              
            var s:Command = new SequenceCommand()
                .addCommand(new SimpleCommand())
                .addCommand(new SimpleCommand())
                .addCommand(new SimpleCommand())
                .addCommand(new SimpleCommand())
                .addCommand(new SimpleCommand())
                .setChildCompleteEventListener(childCommandCompleteHandler)                 
                .setCompleteEventListener(commandCompleteHandler)
                .setErrorEventListener(commandErrorHandler)         
                .start();         
        }

        public function childCommandCompleteHandler(event:CommandEvent):void{
            log("child:",event,"parent is " + (event.command as SimpleSubCommand).parent);
        }
        
        public function commandCompleteHandler(event:CommandEvent):void{
            log("parent:",event);
        }        
                
        public function commandErrorHandler(event:CommandEvent):void{
            log("parent:",event);
        }
    }
}
