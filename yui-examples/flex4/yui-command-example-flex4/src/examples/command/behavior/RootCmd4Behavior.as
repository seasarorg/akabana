package examples.command.behavior
{
    import examples.command.command.SampleSwitchCommand;
    import examples.command.helper.RootHelper;
    import examples.command.model.DataModel;
    
    import org.seasar.akabana.yui.command.SequenceCommand;
    import org.seasar.akabana.yui.command.WaitCommand;
    import org.seasar.akabana.yui.command.core.ICommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;
    import org.seasar.akabana.yui.core.ns.handler;
    
    public class RootCmd4Behavior
    {
        public var helper:RootHelper;
        
        /** 自作サンプルコマンド */        
        public var cmd4:SampleSwitchCommand;
        
        public function RootCmd4Behavior(){
        }

        handler function runCommand4_click():void{
            //コマンドスタート
            var model:DataModel = new DataModel();
            cmd4.start(model);
        }
        
        /**
         * cmd3コマンドの完了イベントハンドラ
         */
        handler function cmd4_complete(e:CommandEvent):void{
            trace(4,cmd4.result.type,cmd4.argument.type);
        }
        
        /**
         * cmd3コマンドのエラーイベントハンドラ
         */
        handler function cmd4_error():void{
            trace(4,cmd4.status);
        }
    }
}