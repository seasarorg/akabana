package examples.command.command
{
    import examples.command.model.DataModel;
    
    import org.seasar.akabana.yui.command.Command;
    
    public class RandomDataCommnad extends Command
    {
        protected override function run():void{
            var n:Number = Math.random()*100;
            
            var model:DataModel = argument as DataModel;
            
            if( n > 50 ){
                model.type = "high";
            } else {
                model.type = "low";
            }
            model.value = n;
            
            result = model;
        }
    }
}