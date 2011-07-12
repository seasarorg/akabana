package examples.command.behavior
{
    import examples.command.helper.RootHelper;
    
    import org.seasar.akabana.yui.command.SequenceCommand;
    import org.seasar.akabana.yui.command.WaitCommand;
    import org.seasar.akabana.yui.command.core.ICommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;
    import org.seasar.akabana.yui.core.ns.handler;
    
    public class RootCmd2Behavior
    {
        public var helper:RootHelper;
        
        public var cmd2:ICommand;
        
        public function RootCmd2Behavior(){
            //一時停止コマンドを生成
            cmd2 = new SequenceCommand()
                        .add(new WaitCommand(300))
                        .add(new WaitCommand(500));
        }

        handler function runCommand2_click():void{
            //コマンドスタート
            cmd2.start();
        }
        
        /**
         * cmd2コマンドの完了イベントハンドラ
         */
        handler function cmd2_complete(event:CommandEvent):void{
            trace(2,event);
        }
        
        /**
         * cmd2コマンドのエラーイベントハンドラ
         */
        handler function cmd2_error(event:CommandEvent):void{
            trace(2,event);
        }
    }
}