package examples.command.behavior
{
    import examples.command.command.SampleCommand;
    import examples.command.helper.RootHelper;
    
    import org.seasar.akabana.yui.command.SequenceCommand;
    import org.seasar.akabana.yui.command.WaitCommand;
    import org.seasar.akabana.yui.command.core.ICommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;
    import org.seasar.akabana.yui.core.ns.handler;
    
    public class RootCmd3Behavior
    {
        public var helper:RootHelper;
        
        /** 自作サンプルコマンド */        
        public var cmd3:SampleCommand;
        
        public function RootCmd3Behavior(){
        }

        handler function runCommand3_click():void{
            //コマンドスタート
            cmd3.start();
        }
        
        /**
         * cmd3コマンドの完了イベントハンドラ
         */
        handler function cmd3_complete(event:CommandEvent):void{
            trace(3,event);
        }
        
        /**
         * cmd3コマンドのエラーイベントハンドラ
         */
        handler function cmd3_error(event:CommandEvent):void{
            trace(3,event);
        }
    }
}