/*
 * Copyright 2004-2007 the Seasar Foundation and the Others.
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
package org.seasar.akabana.yui.framework.application {
    
    import mx.core.Application;
    import mx.core.Container;
    import mx.core.UIComponent;
    import mx.events.FlexEvent;
    
    import org.seasar.akabana.yui.framework.component.UIComponentRepository;
    import org.seasar.akabana.yui.framework.core.metadata.MetadataParser;
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.ServiceRepository;
    
    public class BaseYuiApplication extends Application {
        
        private static const VIEW:String = "View";
        
        private static const LOGIC:String = "Logic";
        
        public function BaseYuiApplication(){
            this.addEventListener(FlexEvent.ADD,addHandler, true, int.MAX_VALUE, true);
        }
        
        private function addHandler( event:FlexEvent ):void{
            //trace( event + ":" + event.target );
            do{
                if( event.target is Service ){
                    processServiceRegister( event.target as Service );
                    break;
                }
                if( event.target is UIComponent ){
                    processComponentRegister( event.target as UIComponent ); 
                    processViewParse( event.target as Container );
                    break;
                }
            } while (false );
        }
        
        private function processComponentRegister( component:UIComponent ):void{
            UIComponentRepository.addComponent(component);
        }
        
        private function processViewParse( container:Container ):void{
            if(
                container != null &&
                (
                    ( container.id != null && container.id.indexOf( VIEW ) > 0 ) ||
                    ( container.name != null && container.name.indexOf( VIEW ) > 0 )
                )
            ){
                container.addEventListener(FlexEvent.CREATION_COMPLETE,creationCompoleteHandler, false, int.MAX_VALUE, true);
            }
        }
        
        private function creationCompoleteHandler( event:FlexEvent ):void{
            //trace( event + ":" + event.target );
            var container:Container = event.target as Container;
            container.removeEventListener(FlexEvent.CREATION_COMPLETE,creationCompoleteHandler);

            var parentContainer:Container = container.parent as Container;
            var viewLogicName:String = container.name + LOGIC;
            
            if( parentContainer.hasOwnProperty( viewLogicName )){
                MetadataParser.parse( parentContainer, parentContainer[ viewLogicName ]);
            }
        }

        private function processServiceRegister( service:Service ):void{
            ServiceRepository.addService(service);
        }
    }
}