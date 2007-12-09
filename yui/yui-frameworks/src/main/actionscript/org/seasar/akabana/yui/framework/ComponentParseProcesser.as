package org.seasar.akabana.yui.framework
{
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import org.seasar.akabana.yui.framework.core.UIComponentRepository;
	import org.seasar.akabana.yui.framework.core.UIComponentUtil;
	import org.seasar.akabana.yui.framework.customizer.AutoEventCustomizer;
	import org.seasar.akabana.yui.framework.metadata.MetadataParser;
	import org.seasar.akabana.yui.service.Service;
	import org.seasar.akabana.yui.service.ServiceRepository;
	
	internal class ComponentParseProcesser
	{
        private static const VIEW:String = "View";
        
        private static const LOGIC:String = "Logic";
        
		public function add( target:Object ):void{
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

		public function remove( target:Object ):void{
            do{
                if( target is UIComponent ){
                    processUnRegisterComponent( target as UIComponent ); 
                    break;
                }
                if( target is Service ){
                    processUnRegisterService( target as Service );
                    break;
                }
            } while ( false );
        }
        
        private function processRegisterComponent( component:UIComponent ):void{
            UIComponentRepository.addComponent( component );
        }
        
        private function processUnRegisterComponent( component:UIComponent ):void{
            UIComponentRepository.removeComponent( component );
        }
                
        private function processParseView( container:Container ):void{
            if( container != null && isNamingOfView ( container )){
                container.addEventListener(FlexEvent.CREATION_COMPLETE,creationCompoleteHandler, false, int.MAX_VALUE, true);
            }
        }
        
        private function creationCompoleteHandler( event:FlexEvent ):void{
            trace( event, event.target, event.target.isDocument );
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
		                if( parentContainer.hasOwnProperty( viewLogicName )){
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

        private function processUnRegisterService( service:Service ):void{
            ServiceRepository.removeService(service);
        }

        private function isNamingOfView( container:Container ):Boolean{
            const id:String = UIComponentUtil.getComponentName( container );
            return ( id != null && id.indexOf( VIEW ) > 0 );
        }
	}
}