package examples.yui.viewstack.logic
{
    import flash.events.MouseEvent;
    
    import mx.containers.VBox;
    import mx.containers.ViewStack;
    import mx.controls.Alert;
    import mx.controls.Text;
    
    public class ViewStackTestViewLogic {
    	
    	[View]
    	public var viewMainView:VBox;

    	[View]
    	public var viewSubView:VBox;
    	
    	[View]
    	public var myViewStack:ViewStack;
    	
    	public function viewSubViewDoubleClickHandler( event:MouseEvent ):void{
    		trace( "ダブルクリック",event );
    	}
        
        public function textAClickHandler( event:MouseEvent ):void{
        	trace( event.currentTarget );
            Alert.show("テキストクリック1",(event.currentTarget as Text).text,4.0);
        }
        
        public function textBClickHandler( event:MouseEvent ):void{
            trace( event.currentTarget );
            Alert.show("テキストクリック2",(event.currentTarget as Text).text,4.0);
        }
        
        public function nextButtonClickHandler( event:MouseEvent ):void{
            trace( "nextButtonClickHandler" );
        	myViewStack.selectedChild = viewSubView;
        }
        
        public function backButtonClickHandler( event:MouseEvent ):void{
            trace( "backButtonClickHandler" );
            myViewStack.selectedChild = viewMainView;        	
        }
    }
}