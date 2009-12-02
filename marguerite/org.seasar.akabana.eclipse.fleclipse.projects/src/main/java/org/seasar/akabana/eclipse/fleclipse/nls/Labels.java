/**
 * 
 */
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
package org.seasar.akabana.eclipse.fleclipse.nls;

import org.eclipse.osgi.util.NLS;

/**
 * @author nod
 *
 */
public class Labels extends NLS {
    static {
        Class clazz = Labels.class;
        NLS.initializeMessages(clazz.getName(), clazz);
    }	
    public static String PLUGIN_NAME;

    public static String CONNECTION_DIALOG_TITLE;
    
    public static String WIZARD_FP_PROJECT_TITLE;
    
    public static String WIZARD_PAGE_FP_BASIC_SETTINGS;
    
    public static String WIZARD_PAGE_FP_ROOT_PACKAGE;
    
    public static String WIZARD_PAGE_FP_TYPE_SELECTION;
}
