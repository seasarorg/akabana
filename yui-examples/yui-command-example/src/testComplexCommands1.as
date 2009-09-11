package
{
    import example.command.StatefulURLLoaderCommand;
    
    import flash.display.Sprite;
    import flash.net.URLRequest;
    import flash.utils.getTimer;
    
    import org.seasar.akabana.yui.command.ConditionalCommand;
    import org.seasar.akabana.yui.command.ParallelCommand;
    import org.seasar.akabana.yui.command.SequenceCommand;
    import org.seasar.akabana.yui.command.URLLoaderCommand;
    import org.seasar.akabana.yui.command.WaitCommand;
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class testComplexCommands1 extends Sprite {

        public function testComplexCommands1(){
            
            var s:Command = new SequenceCommand()
                .add(new WaitCommand(250))
                .add(
                    new StatefulURLLoaderCommand(
                        new URLRequest("http://127.0.0.1/a.txt")
                        ),
                    "namedcommand"
                    )
                .add(
                    new ConditionalCommand()
                        .setTargetByName("namedcommand")
                        .addCaseCommand("1",new WaitCommand(100))
                        .addCaseCommand("2",new WaitCommand(200))
                        .addCaseCommand("3",new WaitCommand(400))
                        .addCaseCommand("4",new WaitCommand(800))
                        .setDefaultCommand(new WaitCommand(1000))
                        .complete(childCommandCompleteHandler)
                    )
                .add(
                    new ParallelCommand()
                        .add(
                            new URLLoaderCommand(
                                new URLRequest("http://127.0.0.1/a11.txt?"+getTimer())
                                )
                            )
                        .add(
                            new URLLoaderCommand(
                                new URLRequest("http://127.0.0.1/a2.txt?"+getTimer())
                                )
                            )
                        .add(
                            new URLLoaderCommand(
                                new URLRequest("http://127.0.0.1/a3.txt?"+getTimer())
                                )
                            )
                        .complete(urlLoaderCommandCompleteHandler)
                    )    
                .childComplete(childCommandCompleteHandler)          
                .childError(childCommandErrorHandler)
                .complete(commandCompleteHandler)
                .error(commandErrorHandler)         
                .start();

   
        }

        public function commandCompleteHandler(event:CommandEvent):void{
            log("p complete:",event.command);
        }

        public function commandErrorHandler(event:CommandEvent):void{
            log("p error:",event.command);
        } 
        
        public function childCommandCompleteHandler(event:CommandEvent):void{
            log("c complete:",event.command);
        }  
        
        public function childCommandErrorHandler(event:CommandEvent):void{
            log("c error:",event.command);
        }  
                
        public function urlLoaderCommandCompleteHandler(event:CommandEvent):void{
            log("loaded",event.command,(event.command as URLLoaderCommand).getRequest().url);
        }
        
        
    }
}