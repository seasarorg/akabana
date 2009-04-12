package org.seasar.akabana.yui.command
{
    import caurina.transitions.Tweener;
    import caurina.transitions.properties.CurveModifiers;
    
    import flash.display.DisplayObject;
    
    import org.seasar.akabana.yui.command.core.impl.AbstractCommand;

    public class TweenerCommand extends AbstractCommand
    {
        protected var target:DisplayObject;
        protected var parameter:Object;
        
        public function TweenerCommand(shape:DisplayObject,parameter:Object)
        {
            super();
            this.target = shape;
            this.parameter = parameter;
        }

        protected override function doRun(...args):void{
            trace("command:",this);
            parameter["onComplete"] = rotateCompleteHandler;
            parameter["time"] = args[0];
            Tweener.addTween(target, parameter);
        }  
        
        private function rotateCompleteHandler():void{
            complete("value"); 
        }
    }
}