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
package org.seasar.akabana.eclipse.fleclipse.projects;

import org.seasar.dolteng.eclipse.loader.ResourceLoader;
import org.seasar.dolteng.projects.handler.ResourceHandler;
import org.seasar.dolteng.projects.handler.impl.FlexBuilderHandler;

import junit.framework.TestCase;

public class ResourceHandlerTest extends TestCase{
	
	public void testResoureHandler(){
		FlexBuilderHandler resourceHandler = new FlexBuilderHandler();
		ResourceHandler handler = (ResourceHandler)new FlexBuilderHandler();
		assertTrue("Flex Builder Handler is Instance of ResourceHandler",resourceHandler instanceof ResourceHandler);
		assertTrue("ResourceHandler",resourceHandler instanceof ResourceHandler);
		assertTrue("handler",handler instanceof ResourceHandler);
		
	}
	public void testResourceLoader() {
		ResourceLoader resourceLoader=(ResourceLoader)  new org.seasar.akabana.eclipse.fleclipse.projects.ResourceLoader();
		assertTrue(resourceLoader instanceof ResourceLoader);
	}
}
