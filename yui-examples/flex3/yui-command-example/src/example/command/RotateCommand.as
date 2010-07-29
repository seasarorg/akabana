package example.command
{
    import caurina.transitions.Tweener;
    
    import flash.display.DisplayObject;
    
    import org.seasar.akabana.yui.command.core.impl.AbstractCommand;

    public class RotateCommand extends AbstractCommand
    {
        protected var target:DisplayObject;
        protected var rotation:Number;
        
        public function RotateCommand(shape:DisplayObject,rotation:Number)
        {
            super();
            this.target = shape;
            this.rotation = rotation;
        }

        protected override function run(...args):void{
            trace("command:",this);
            Tweener.addTween(target, {rotation:this.rotation, onComplete:rotateCompleteHandler, time:args[0], transition:"linear"});
        }  
        
        private function rotateCompleteHandler():void{
            done("value"); 
        }
    }
}