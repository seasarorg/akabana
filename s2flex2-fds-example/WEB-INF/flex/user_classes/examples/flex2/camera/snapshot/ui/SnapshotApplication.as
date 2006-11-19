package examples.flex2.camera.snapshot.ui
{
    import com.adobe.images.PNGEncoder;
    
    import examples.flex2.camera.snapshot.dto.SnapshotDto;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    
    import mx.containers.Panel;
    import mx.controls.Button;
    import mx.controls.LinkButton;
    import mx.core.Application;
    import mx.core.UIComponent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.remoting.mxml.RemoteObject;
            
    public class SnapshotApplication extends Application
    {
            public var cameraPanel:SnapshotPanel;
            public var snapshotPanel:Panel;
            
            public var viewLinkButton:LinkButton;
            
            public var takeSnapshotButton:Button;
            public var saveSnapshotButton:Button;
            
            protected var snapshotHolder:UIComponent;
            protected var snapshotbitmap:Bitmap;
            protected var snapshotService:RemoteObject;
            protected var lastlySavedSnapshotUri:String;
            
            protected override function initializationComplete():void{
                snapshotHolder = new UIComponent();
                snapshotbitmap = new Bitmap();

            	snapshotHolder.addChild(snapshotbitmap);
            	snapshotPanel.addChild(snapshotHolder);
            	snapshotService =new RemoteObject("snapshotService");
            	snapshotService.destination="snapshotService";
            }
            
            public function takeSnapshot():void{
                viewLinkButton.enabled = false;
                
                var snapshot:BitmapData = new BitmapData(320, 240, true);
            	snapshot.draw(cameraPanel.video);
                snapshotbitmap.bitmapData = snapshot;

            	snapshotPanel.enabled = true;
            	saveSnapshotButton.enabled = true;
            }
            
            public function saveSnapshot():void{
                viewLinkButton.enabled = false;
                
                var snapshot:SnapshotDto = createSnapshot();
                sendSnapshotService( snapshot );

            	saveSnapshotButton.enabled = false;
            }
            
            public function gotoSnapshotView():void{
                navigateToURL(new URLRequest(lastlySavedSnapshotUri));
            }
            
            private function createSnapshot():SnapshotDto{
                var snapshot:SnapshotDto = new SnapshotDto();
                snapshot.source = PNGEncoder.encode(snapshotbitmap.bitmapData);
               // snapshot.source.compress();
                return snapshot;
            }
            
            private function sendSnapshotService( snapshot:SnapshotDto ):void{
                snapshotService.addEventListener("result", resultSnapshotService);
                snapshotService.addEventListener("fault", faultSnapshotService);
                snapshotService.save( snapshot );
            }
            
            private function resultSnapshotService( event:Event ):void{
                viewLinkButton.enabled = true;
                var resultEvent:ResultEvent = event as ResultEvent;
                lastlySavedSnapshotUri = resultEvent.result as String;
            }
            
            private function faultSnapshotService( event:Event ):void{
                trace("faultSnapshotService");
            }
    }
}