package
{
    import org.seasar.akabana.yui.core.reflection.ClassRef;

    public function getCanonicalName(object:Object):String{
        return ClassRef.getCanonicalName(object);
    }
}