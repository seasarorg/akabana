package
{
    import example.command.SimpleSubCommand;
    
    import flash.display.Sprite;
    import flash.utils.getTimer;
    
    import org.seasar.akabana.yui.command.SequenceCommand;
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class testSequenceCommandAndSubCommand extends Sprite {

        public function testSequenceCommandAndSubCommand(){
              
            var s:Command = new SequenceCommand()
                .add(new SimpleSubCommand())
                .add(new SimpleSubCommand())
                .add(new SimpleSubCommand())
                .add(new SimpleSubCommand())
                .add(new SimpleSubCommand())
                .childComplete(childCommandCompleteHandler)                 
                .complete(commandCompleteHandler)
                .error(commandErrorHandler)         
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
