package
{
    import example.StatefullData;
    
    import flash.display.Sprite;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.net.URLRequest;
    import flash.utils.getTimer;
    
    import org.seasar.akabana.yui.command.ConditionalCommand;
    import org.seasar.akabana.yui.command.SequenceCommand;
    import org.seasar.akabana.yui.command.URLLoaderCommand;
    import org.seasar.akabana.yui.command.WaitCommand;
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class testYuiCommand extends Sprite {

        public var nextfile:URLRequest;

        public function testYuiCommand(){
            
//            var command1:Command = new URLLoaderCommand()
//                .setCompleteEventListener(commandCompleteHandler)
//                .start(new URLRequest("a.txt"));

//            var command2:Command = new URLLoaderCommand()
//                .setCompleteEventListener(commandCompleteHandler)
//                .setErrorEventListener(commandErrorHandler)
//                .start(new URLRequest("b.txt"));
                
//            var s:Command = new SequenceCommand()
//                .addCommand(
//                        new URLLoaderCommand(new URLRequest("a.txt"))
//                            .setCompleteEventListener(commandCompleteHandler)    
//                    )
//                .addCommand(new NextStartCommand(500))
//                .addCommand(new URLLoaderCommand(new URLRequest("a1.txt")))
//                .addCommand(new NextStartCommand(500))
//                .addCommand(new URLLoaderCommand(new URLRequest("a2.txt")))   
//                //子コマンドのコンプリートイベントハンドラ             
//                //.setChildCompleteEventListener(commandCompleteHandler)                             
//                
//                .setCompleteEventListener(pcommandCompleteHandler)
//                
//                .setErrorEventListener(commandErrorHandler)
//                
//                .start();

//            s = new MultiURLLoaderCommand("a.txt")
//                    .setChildCompleteEventListener(commandCompleteHandler)
//                    .setCompleteEventListener(pcommandCompleteHandler)
//                    .setErrorEventListener(commandErrorHandler)
//                    .start();
                            
//            var p:Command = new ParallelCommand()
//                .addCommand(command)
//                .addCommand(command)
//                .addCommand(command)
//                .addCommand(command)
//                .addCommand(command)
//                .addCommand(command)
//                .setCompleteEventListener(commandCompleteHandler)
//                .start();
//            

            var s:Command = new SequenceCommand()
                .addNamedCommand(
                        "namedcommand",
                        new URLLoaderCommand(
                            new URLRequest("a.txt")
                        )
                    )
                .addCommand(
                        new ConditionalCommand()
                            .setTarget(new StatefullData())
                            .addCaseCommand("1",new WaitCommand(100))
                            .addCaseCommand("2",new WaitCommand(200))
                            .addCaseCommand("3",new WaitCommand(400))
                            .addCaseCommand("4",new WaitCommand(800))
                            .setDefaultCommand(new WaitCommand(1000))
                    )
                .setChildCompleteEventListener(commandCompleteHandler)                 
                .setCompleteEventListener(commandCompleteHandler)
                .setErrorEventListener(commandErrorHandler)         
                .start();

//                
//            var h:Command = new SequenceCommand()
//                .addCommand(
//                        new AsyncServiceCommand( getData( "1" ))
//                            .setCompleteEventListener(commandCompleteHandler)
//                    )       
//                .addCommand(
//                        new AsyncServiceCommand( getData( "2" ))
//                            .setCompleteEventListener(commandCompleteHandler)
//                    )       
//                .start();          
        }

        public function commandCompleteHandler(event:CommandEvent):void{
            trace(getTimer()+"<c>"+event.command);
        }

        public function commandErrorHandler(event:CommandEvent):void{
            trace(getTimer()+"<e>"+event);
        }        
                
        public function pcommandCompleteHandler(event:CommandEvent):void{
            trace(getTimer()+"<p>"+event);
        }
        
        public function getData(str:String):IEventDispatcher{
            return new EventDispatcher();
        }
        
        public var registerCommand:Command;//RegisterCommand
        
        public function registerCommandCompleteHandler(event:Command):void{
            
        }
    }
}
