package examples.command.behavior
{
    import examples.command.helper.RootHelper;
    
    import org.seasar.akabana.yui.command.WaitCommand;
    import org.seasar.akabana.yui.command.core.ICommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;
    import org.seasar.akabana.yui.core.ns.handler;
    
    public class RootCmd1Behavior
    {
        public var helper:RootHelper;
        
        public var cmd1:ICommand;
        
        public function RootCmd1Behavior(){
            cmd1 = new WaitCommand(1000).name("command1");
        }

        handler function runCommand1_click():void{
            cmd1.listener(this).start();
        }
        
        handler function command1_complete(event:CommandEvent):void{
            trace(event);
        }
        
        handler function command1_error(event:CommandEvent):void{
            trace(event);
        }
    }
}