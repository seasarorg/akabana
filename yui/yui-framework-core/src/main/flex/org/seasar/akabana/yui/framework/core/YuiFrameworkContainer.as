package org.seasar.akabana.yui.framework.core
{
    import flash.display.DisplayObject;
    import flash.events.Event;
    
    import mx.core.Application;
    import mx.core.Container;
    import mx.core.UIComponent;
    import mx.core.UIComponentDescriptor;
    import mx.events.FlexEvent;
    import mx.managers.CursorManager;
    import mx.managers.DragManager;
    import mx.managers.PopUpManager;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.framework.convention.NamingConvention;
    import org.seasar.akabana.yui.framework.customizer.ActionCustomizer;
    import org.seasar.akabana.yui.framework.customizer.IComponentCustomizer;
    import org.seasar.akabana.yui.framework.customizer.ViewEventCustomizer;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.ServiceRepository;
    
    public class YuiFrameworkContainer
    {        
        public var namingConvention:NamingConvention;
        
        public var customizers:Array;
        
        protected var cursorManager:CursorManager;
        
        protected var popUpManager:PopUpManager;
        
        protected var dragManager:DragManager;
        
        protected var _application:Application;
        
        
        public function get application():Application{
            return _application;
        }
        
        public function set application( value:Application ):void{
            if( _application != null ){
                _application.systemManager.removeEventListener(
                    FlexEvent.CREATION_COMPLETE,
                    creationCompleteHandler,
                    true
                );              
                _application.systemManager.addEventListener(
                    FlexEvent.REMOVE,
                    removeCompleteHandler,
                    true,
                    int.MAX_VALUE
                );
            }
            
            _application = value;

            _application.systemManager.addEventListener(
                FlexEvent.CREATION_COMPLETE,
                creationCompleteHandler,
                true,
                int.MAX_VALUE
            );    

            _application.systemManager.addEventListener(
                FlexEvent.REMOVE,
                removeCompleteHandler,
                true,
                int.MAX_VALUE
            );    
                        
//            _application.addEventListener(
//                FlexEvent.CREATION_COMPLETE,
//                creationCompleteHandler,
//                true,
//                int.MAX_VALUE
//            );                        
//            _application.addEventListener(
//                FlexEvent.REMOVE,
//                removeCompleteHandler,
//                true,
//                int.MAX_VALUE
//            );            
        }
        
        public function YuiFrameworkContainer(){
            
        }
        
        public function registerComponent(component:Object):void{
            if( component != null ){
                do{                 
                    if( component is Application ){
                        trace("application registerComponent");
                        application = component as Application;
                        break;
                    }

                    if( component is Container ){
                        registerView( component as Container );
                        break;   
                    }
                    
                    if( component is Service ){
                        registerService( component as Service );
                        break;
                    }
                
                } while( false );
            }
        }
        
        public function unregisterComponent(component:Object):void{
            if( component != null ){
                do{
                    if( component is Container ){
                        unregisterView( component as Container );
                        break;   
                    }
                    
                    if( component is Service ){
                        unregisterService( component as Service );
                        break;
                    }
                
                } while( false );
            }
        }
        
        public function init():void{
            application.visible = false;
            
            if( customizers == null ){
                customizers = getDefaultCustomizers();
            }
            
            for ( var key:String in UIComponentRepository.componentMap ){
                assembleView(key,UIComponentRepository.getComponent(key) as Container);
            }
            
            application.visible = true;
            application.dispatchEvent(new Event("assembled"));
        }
        
        private function getViewName( container:Container ):String{
            var viewName:String = null;
            if( container.isDocument ){
                viewName = ClassRef.getQualifiedClassName(container);
            } else {
                var parentDocument_:UIComponent = container.parentDocument as UIComponent;
                var parentDocumentClassName:String = ClassRef.getQualifiedClassName(parentDocument_);
                var dotLastIndex:int = parentDocumentClassName.lastIndexOf(".");
                var packageName:String = parentDocumentClassName.substring(0,dotLastIndex);
                viewName = packageName + "." + UIComponentUtil.getName(container);
            }
            return viewName;
        }


        private function registerService( service:Service ):void{
            ServiceRepository.addService(service);
        }

        private function unregisterService( service:Service ):void{
            ServiceRepository.removeService(service);
        }
        
        private function creationCompleteHandler(event:Event):void{
            trace(event,event.target,event.currentTarget);
            var component:UIComponent = event.target as UIComponent;
            registerComponent(component);
        }

        private function removeCompleteHandler(event:Event):void{
            trace(event,event.target,event.currentTarget);
            unregisterComponent(event.target as DisplayObject);
        }        
        
        protected function registerView( container:Container ):void{            
            const className:String = ClassRef.getQualifiedClassName(container);
            trace("container add to stage",container,container.isDocument,container.className,container.id);
            
            if( namingConvention.isTargetClassName( className )){
                if(namingConvention.isViewName( className )){
                    trace(">>add View",className);
                    if( !UIComponentRepository.hasComponent( className )){
                        UIComponentRepository.addComponent( className, container );              
                    }
                    if( container.initialized ){
                        assembleView( className, container);
                    }
                }               
            } else {
                var viewName:String = getViewName(container);
                if(
                    viewName != null && 
                    namingConvention.isViewName( viewName )
                ){
                    trace(">>add View",viewName);
                    if( !UIComponentRepository.hasComponent( viewName )){
                        UIComponentRepository.addComponent( viewName, container );  
                    }            
                    if( container.initialized ){
                        assembleView(viewName, container);
                    }
                }
            }      
        }

        protected function unregisterView( container:Container ):void{
            const className:String = ClassRef.getQualifiedClassName(container);
            //trace("container add to stage",container,container.isDocument,container.className,container.id);
            
            if( namingConvention.isTargetClassName( className )){
                if(namingConvention.isViewName( className )){
                    trace(">>add View",className);
                    if( container.initialized ){
                        disassembleView( className, container);
                    }
                    if( UIComponentRepository.hasComponent( className )){
                        UIComponentRepository.removeComponent( className, container );              
                    }
                }               
            } else {
                var viewName:String = getViewName(container);
                if(
                    viewName != null && 
                    namingConvention.isViewName( viewName )
                ){
                    trace(">>add View",viewName);            
                    if( container.initialized ){
                        disassembleView(viewName, container);
                    }
                    if( UIComponentRepository.hasComponent( viewName )){
                        UIComponentRepository.removeComponent( viewName, container );  
                    }
                }
            }
        } 
        
        protected function assembleView( name:String, view:Container ):void{
            if( view != null ){
                if( view.descriptor == null ){
                    view.descriptor = new UIComponentDescriptor({});
                }
                for each( var customizer_:IComponentCustomizer in customizers ){
                    customizer_.namingConvention = namingConvention;
                    customizer_.customize( name, view );                    
                }
            }
        }

        protected function disassembleView( name:String, view:Container ):void{
            if( view != null ){
                for each( var customizer_:IComponentCustomizer in customizers ){
                    customizer_.namingConvention = namingConvention;
                    customizer_.uncustomize( name, view );                    
                }
            }
        }        
        
        protected function getDefaultCustomizers():Array{
            return [
                new ActionCustomizer(),
                new ViewEventCustomizer()
            ];
        }     
    }
}