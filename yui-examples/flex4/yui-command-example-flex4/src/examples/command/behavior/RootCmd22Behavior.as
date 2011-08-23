package examples.command.behavior
{
    import examples.command.command.JudgeCommand;
    import examples.command.command.TraceCommand;
    import examples.command.helper.RootHelper;
    import examples.command.model.DataModel;
    
    import org.seasar.akabana.yui.command.SequenceCommand;
    import org.seasar.akabana.yui.command.core.ICommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;
    import org.seasar.akabana.yui.core.ns.handler;
    
    public class RootCmd22Behavior
    {
        public var helper:RootHelper;
        
        public var cmd22:ICommand;
        
        public function RootCmd22Behavior(){
            //一時停止コマンドを生成
            cmd22 = new SequenceCommand()
                        .add(new JudgeCommand())
                        .add(new TraceCommand());
        }

        handler function runCommand22_click():void{
            //コマンドスタート
            var data:DataModel = new DataModel();
            data.value = Math.random()*100;
            
            cmd22.start(data);
        }
        
        /**
         * cmd2コマンドの完了イベントハンドラ
         */
        handler function cmd22_complete(event:CommandEvent):void{
            trace(2,event);
        }
        
        /**
         * cmd2コマンドのエラーイベントハンドラ
         */
        handler function cmd22_error(event:CommandEvent):void{
            trace(2,event);
        }
    }
}