package org.seasar.akabana.yui.framework.customizer
{
    import mx.core.Container;
    
    import org.seasar.akabana.yui.framework.convention.NamingConvention;
    
    public interface IComponentCustomizer
    {
        function customize( name:String, view:Container ):void;
        
        function uncustomize( name:String, view:Container ):void;
        
        function get namingConvention():NamingConvention;
        
        function set namingConvention( value:NamingConvention ):void;
    }
}