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
                .add(new SimpleCommand())
                .add(new SimpleCommand())
                .add(new SimpleCommand())
                .add(new SimpleCommand())
                .add(new SimpleCommand())
                .childComplete(childCommandCompleteHandler)                 
                .complete(commandCompleteHandler)
                .error(commandErrorHandler)         
                .start();
        }

        public function childCommandCompleteHandler(event:CommandEvent):void{
            log("child:",event,"parent is " + event.command);
        }
        
        public function commandCompleteHandler(event:CommandEvent):void{
            log("parent:",event);
        }        
                
        public function commandErrorHandler(event:CommandEvent):void{
            log("parent:",event);
        }
    }
}
