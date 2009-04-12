package example.command
{
    import caurina.transitions.Tweener;
    
    import flash.display.DisplayObject;
    
    import org.seasar.akabana.yui.command.core.impl.AbstractCommand;

    public class MoveCommand extends AbstractCommand
    {
        protected var target:DisplayObject;
        protected var x:Number;
        protected var y:Number;
        
        public function MoveCommand(shape:DisplayObject,x:Number,y:Number)
        {
            super();
            this.target = shape;
            this.x = x;
            this.y = y;
        }

        protected override function doRun(...args):void{
            trace("command:",this);
            Tweener.addTween(target, {x:this.x, y:this.y, onComplete:rotateCompleteHandler, time:args[0], transition:"linear"});
        }  
        
        private function rotateCompleteHandler():void{
            complete("value"); 
        }
    }
}