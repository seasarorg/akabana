package examples.flex2.camera.snapshot.ui {
    import mx.containers.Panel;
    import mx.core.UIComponent;
    import flash.media.Video;
    import flash.media.Camera;

    public class SnapshotPanel extends Panel {
        public var video:Video;
        
        public function SnapshotPanel(){
            super();
            insertCameraVideo();
        }
        
        public function insertCameraVideo():void{
            var videoHolder:UIComponent = new UIComponent();
            var camera:Camera = Camera.getCamera();
            video = new Video(camera.width*2, camera.height*2);
            video.attachCamera(camera);
            videoHolder.addChild(video);
            addChild(videoHolder);
       }
    }
}