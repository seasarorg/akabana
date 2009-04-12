package
{
    import example.command.MoveCommand;
    import example.command.RotateCommand;
    
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    
    import org.seasar.akabana.yui.command.ParallelCommand;
    import org.seasar.akabana.yui.command.SequenceCommand;

    public class testAnimateCommands1 extends Sprite {

        public function testAnimateCommands1(){
            var shape:Shape = createRedSquare(); 
            addChild(shape);
            
            new SequenceCommand()
                .addCommand(
                    new ParallelCommand()
                        .addCommand(new MoveCommand( shape, 100, 100 ))
                        .addCommand(new RotateCommand( shape, 180))
                    )
                .addCommand(new MoveCommand( shape, 200, 100 ))
                .addCommand(new RotateCommand( shape, 90))
                .execute(0.5);            
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
