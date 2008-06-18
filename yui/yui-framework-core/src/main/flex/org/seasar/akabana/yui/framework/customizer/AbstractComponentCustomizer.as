package org.seasar.akabana.yui.framework.customizer
{
    import mx.core.Container;
    
    import org.seasar.akabana.yui.framework.convention.NamingConvention;
    
    internal class AbstractComponentCustomizer implements IComponentCustomizer
    {
        protected var _namingConvention:NamingConvention;
        
        public function get namingConvention():NamingConvention{
            return _namingConvention;
        }
        
        public function set namingConvention( value:NamingConvention ):void{
            _namingConvention = value;
        }
        
        public function customize( name:String, view:Container ):void{
            
        }

        public function uncustomize( name:String, view:Container ):void{
            
        }

    }
}