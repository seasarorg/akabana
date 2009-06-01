package example.command
{
    import org.seasar.akabana.yui.command.core.impl.AbstractCommand;

    public class TraceCommand extends AbstractCommand
    {
        public var word:String;
        
        public function TraceCommand(str:String):void{
            this.word = str;    
        }
        
        protected override function run(...args):void
        {
            trace(this.word);
            done();
        }        
    }
}