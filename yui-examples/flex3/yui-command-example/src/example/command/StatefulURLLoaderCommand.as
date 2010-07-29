package example.command
{
    import flash.net.URLRequest;
    
    import org.seasar.akabana.yui.command.URLLoaderCommand;
    import org.seasar.akabana.yui.command.core.StatefulObject;

    public class StatefulURLLoaderCommand extends URLLoaderCommand implements StatefulObject
    {
        public function StatefulURLLoaderCommand(url:URLRequest=null, dataFormat:String="text")
        {
            super(url, dataFormat);
        }
        
        public function get state():String{
            var result:String = null;
            if( (loader.data != null) && ((loader.data as String).length > 0 )){
                result = loader.data;
            }
            return result;
        } 
        
    }
}