package org.seasar.akabana.yui.framework.message
{
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;
    
    import mx.resources.ResourceManager;
    
    import org.seasar.akabana.yui.util.StringUtil;
    
    use namespace flash_proxy;
    
    [Bindable]
    public dynamic class Messages extends Proxy
    {   
        private var _bundleName:String;
        
        public function Messages(bundleName:String):void{
            _bundleName = bundleName;            
        }
        
        flash_proxy override function getProperty(name:*):* {
            return ResourceManager.getInstance().getString(_bundleName,name.toString());
        }
        
        flash_proxy override function setProperty(name:*, value:*):void {
        }        
        
        flash_proxy override function hasProperty(name:*):Boolean {
            return true;
        }     
        
        public function getMessage( resourceName:String,...parameters ):String{
            return substitute(
                        ResourceManager.getInstance().getString(_bundleName,resourceName),
                        parameters
                    )
        }
        
        protected function substitute(str:String, ... args):String{
            return StringUtil.substitute.apply( null, [str].concat( args ));
        }           
    }
}