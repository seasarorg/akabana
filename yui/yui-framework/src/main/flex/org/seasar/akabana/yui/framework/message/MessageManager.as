/*
 * Copyright 2004-2009 the Seasar Foundation and the Others.
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
package org.seasar.akabana.yui.framework.message
{
    import mx.resources.ResourceManager;
    import org.seasar.akabana.yui.core.ns.yui_internal;
    
    import org.seasar.akabana.yui.util.StringUtil;
    
    
    [ResourceBundle("messages")]    
    [ResourceBundle("application")] 
    [ResourceBundle("errors")]
    [ResourceBundle("yui_framework")]    
    public class MessageManager {
        public static var messages:Messages = new Messages("messages");
        public static var application:Messages = new Messages("application");
        public static var errors:Messages = new Messages("errors");
        yui_internal static var yuiframework:Messages = new Messages("yui_framework");
    }
}