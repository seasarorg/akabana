package org.seasar.akabana.yui.framework
{
    import mx.core.Application;
    import mx.core.UIComponent;

    import org.seasar.akabana.yui.framework.core.YuiFrameworkSettings;
    import org.seasar.akabana.yui.framework.error.YuiFrameworkContainerError;

    [Style(name="rootViewClass", type="Class")]

    public class YuiApplication extends Application{

        private var _setting:YuiFrameworkSettings;

        public function get setting():YuiFrameworkSettings{
            return _setting;
        }

        private var _rootView:UIComponent;

        public function get rootView():UIComponent{
            return _rootView;
        }

        public function YuiApplication()
        {
            super();
            _setting = new YuiFrameworkSettings();
        }

        protected override function createChildren():void{
            super.createChildren();

            createRootView();
        }

        protected function createRootView():void{
            var viewClass:Class = getStyle("rootView") as Class;

            if( viewClass == null ){
                throw new YuiFrameworkContainerError("rootViewClass style is needed.");
            } else {
                _rootView = new viewClass();
                _rootView.name = "rootView";
                addChild(_rootView);
            }
        }

    }
}