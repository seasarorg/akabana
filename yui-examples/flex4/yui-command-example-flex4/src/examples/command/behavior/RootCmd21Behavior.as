package examples.command.behavior
{
    import examples.command.command.StringDecorateCommand;
    import examples.command.helper.RootHelper;
    
    import org.seasar.akabana.yui.command.SequenceCommand;
    import org.seasar.akabana.yui.command.WaitCommand;
    import org.seasar.akabana.yui.command.core.ICommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;
    import org.seasar.akabana.yui.core.ns.handler;
    
    public class RootCmd21Behavior
    {
        public var helper:RootHelper;
        
        public var cmd21:ICommand;
        
        public function RootCmd21Behavior(){
            //一時停止コマンドを生成
            cmd21 = new SequenceCommand()
                        .add(new StringDecorateCommand())
                        .add(new StringDecorateCommand())
                        .add(new StringDecorateCommand());
        }

        handler function runCommand21_click():void{
            //コマンドスタート
            cmd21.start("ORIGINAL");
        }
        
        /**
         * cmd2コマンドの完了イベントハンドラ
         */
        handler function cmd21_complete(event:CommandEvent):void{
            trace(2,event);
        }
        
        /**
         * cmd2コマンドのエラーイベントハンドラ
         */
        handler function cmd21_error(event:CommandEvent):void{
            trace(2,event);
        }
    }
}