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
    
    import flash.events.Event;
    
    import mx.core.Application;
    import mx.core.Container;
    import mx.core.UIComponent;
    import mx.events.ChildExistenceChangedEvent;
    import mx.events.FlexEvent;
    
    import org.seasar.akabana.yui.framework.core.UIComponentRepository;
    import org.seasar.akabana.yui.framework.core.UIComponentUtil;
    import org.seasar.akabana.yui.framework.customizer.AutoEventCustomizer;
    import org.seasar.akabana.yui.framework.metadata.MetadataParser;
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.ServiceRepository;
    
    public class BaseYuiApplication extends Application {
        
        private static const VIEW:String = "View";
        
        private static const LOGIC:String = "Logic";

        public function BaseYuiApplication(){
            this.addEventListener(FlexEvent.ADD,addHandler, true, int.MAX_VALUE, false);
            this.addEventListener(ChildExistenceChangedEvent.CHILD_ADD,traceHandler);
            this.addEventListener(FlexEvent.APPLICATION_COMPLETE,traceHandler);
        }
        private function traceHandler( event:Event ):void{
            //trace( event + ":" + event.target );
        }
        
        private function addHandler( event:FlexEvent ):void{
            //trace( event + ":" + event.target );
            const target:Object = event.target;
            do{
                if( target is UIComponent ){
                    processRegisterComponent( target as UIComponent ); 
                    processParseView( target as Container );
                    break;
                }
                if( target is Service ){
                    processRegisterService( target as Service );
                    break;
                }
            } while ( false );
        }
        
        private function processRegisterComponent( component:UIComponent ):void{
            UIComponentRepository.addComponent( component );
        }
        
        private function processParseView( container:Container ):void{
            if( container != null && isNamingOfView ( container )){
                container.addEventListener(FlexEvent.CREATION_COMPLETE,creationCompoleteHandler, false, int.MAX_VALUE, true);
            }
        }
        
        private function creationCompoleteHandler( event:FlexEvent ):void{
            //trace( event, event.target, event.target.isDocument );
            const container:Container = event.target as Container;
            if( container != null ){
                container.removeEventListener(FlexEvent.CREATION_COMPLETE,creationCompoleteHandler);

                var viewLogicName:String;
                var parentContainer:Container;
				if( event.target.isDocument ){    
                	viewLogicName = container.name + LOGIC;
                	parentContainer = container.parent as Container;
	                if( parentContainer.hasOwnProperty( viewLogicName )){
	                    AutoEventCustomizer.customizer( container, parentContainer[ viewLogicName ]);
	                    MetadataParser.parse( parentContainer, parentContainer[ viewLogicName ]);
	                } else {
		                parentContainer = parentContainer.parentDocument as Container;
		                if( parentDocument.hasOwnProperty( viewLogicName )){
		                    AutoEventCustomizer.customizer(container, parentContainer[ viewLogicName ]);
		                    MetadataParser.parse( parentContainer, parentContainer[ viewLogicName ]);
		                }
	                }
    			} else {
    				viewLogicName = container.parentDocument.name + LOGIC;
    				parentContainer = container.parentDocument.parentDocument as Container;
	                if( parentContainer.hasOwnProperty( viewLogicName )){
	                    AutoEventCustomizer.customizer( container, parentContainer[ viewLogicName ]);
	                    MetadataParser.parse( parentContainer, parentContainer[ viewLogicName ]);
	                }
    			}
            }
        }

        private function processRegisterService( service:Service ):void{
            ServiceRepository.addService(service);
        }


        private function isNamingOfView( container:Container ):Boolean{
            const id:String = UIComponentUtil.getComponentName( container );
            return ( id != null && id.indexOf( VIEW ) > 0 );
        }
    }
}