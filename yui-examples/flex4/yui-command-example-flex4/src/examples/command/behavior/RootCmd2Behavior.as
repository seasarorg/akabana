package examples.command.behavior
{
    import examples.command.helper.RootHelper;
    
    import org.seasar.akabana.yui.command.WaitCommand;
    import org.seasar.akabana.yui.command.core.ICommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;
    import org.seasar.akabana.yui.core.ns.handler;
    
    public class RootCmd2Behavior
    {
        public var helper:RootHelper;
        
        public var cmd2:ICommand;
        
        public function RootCmd2Behavior(){
            cmd2 = new WaitCommand(1000);
        }

        handler function runCommand2_click():void{
            cmd2.start();
        }
        
        handler function cmd2_complete(event:CommandEvent):void{
            trace(event);
        }
        
        handler function cmd2_error(event:CommandEvent):void{
            trace(event);
        }
    }
}