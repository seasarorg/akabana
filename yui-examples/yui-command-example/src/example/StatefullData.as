package example
{
    import org.seasar.akabana.yui.command.core.StatefulObject;

    public class StatefullData implements StatefulObject
    {
        public function get state():String
        {
            var result:String = Math.floor(Math.random()*10).toString();
            trace("state is",result);
            return result;
        }
    }
}