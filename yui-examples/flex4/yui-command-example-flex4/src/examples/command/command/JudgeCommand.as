package examples.command.command
{
    import examples.command.model.DataModel;
    
    import org.seasar.akabana.yui.command.AsyncCommand;
    import org.seasar.akabana.yui.command.Command;

    public class JudgeCommand extends AsyncCommand
    {
        protected override function runAsync():void{
            var data:DataModel = argument as DataModel;
            
            if( data.value > 50 ){
                data.type = "high!!!";
            } else {
                data.type = "low";
            }
            
            doneAsync();
        }
    }
}