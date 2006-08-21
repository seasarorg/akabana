/*
 * Copyright 2004-2006 the Seasar Foundation and the Others.
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
package org.seasar.flex2.rpc.remoting.service.fds2.factory;

import org.seasar.flex2.rpc.remoting.processor.RemotingMessageProcessor;
import org.seasar.flex2.rpc.remoting.service.RemotingServiceLocator;
import org.seasar.flex2.rpc.remoting.service.impl.RemotingServiceInvokerImpl;
import org.seasar.framework.container.S2Container;
import org.seasar.framework.container.factory.SingletonS2ContainerFactory;

import flex.messaging.FactoryInstance;
import flex.messaging.FlexFactory;
import flex.messaging.config.ConfigMap;

public class Seasar2Factory extends RemotingServiceInvokerImpl implements
		FlexFactory {
	
	private static final String SOURCE = "source";

    protected RemotingMessageProcessor processor;
    protected RemotingServiceLocator remotingServiceLocator;

	/**
	 * This method is called when the definition of an instance that this factory
	 * looks up is initialized.
	 */
	/*
	 * This method is called when we initialize the definition of an instance 
	 * which will be looked up by this factory.  It should validate that
	 * the properties supplied are valid to define an instance.
	 * Any valid properties used for this configuration must be accessed to 
	 * avoid warnings about unused configuration elements.  If your factory 
	 * is only used for application scoped components, this method can simply
	 * return a factory instance which delegates the creation of the component
	 * to the FactoryInstance's lookup method.
	 */
	public FactoryInstance createFactoryInstance(String id, ConfigMap properties) {

		
		final FactoryInstance instance = new FactoryInstance(this, id,
				properties);
		instance.setSource(properties.getPropertyAsString(SOURCE, instance
				.getId()));

		return instance;

	}

	/**
	 * Returns the instance specified by the source
	 * and properties arguments.  For the factory, this may mean
	 * constructing a new instance, optionally registering it in some other
	 * name space such as the session or JNDI, and then returning it
	 * or it may mean creating a new instance and returning it.
	 * This method is called for each request to operate on the
	 * given item by the system so it should be relatively efficient.
	 * <p>
	 * If your factory does not support the scope property, it
	 * report an error if scope is supplied in the properties
	 * for this instance.
	 */
	
	public Object lookup(FactoryInstance factoryInstance) {
		
		
		//if source elements is not found,return the id attribute.
		//see createFactoryInstance methods.
		String serviceName = factoryInstance.getSource();
		final Object service = remotingServiceLocator.getService(serviceName);
		return service;
	}

	/**
	 * Initializes the component with configuration information.
	 * @param  id contains an identity you can use in diagnostic messages to determine which component's configuration this is
	 * @param configMap  contains the properties for configuring this component.
	 */
	
	public void initialize(final String id, final ConfigMap configMap) {
        S2Container container = SingletonS2ContainerFactory.getContainer();
        remotingServiceLocator = (RemotingServiceLocator) container
                .getComponent(RemotingServiceLocator.class);
	}

}
