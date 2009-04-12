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
            
            addCommand(configloader);
            addFileLoaderCommand(fileloader);   
        }
        
        protected function addFileLoaderCommand(command:Command):ComplexCommand
        {
            command.setCompleteEventListener(fileloadCompleteEventHandler);
            command.setErrorEventListener(fileloadErrorEventHandler);
            return this;
        }
                
        protected override function childCommandErrorEventHandler(event:CommandEvent):void{         
            configList = ((event.value as URLLoader).data as String).replace(/\r/g,"").split("\n");
            if( configList != null && configList.length > 0 ){
                fileloader.execute(configList[configIndex]);
            } else {
                complete([]);
            }
        }     

        protected function fileloadCompleteEventHandler(event:CommandEvent):void{
            if( configIndex < configList.length ){
                if( childCompleteEventHandler != null ){
                    childCompleteEventHandler(event);
                }
                fileloader.execute(configList[configIndex++]);
            } else {
                complete(configList);
            }
        }     

        protected function fileloadErrorEventHandler(event:CommandEvent):void{
            error(event);
        }
    }
}