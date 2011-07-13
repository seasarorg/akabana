package examples.command.command
{
    import org.seasar.akabana.yui.command.Command;
    
    public class RandomDataCommnad extends Command
    {
        protected override function run(...args):void{
            
            var n:Number = Math.random()*100;
            
            if( n > 50 ){
                result = "high";
            } else {
                result = "low";
            }
        }
    }
}