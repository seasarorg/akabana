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

        handler function runCommand4_click():void{
            //コマンドスタート
            var model:DataModel = new DataModel();
            cmd4.start(model);    
        }
        
        /**
         * 
         * @param event コマンドの実行結果
         */
        handler function cmd4_complete(event:CommandEvent):void{
            trace("[COMPLETE:cmd4]"+event.data);
        }
        
        /**
         * 
         * @param event コマンドの実行エラー
         */
        handler function cmd4_error(event:CommandEvent):void{
            trace("[ERROR:cmd4]"+event);
        }
    }
}