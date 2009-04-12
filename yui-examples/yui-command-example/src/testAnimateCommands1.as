package
{
    import caurina.transitions.Tweener;
    import caurina.transitions.properties.ColorShortcuts;
    import caurina.transitions.properties.CurveModifiers;
    import caurina.transitions.properties.DisplayShortcuts;
    import caurina.transitions.properties.FilterShortcuts;
    
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    
    import org.seasar.akabana.yui.command.MoveCommand;
    import org.seasar.akabana.yui.command.ParallelCommand;
    import org.seasar.akabana.yui.command.RotateCommand;
    import org.seasar.akabana.yui.command.SequenceCommand;
    import org.seasar.akabana.yui.command.TweenerCommand;

    public class testAnimateCommands1 extends Sprite {

        public function testAnimateCommands1(){
            var shape:Shape = createRedSquare(); 
            addChild(shape);

            Tweener;
            FilterShortcuts.init();
            DisplayShortcuts.init();
            CurveModifiers.init();
            ColorShortcuts.init();
            new SequenceCommand()
                .addCommand(
                    new ParallelCommand()
                        .addCommand(new MoveCommand( shape, 100, 100 ))
                        .addCommand(new RotateCommand( shape, 180))
                    )
                .addCommand(new MoveCommand( shape, 200, 100 ))
                .addCommand(new RotateCommand( shape, 90))
                .addCommand(new TweenerCommand( shape, {x:0,y:0,rotation:0,alpha:0,delay:0,transition:'linear',_color:0xff0000,_bezier:[{x:157,y:50},{x:72,y:276},{x:307,y:248}]}))
                .execute(1);            
        }   
        
        private function createRedSquare():Shape{
            var result:Shape = new Shape();
            var g:Graphics = result.graphics;
            g.clear();
            g.beginFill(0xFF0000,0.7);
            g.drawRect(-25,-25,50,50);
            g.endFill();
            return result;
        }
             
    }
}
