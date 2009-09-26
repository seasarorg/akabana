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
    import org.seasar.akabana.yui.framework.core.ViewComponentRepository;
    import org.seasar.akabana.yui.framework.core.YuiFrameworkContainer;
    import org.seasar.akabana.yui.framework.core.YuiFrameworkSettings;
    import org.seasar.akabana.yui.framework.core.event.FrameworkEvent;
    import org.seasar.akabana.yui.framework.core.event.RuntimeErrorEvent;
    import org.seasar.akabana.yui.framework.customizer.ActionCustomizer;
    import org.seasar.akabana.yui.framework.customizer.EventHandlerCustomizer;
    import org.seasar.akabana.yui.framework.customizer.IComponentCustomizer;
    import org.seasar.akabana.yui.framework.customizer.ValidatorCustomizer;
    import org.seasar.akabana.yui.framework.error.ComponentDuplicatedRegistrationError;
    import org.seasar.akabana.yui.framework.event.Command;
    import org.seasar.akabana.yui.framework.event.Notification;
    import org.seasar.akabana.yui.framework.message.MessageManager;
    import org.seasar.akabana.yui.framework.mixin.YuiFrameworkMixin;
    import org.seasar.akabana.yui.framework.util.PopUpUtil;
    import org.seasar.akabana.yui.framework.util.SystemManagerUtil;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    
    public class YuiFrameworkClasses
    {
        {
            NamingConvention;
            ViewComponentRepository;
            IComponentCustomizer;
            
            ActionCustomizer;
            EventHandlerCustomizer;
            ValidatorCustomizer;
            
            ComponentDuplicatedRegistrationError;
            
            FrameworkEvent;
            RuntimeErrorEvent;
            
            YuiFrameworkSettings;
            YuiFrameworkMixin;        
            YuiFrameworkContainer;
            
            MessageManager;
            
            PopUpUtil;
            SystemManagerUtil;
            UIComponentUtil;
            
            Notification;
            Command;
        }
    }
}