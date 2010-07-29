package examples.yui.helloworld.action
{
    import examples.yui.helloworld.helper.HelloWorldHelper;
    import examples.yui.helloworld.validator.HelloWorldValidator;
    
    import flash.errors.IllegalOperationError;
    import flash.events.MouseEvent;
    
    import mx.events.EffectEvent;
    import mx.events.FlexEvent;
    import mx.events.ValidationResultEvent;
    import mx.validators.Validator;
    
    import org.seasar.akabana.yui.framework.core.event.FrameworkEvent;
    import org.seasar.akabana.yui.framework.core.event.RuntimeErrorEvent;
    import org.seasar.akabana.yui.framework.message.MessageManager;
    
    public class HelloWorldAction {
        
        public var helloWorldHelper:HelloWorldHelper;

        public var validator:HelloWorldValidator;
        
        private var isFirst:Boolean = true;
        
        public function onAssembleCompleteHandler(event:FrameworkEvent):void{
            trace(event);
        }
        
        public function onShowHandler( event:FlexEvent ):void{
            trace( event );
        }
                
        public function onRuntimeErrorHandler( event:RuntimeErrorEvent ):void{
        	trace(">",event.stackTrace);
        }        
        
        public function radiogroup1ChangeHandler():void{
        	throw new IllegalOperationError("aaaa");
        }
        
        public function showHelloWorldClickHandler():void{
            var re:Array = Validator.validateAll(validator.source);
            if( re.length == 0 ){
                if( isFirst ){
                    isFirst = false;
                    helloWorldHelper.showAlert(MessageManager.messages.E1001);
                    helloWorldHelper.disableButton();    
                }
            }
        }
        
        public function inputDataValidatorInvalidHandler( event:ValidationResultEvent ):void{
            trace( event );
        }
        
        public function inputDataValidatorValidHandler( event:ValidationResultEvent ):void{
            trace( event );
        }  

        public function fadeOutEffectStartHandler( event:EffectEvent ):void{
            trace(event);
        }
                
        public function fadeOutEffectEndHandler( event:EffectEvent ):void{
            trace(event);
            
        }      
        
        public function controlButtonClickHandler( event:MouseEvent ):void{
            trace(event);
        }
        
        public function removeClickHandler():void{
            helloWorldHelper.removePanel();
        }
    }
}