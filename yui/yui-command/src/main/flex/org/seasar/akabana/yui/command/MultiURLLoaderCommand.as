package org.seasar.akabana.yui.command
{
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.core.ComplexCommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class MultiURLLoaderCommand extends SequenceCommand
    {
        private var configloader:URLLoaderCommand;
        
        private var fileloader:URLLoaderCommand;
        
        private var childDataFormat:String;
        
        private var configUrl:String;
        
        private var configList:Array;
        
        private var configIndex:int;

        public function MultiURLLoaderCommand(configUrl:String,childDataFormat:String="text"){
            this.childDataFormat = childDataFormat;
            fileloader = new URLLoaderCommand(null,childDataFormat);

            this.configUrl = configUrl;
            configloader = new URLLoaderCommand(new URLRequest(configUrl),URLLoaderDataFormat.TEXT);
            configIndex = 0;    
        }
        
        
        public override function start(...args):Command
        {
            addCommand(configloader);
            addFileLoaderCommand(fileloader);
            currentCommandIndex = 0;
            doStartCommand();
            return this;
        }


        protected function addFileLoaderCommand(command:Command):ComplexCommand
        {
            command.setCompleteEventListener(fileloadCompleteEventHandler);
            command.setErrorEventListener(fileloadErrorEventHandler);
            return this;
        }
                
        protected override function commandCompleteEventHandler(event:CommandEvent):void{         
            configList = ((event.value as URLLoader).data as String).replace(/\r/g,"").split("\n");
            if( configList != null && configList.length > 0 ){
                fileloader.start(configList[configIndex]);
            } else {
                dispatchCompleteEvent([]);
            }
        }     

        protected function fileloadCompleteEventHandler(event:CommandEvent):void{
            if( configIndex < configList.length ){
                if( childCompleteEventHandler != null ){
                    childCompleteEventHandler(event);
                }
                fileloader.start(configList[configIndex++]);
            } else {
                dispatchCompleteEvent(configList);
            }
        }     

        protected function fileloadErrorEventHandler(event:CommandEvent):void{
            dispatchErrorEvent(event);
        }
    }
}