package
{
    import example.command.SimpleAsyncCommand;
    
    import flash.display.Sprite;
    import flash.text.TextField;
    
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class testSimpleAsyncCommand extends Sprite {

        private var textfiled:TextField;

        public function testSimpleAsyncCommand(){
            var command1:Command = 
                new SimpleAsyncCommand()
                    .complete(commandCompleteHandler)
                    .error(commandErrorHandler)
                    .start();  
            
            command1.start();
            
            textfiled = new TextField();
            
            addChild(textfiled);      
        }

        public function commandCompleteHandler(event:CommandEvent):void{
            textfiled.text = event.toString();
        }

        public function commandErrorHandler(event:CommandEvent):void{
            textfiled.text = event.toString();
        }
    }
}
