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
    
    import org.seasar.akabana.yui.framework.core.UIComponentRepository;
    import org.seasar.akabana.yui.framework.metadata.MetadataParser;
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.ServiceRepository;
    import org.seasar.akabana.yui.framework.core.UIComponentUtil;
    import org.seasar.akabana.yui.framework.customizer.AutoEventCustomizer;
    
    public class BaseYuiApplication extends Application {
        
        private static const VIEW:String = "View";
        
        private static const LOGIC:String = "Logic";

        private static function isViewNaming( container:Container ):Boolean{
            const id:String = UIComponentUtil.getComponentName( container );
            return ( id != null && id.indexOf( VIEW ) > 0 );
        }
        
        public function BaseYuiApplication(){
            this.addEventListener(FlexEvent.ADD,addHandler, true, int.MAX_VALUE, false);
        }
        
        private function addHandler( event:FlexEvent ):void{
            //trace( event + ":" + event.target );
            const target:Object = event.target;
            do{
                if( target is Service ){
                    processServiceRegister( target as Service );
                    break;
                }
                if( target is UIComponent ){
                    processComponentRegister( target as UIComponent ); 
                    processViewParse( target as Container );
                    break;
                }
            } while ( false );
        }
        
        private function processComponentRegister( component:UIComponent ):void{
            UIComponentRepository.addComponent( component );
        }
        
        private function processViewParse( container:Container ):void{
            if( container != null && isViewNaming ( container )){
                container.addEventListener(FlexEvent.CREATION_COMPLETE,creationCompoleteHandler, false, int.MAX_VALUE, true);
            }
        }
        
        private function creationCompoleteHandler( event:FlexEvent ):void{
            //trace( event + ":" + event.target );
            const container:Container = event.target as Container;
            if( container != null ){
                container.removeEventListener(FlexEvent.CREATION_COMPLETE,creationCompoleteHandler);
    
                const parentContainer:Container = container.parent as Container;
                const viewLogicName:String = container.name + LOGIC;
                
                if( parentContainer.hasOwnProperty( viewLogicName )){
                    AutoEventCustomizer.customizer(container,parentContainer[ viewLogicName ]);
                    MetadataParser.parse( parentContainer, parentContainer[ viewLogicName ]);
                }  
            }
        }

        private function processServiceRegister( service:Service ):void{
            ServiceRepository.addService(service);
        }
    }
}