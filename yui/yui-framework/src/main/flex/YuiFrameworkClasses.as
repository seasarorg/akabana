/*
 * Copyright 2004-2008 the Seasar Foundation and the Others.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 * either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */
package
{
    import org.seasar.akabana.yui.framework.convention.NamingConvention;
    import org.seasar.akabana.yui.framework.core.YuiFrameworkContainer;
    import org.seasar.akabana.yui.framework.customizer.ActionCustomizer;
    import org.seasar.akabana.yui.framework.customizer.EventHandlerCustomizer;
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
        
        ActionCustomizer;
        EventHandlerCustomizer;
        
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