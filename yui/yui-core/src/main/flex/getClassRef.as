package
{
    import org.seasar.akabana.yui.core.reflection.ClassRef;

    public function getClassRef(target:Object):ClassRef{
        return ClassRef.getReflector(target);
    }
}