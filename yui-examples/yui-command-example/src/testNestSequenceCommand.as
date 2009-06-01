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
                .add(new SimpleCommand())
                .add(new SimpleCommand())
                .add(
                    new SequenceCommand()
                        .add(new SimpleCommand())
                        .add(new SimpleCommand())
                        .add(new SimpleCommand())
                        .childComplete(childCommandCompleteHandler) 
                    )
                .add(new SimpleCommand())
                .add(new SimpleCommand())
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
