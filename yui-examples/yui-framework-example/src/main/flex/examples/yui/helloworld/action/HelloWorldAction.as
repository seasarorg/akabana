package examples.yui.helloworld.action
{
    import examples.yui.helloworld.helper.HelloWorldHelper;
    import examples.yui.helloworld.validator.HelloWorldValidator;
    
    import flash.errors.IllegalOperationError;
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.events.EffectEvent;
    import mx.events.ValidationResultEvent;
    import mx.validators.Validator;
    
    import org.seasar.akabana.yui.framework.event.FrameworkEvent;
    import org.seasar.akabana.yui.framework.event.RuntimeErrorEvent;
    
    public class HelloWorldAction {
        
        public var helloWorldHelper:HelloWorldHelper;

        public var validator:HelloWorldValidator;
        
        private var isFirst:Boolean = true;
        
        public function onApplicationStartHandler( event:FrameworkEvent ):void{
            trace( event );
        }

        public function onRuntimeErrorHandler( event:RuntimeErrorEvent ):void{
        	trace(">",event.stackTrace);
        }        
        
        public function radiogroup1ChangeHandler( event:Event ):void{
        	throw new IllegalOperationError("aaaa");
        }
        
        public function showHelloWorldClickHandler( event:MouseEvent ):void{
            var re:Array = Validator.validateAll(validator.source);
            if( re.length == 0 ){
                if( isFirst ){
                    isFirst = false;
                    helloWorldHelper.showAlert("showHelloWorldクリックされました。");
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
    }
}