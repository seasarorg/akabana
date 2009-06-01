/*
 * Copyright 2004-2009 the Seasar Foundation and the Others.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 * either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */
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
            
            add(configloader);
            addFileLoaderCommand(fileloader);   
        }
        
        protected function addFileLoaderCommand(command:Command):ComplexCommand
        {
            command.complete(fileloadCompleteEventHandler);
            command.error(fileloadErrorEventHandler);
            return this;
        }
                
        protected override function childCommandErrorEventHandler(event:CommandEvent):void{         
            configList = ((event.value as URLLoader).data as String).replace(/\r/g,"").split("\n");
            if( configList != null && configList.length > 0 ){
                fileloader.start(configList[configIndex]);
            } else {
                done([]);
            }
        }     

        protected function fileloadCompleteEventHandler(event:CommandEvent):void{
            if( configIndex < configList.length ){
                if( childCompleteEventHandler != null ){
                    childCompleteEventHandler(event);
                }
                fileloader.start(configList[configIndex++]);
            } else {
                done(configList);
            }
        }     

        protected function fileloadErrorEventHandler(event:CommandEvent):void{
            failed(event);
        }
    }
}