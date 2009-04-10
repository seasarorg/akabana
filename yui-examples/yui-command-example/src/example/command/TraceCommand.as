package example.command
{
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.core.impl.AbstractSubCommand;

    public class TraceCommand extends AbstractSubCommand
    {
        public var word:String;
        
        public function TraceCommand(str:String):void{
            this.word = str;    
        }
        
        public override function start(...args):Command
        {
            trace(this.word);
            dispatchCompleteEvent();            
            return this;
        }        
    }
}