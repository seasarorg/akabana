/*
* Copyright 2004-2011 the Seasar Foundation and the Others.
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
package org.seasar.akabana.yui.framework
{
    import flash.events.Event;
    import flash.utils.Dictionary;
    
    import mx.events.FlexEvent;

    public final class YuiApplicationConsts {
        
        public static const UNRECOMMEND_EVENT_MAP:Object = {
                "creationComplete":true,//FlexEvent.CREATION_COMPLETE,
                "applicationComplete":true,//FlexEvent.APPLICATION_COMPLETE,
                "addFocusManager ":true,//FlexEvent.ADD_FOCUS_MANAGER,
                "contentCreationComplete":true,//FlexEvent.CONTENT_CREATION_COMPLETE,
                "preloaderDocFrameReady":true,//FlexEvent.PRELOADER_DOC_FRAME_READY,
                "updateComplete":true,//FlexEvent.UPDATE_COMPLETE,
                
                "initComplete":true,//FlexEvent.INIT_COMPLETE,
                "initProgress":true,//FlexEvent.INIT_PROGRESS,
                "initialize":true,//FlexEvent.INITIALIZE,
                "preinitialize":true,//FlexEvent.PREINITIALIZE,
                "preloaderDone":true,//FlexEvent.PRELOADER_DONE,
                
                "partAdded":true,
                "partRemoved":true,
                "elementAdd":true,
                "elementRemove":true,
                "windowComplete":true,
                
                "addedToStage":true,//Event.ADDED_TO_STAGE,
                "removedFromStage":true,//Event.REMOVED_FROM_STAGE,
                "added":true,//Event.ADDED,
                "removed":true,//Event.REMOVED,
                "enterFrame":true,//Event.ENTER_FRAME,
                "exitFrame":true//Event.EXIT_FRAME
                
                
        };
    }
}