package example
{
    import org.seasar.akabana.yui.command.core.StatefulObject;

    public class StatefullData implements StatefulObject
    {
        public function get state():String
        {
            return Math.floor(Math.random()*10).toString();
        }
    }
}