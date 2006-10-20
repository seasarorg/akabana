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



import javax.servlet.ServletConfig;

import org.seasar.flex2.rpc.remoting.service.RemotingServiceLocator;
import org.seasar.flex2.rpc.remoting.service.impl.RemotingServiceInvokerImpl;
import org.seasar.framework.container.S2Container;
import org.seasar.framework.container.deployer.ComponentDeployerFactory;
import org.seasar.framework.container.deployer.ExternalComponentDeployerProvider;
import org.seasar.framework.container.external.servlet.HttpServletExternalContext;
import org.seasar.framework.container.external.servlet.HttpServletExternalContextComponentDefRegister;
import org.seasar.framework.container.factory.SingletonS2ContainerFactory;

import flex.messaging.FactoryInstance;
import flex.messaging.FlexContext;
import flex.messaging.FlexFactory;
import flex.messaging.config.ConfigMap;
import flex.messaging.util.StringUtils;

/**
 * <h4>Seasar2Factory</h4>
 * FDS2のFactoryMechanismを利用したFactoryクラスです。
 * Flex2クライアントから
 * S2Containerに登録されたコンポーネントを呼び出すことが可能になります。
 * 
 *
 */
public class Seasar2Factory extends RemotingServiceInvokerImpl implements
		FlexFactory {

	/**  source tag  name CONSTANT */
	private static final String SOURCE = "source";

	/** ServiceLocator */
	protected RemotingServiceLocator remotingServiceLocator;

	private static final long serialVersionUID = 407266935204779128L;

    public static final String CONFIG_PATH_KEY = "configPath";

    public static final String DEBUG_KEY = "debug";

//    public static final String COMMAND = "command";

  //  public static final String RESTART = "restart";

	/**
	 * このメソッドでは、Factoryの定義を初期化するときに呼ばれます。
	 * <!--
	 * This method is called when the definition of an instance that this factory
	 * looks up is initialized.
	 * -->
	 */
	public FactoryInstance createFactoryInstance(String id, ConfigMap properties) {

		final FactoryInstance instance = new FactoryInstance(this, id,
				properties);
		instance.setSource(properties.getPropertyAsString(SOURCE, instance
				.getId()));

		return instance;

	}

	/**
	 * flex-services.xmlで設定されているserviceNameのsourceタグで指定された
	 * サービス名よりS2Containerに登録されているコンポーネントを取得します。
	 * ロジック実行は、Adapterによって起動されます
	 * 
	 * @param FactoryInstance
	 * @return Object S2Containerより取得したコンポーネント
	 * <br/>
	 * Returns the instance specified by the source
	 * and properties arguments. 
	 */

	public Object lookup(FactoryInstance factoryInstance) {
		//if source elements is not found,return the id attribute.
		//see createFactoryInstance methods.
		String serviceName = factoryInstance.getSource();
		final Object service = remotingServiceLocator.getService(serviceName);
		return service;
	}

	/**
	 * 
	 *　設定情報とともにコンポーネントを初期化します。
	 * Initializes the component with configuration information.
	 * @param  id contains an identity you can use in diagnostic messages to determine which component's configuration this is
	 * @param configMap  コンポーネントの設定情報 contains the properties for configuring this component.
	 */

	public void initialize(final String id, final ConfigMap configMap) {

		//S2Container intialize sequence.
		String configPath = null;

		ServletConfig servletConfig =FlexContext.getServletConfig();
		
        if (servletConfig != null) {
            configPath = servletConfig.getInitParameter(CONFIG_PATH_KEY);    

        }
        if (!StringUtils.isEmpty(configPath)) {
            SingletonS2ContainerFactory.setConfigPath(configPath);
        }

        
        /* ここからSingletonContainerInitializerのかわり */
        if (ComponentDeployerFactory.getProvider() instanceof ComponentDeployerFactory.DefaultProvider) {
            ComponentDeployerFactory
                    .setProvider(new ExternalComponentDeployerProvider());
        }
        
        HttpServletExternalContext extCtx = new HttpServletExternalContext();
        extCtx.setApplication(FlexContext.getServletContext());
        
        SingletonS2ContainerFactory.setExternalContext(extCtx);
        SingletonS2ContainerFactory
                .setExternalContextComponentDefRegister(new HttpServletExternalContextComponentDefRegister());
        SingletonS2ContainerFactory.init();
        /* ここまでSingletonContainerInitializerのかわり */
        
        
        /*
        SingletonContainerInitializer initializer = new SingletonS2ContainerInitializer();
        initializer.setConfigPath(configPath);
        initializer.setApplication(getServletContext());
        initializer.initialize();
        */
        
		S2Container container = SingletonS2ContainerFactory.getContainer();
		remotingServiceLocator = (RemotingServiceLocator) container
				.getComponent(RemotingServiceLocator.class);
	}

}