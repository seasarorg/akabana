package
{
    import org.seasar.akabana.yui.framework.convention.NamingConvention;
    import org.seasar.akabana.yui.framework.core.ViewComponentRepository;
    import org.seasar.akabana.yui.framework.core.YuiFrameworkContainer;
    import org.seasar.akabana.yui.framework.customizer.ActionCustomizer;
    import org.seasar.akabana.yui.framework.customizer.IComponentCustomizer;
    import org.seasar.akabana.yui.framework.customizer.ViewEventCustomizer;
    import org.seasar.akabana.yui.framework.error.RuntimeError;
    import org.seasar.akabana.yui.framework.event.FrameworkEvent;
    import org.seasar.akabana.yui.framework.mixin.YuiFrameworkMixin;
    import org.seasar.akabana.yui.framework.util.ApplicationUtil;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.service.Operation;
    import org.seasar.akabana.yui.service.PendingCall;
    import org.seasar.akabana.yui.service.Responder;
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.ServiceRepository;
    import org.seasar.akabana.yui.service.event.FaultEvent;
    import org.seasar.akabana.yui.service.event.FaultStatus;
    import org.seasar.akabana.yui.service.event.ResultEvent;
    
    public class YuiFrameworkClasses
    {
        YuiCoreClasses;
        YuiLoggingClasses;
        
        NamingConvention;
        
        YuiFrameworkContainer;
        
        IComponentCustomizer;
        ActionCustomizer;
        ViewEventCustomizer;
        
        YuiFrameworkMixin;
        
        RuntimeError;
        
        FrameworkEvent;
        
        ApplicationUtil;
        UIComponentUtil;
        
        Service;
        Operation;
        PendingCall;
        Responder;
        ServiceRepository;
        FaultEvent;
        ResultEvent;
        FaultStatus;
    }
}