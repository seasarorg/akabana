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

import static org.seasar.dolteng.projects.Constants.ATTR_APP_TYPE_ID;
import static org.seasar.dolteng.projects.Constants.ATTR_APP_TYPE_NAME;
import static org.seasar.dolteng.projects.Constants.ATTR_APP_TYPE_PACKAGING;
import static org.seasar.dolteng.projects.Constants.ATTR_CATEGORY_ID;
import static org.seasar.dolteng.projects.Constants.ATTR_CATEGORY_KEY;
import static org.seasar.dolteng.projects.Constants.ATTR_CATEGORY_NAME;
import static org.seasar.dolteng.projects.Constants.ATTR_COMPONENT_CLASS;
import static org.seasar.dolteng.projects.Constants.ATTR_COMPONENT_NAME;
import static org.seasar.dolteng.projects.Constants.ATTR_CTXPROP_NAME;
import static org.seasar.dolteng.projects.Constants.ATTR_CTXPROP_VALUE;
import static org.seasar.dolteng.projects.Constants.ATTR_DEFAULT_FACET;
import static org.seasar.dolteng.projects.Constants.ATTR_DISABLE_CATEGORY;
import static org.seasar.dolteng.projects.Constants.ATTR_DISABLE_FACET;
import static org.seasar.dolteng.projects.Constants.ATTR_FACET_EXTENDS;
import static org.seasar.dolteng.projects.Constants.ATTR_FACET_ROOT;
import static org.seasar.dolteng.projects.Constants.ATTR_FIRST_FACET;
import static org.seasar.dolteng.projects.Constants.ATTR_HAND_CLASS;
import static org.seasar.dolteng.projects.Constants.ATTR_HAND_LOADER;
import static org.seasar.dolteng.projects.Constants.ATTR_HAND_TYPE;
import static org.seasar.dolteng.projects.Constants.ATTR_IF_JRE;
import static org.seasar.dolteng.projects.Constants.ATTR_INCLUDE_PATH;
import static org.seasar.dolteng.projects.Constants.ATTR_LAST_FACET;
import static org.seasar.dolteng.projects.Constants.ATTR_LOADER_CLASS;
import static org.seasar.dolteng.projects.Constants.EXTENSION_POINT_NEW_PROJECT;
import static org.seasar.dolteng.projects.Constants.EXTENSION_POINT_RESOURCE_HANDLER;
import static org.seasar.dolteng.projects.Constants.EXTENSION_POINT_RESOURCE_LOADER;
import static org.seasar.dolteng.projects.Constants.TAG_COMPONENT;
import static org.seasar.dolteng.projects.Constants.TAG_CONTEXT_PROPERTY;
import static org.seasar.dolteng.projects.Constants.TAG_DEFAULT;
import static org.seasar.dolteng.projects.Constants.TAG_DISABLE;
import static org.seasar.dolteng.projects.Constants.TAG_ENTRY;
import static org.seasar.dolteng.projects.Constants.TAG_FIRST;
import static org.seasar.dolteng.projects.Constants.TAG_HANDLER;
import static org.seasar.dolteng.projects.Constants.TAG_IF;
import static org.seasar.dolteng.projects.Constants.TAG_INCLUDE;
import static org.seasar.dolteng.projects.Constants.TAG_LAST;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IConfigurationElement;
import org.eclipse.core.runtime.IPath;
import org.seasar.dolteng.eclipse.Constants;
import org.seasar.dolteng.eclipse.DoltengCore;
import org.seasar.dolteng.eclipse.loader.ResourceLoader;
import org.seasar.dolteng.eclipse.loader.impl.CompositeResourceLoader;
import org.seasar.dolteng.eclipse.util.ScriptingUtil;
import org.seasar.dolteng.projects.ProjectBuilder;
import org.seasar.dolteng.projects.handler.ResourceHandler;
import org.seasar.dolteng.projects.handler.impl.DefaultHandler;
import org.seasar.dolteng.projects.handler.impl.DiconHandler;
import org.seasar.dolteng.projects.model.ApplicationType;
import org.seasar.dolteng.projects.model.Entry;
import org.seasar.dolteng.projects.model.FacetCategory;
import org.seasar.dolteng.projects.model.FacetConfig;
import org.seasar.dolteng.projects.model.dicon.DiconElement;
import org.seasar.dolteng.projects.model.dicon.DiconModel;
import org.seasar.eclipse.common.util.ExtensionAcceptor;
import org.seasar.framework.util.ArrayMap;
import org.seasar.framework.util.StringUtil;

/**
 * @author nod
 *
 */
public class FPProjectBuilderConfigResolver {//extends ProjectBuildConfigResolver {

    private Map<String, IConfigurationElement> loaderFactories = new HashMap<String, IConfigurationElement>();

    private Map<String, IConfigurationElement> handlerFactories = new HashMap<String, IConfigurationElement>();

    private List<FacetCategory> categoryList = new ArrayList<FacetCategory>();

    private List<ApplicationType> applicationTypeList = new ArrayList<ApplicationType>();

    private List<FacetConfig> allFacets = new ArrayList<FacetConfig>();
	
	/**
	 * 
	 */
	public FPProjectBuilderConfigResolver() {
		super();
	}
	
	
    public static final String TAG_FP_FACET = "fpfacet";
    
    public static final String TAG_FP_CATEGORY = "fpcategory";
    
    public static final String TAG_FP_APP_TYPE="fpapplicationtype";
    
    public void initialize() {
//   	super.initialize();
//   	getAllFacets().clear();
        loaderFactories = new HashMap<String, IConfigurationElement>();
        handlerFactories = new HashMap<String, IConfigurationElement>();
        categoryList = new ArrayList<FacetCategory>();
        applicationTypeList = new ArrayList<ApplicationType>();
        allFacets = new ArrayList<FacetConfig>();

        ExtensionAcceptor.accept(Activator.PLUGIN_ID, EXTENSION_POINT_RESOURCE_LOADER,
                new ExtensionAcceptor.ExtensionVisitor() {
                    public void visit(IConfigurationElement e) {
                        if (EXTENSION_POINT_RESOURCE_LOADER.equals(e.getName())) {
                            loaderFactories.put(e.getAttribute("name"), e);
                        }
                    }
                });

        ExtensionAcceptor.accept(Activator.PLUGIN_ID, EXTENSION_POINT_RESOURCE_HANDLER,
                new ExtensionAcceptor.ExtensionVisitor() {
                    public void visit(IConfigurationElement e) {
                        if (EXTENSION_POINT_RESOURCE_HANDLER
                                .equals(e.getName())) {
                            handlerFactories.put(e.getAttribute("name"), e);
                        }
                    }
                });    	
        ExtensionAcceptor.accept(Activator.PLUGIN_ID, EXTENSION_POINT_NEW_PROJECT,
                new ExtensionAcceptor.ExtensionVisitor() {
                    public void visit(IConfigurationElement e) {
                        if (TAG_FP_FACET.equals(e.getName())) {
                        	getAllFacets().add(new FacetConfig(e));
                        }
                    }
                });	
        getCategoryList().clear();
        getApplicationTypeList().clear();
        ExtensionAcceptor.accept(Activator.PLUGIN_ID, "projectType",
                new ExtensionAcceptor.ExtensionVisitor() {
                    public void visit(IConfigurationElement e) {
                        if (TAG_FP_CATEGORY.equals(e.getName())) {
                            String categoryId = e
                                    .getAttribute(ATTR_CATEGORY_ID);
                            if (getCategoryById(categoryId) == null) {
                                FacetCategory category = new FacetCategory(
                                        categoryId,
                                        e.getAttribute(ATTR_CATEGORY_KEY),
                                        e.getAttribute(ATTR_CATEGORY_NAME));
                                getCategoryList().add(category);
                            }
                        } else if (TAG_FP_APP_TYPE.equals(e.getName())) {
                            String applicationTypeId = e
                                    .getAttribute(ATTR_APP_TYPE_ID);
                            ApplicationType type = getApplicationType(applicationTypeId);
                            if (type == null) {
                                type = new ApplicationType(applicationTypeId, e
                                        .getAttribute(ATTR_APP_TYPE_NAME), e
                                        .getAttribute(ATTR_APP_TYPE_PACKAGING));
                                getApplicationTypeList().add(type);
                            }

                            IConfigurationElement[] defaultTag = e
                                    .getChildren(TAG_DEFAULT);
                            for (IConfigurationElement child : defaultTag) {
                                for (String facetId : child.getAttribute(
                                        ATTR_DEFAULT_FACET).split("[ ]*,[ ]*")) {
                                    type.addDefaultFacet(facetId);
                                }
                            }

                            IConfigurationElement[] disableTag = e
                                    .getChildren(TAG_DISABLE);
                            for (IConfigurationElement child : disableTag) {
                                String category = child
                                        .getAttribute(ATTR_DISABLE_CATEGORY);
                                String facet = child
                                        .getAttribute(ATTR_DISABLE_FACET);
                                type.disableCategory(category);
                                type.disableFacet(facet);
                            }
                            IConfigurationElement[] firstTag = e
                            .getChildren(TAG_FIRST);
		                    for (IConfigurationElement child : firstTag) {
		                        String firstFacet = child
		                                .getAttribute(ATTR_FIRST_FACET);
		                        type.addFirst(firstFacet);
		                    }
		
		                    IConfigurationElement[] lastTag = e
		                            .getChildren(TAG_LAST);
		                    for (IConfigurationElement child : lastTag) {
		                        String lastFacet = child
		                                .getAttribute(ATTR_LAST_FACET);
		                        type.addLast(lastFacet);
		                    }   
                        }
                    }
        });
    }
    /**
    * 拡張ボインとに設定された全てのファセット情報のリストを得る。 選択不可ファセット（displayOrderが設定されていない）も含む。
    * 
    * @return ファセット情報のリスト
    */
   public List<FacetConfig> getAllFacets() {
       return allFacets;
   }

    /**
     * 選択可能なファセット（displayOrderが設定されている）のリストを得る。
     * 
     * @return ファセット情報のリスト
     */
    public List<FacetConfig> getSelectableFacets() {
//    	return super.getSelectableFacets();
        List<FacetConfig> result = new ArrayList<FacetConfig>();
        for (FacetConfig fc : allFacets) {
            if (fc.isSelectableFacet()) {
                result.add(fc);
            }
        }
        return result;
    }
    /**
     * ファセットIDからファセット情報を取得する。
     * 
     * @param facetId
     *            取得したいファセットID。nullであった場合は<code>IllegalArgumentException</code>がスローされる。
     * @return ファセット情報。見つからなかった場合は<code>null</code>を返す。
     */
    public FacetConfig getFacet(String facetId) {
        if (facetId == null) {
            throw new IllegalArgumentException("facetId is null.");
        }
        for (FacetConfig fc : allFacets) {
            if (facetId.equals(fc.getId())) {
                return fc;
            }
        }
        DoltengCore.log("facet not found: " + facetId);
        return null;
    }
    
    public List<FacetCategory> getCategoryList() {
        return categoryList;
    }
    
    /**
     * カテゴリIDからファセットカテゴリ情報を取得する。
     * 
     * @param categoryId
     *            取得したいファセットカテゴリID。nullであった場合は
     *            <code>IllegalArgumentException</code>がスローされる。
     * @return ファセットカテゴリ情報。見つからなかった場合は<code>null</code>を返す。
     */
    public FacetCategory getCategoryById(String categoryId) {
        if (categoryId == null) {
            throw new IllegalArgumentException("categoryId is null.");
        }
        for (FacetCategory category : categoryList) {
            if (categoryId.equals(category.getId())) {
                return category;
            }
        }
        return null;
    }

    /**
     * カテゴリキー（アルファベット2文字）からファセットカテゴリ情報を取得する。
     * 
     * @param categoryKey
     *            取得したいファセットカテゴリキー。nullであった場合や、アルファベット2文字でなかった場合は
     *            <code>IllegalArgumentException</code>がスローされる。
     * @return ファセットカテゴリ情報。見つからなかった場合は<code>null</code>を返す。
     */
    public FacetCategory getCategoryByKey(String categoryKey) {
        if (categoryKey == null || categoryKey.length() != 2) {
            throw new IllegalArgumentException("categoryKey is null.");
        }
        for (FacetCategory category : categoryList) {
            if (categoryKey.equals(category.getKey())) {
                return category;
            }
        }
        return null;
    }

    /**
     * 拡張ポイントに設定されたアプリケーションタイプ情報のリストを得る。
     * 
     * @return アプリケーションタイプ情報のリスト
     */
    public List<ApplicationType> getApplicationTypeList() {
        return applicationTypeList;
    }

    /**
     * アプリケーションタイプIDからアプリケーションタイプ情報を取得する。
     * 
     * @param applicationTypeId
     *            取得したいアプリケーションタイプID。nullであった場合は
     *            <code>IllegalArgumentException</code>がスローされる。
     * @return アプリケーションタイプ情報。見つからなかった場合は<code>null</code>を返す。
     */
    public ApplicationType getApplicationType(String applicationTypeId) {
        if (applicationTypeId == null) {
            throw new IllegalArgumentException("applicationTypeId is null.");
        }
        for (ApplicationType at : applicationTypeList) {
            if (applicationTypeId.equals(at.getId())) {
                return at;
            }
        }
        return null;
    }

    /* ------------------------------------------------------------------ */

    /**
     * 与えられたファセット群による、デフォルトのコンテキスト情報（plugin.xmlの&lt;property&gt;タグで設定された情報）を取得する。
     * 
     * @param facetIds
     *            ファセットIDの配列
     * @param javaVersion
     * @return デフォルトのコンテキスト情報
     * @throws CoreException
     */
    public Map<String, String> resolveProperty(String[] facetIds,
            String javaVersion) throws CoreException {
        Map<String, String> ctx = new HashMap<String, String>();
        ctx.put(Constants.CTX_JAVA_VERSION_NUMBER, javaVersion);

        Set<String> proceedIds = new HashSet<String>();
        Set<String> propertyNames = new HashSet<String>();
        for (String facetId : facetIds) {
            resolveProperty(facetId, ctx, proceedIds, propertyNames);
        }
        return ctx;
    }

    protected void resolveProperty(String facetId, Map<String, String> ctx,
            Set<String> proceedIds, Set<String> propertyNames)
            throws CoreException {

        if (proceedIds.contains(facetId)) {
            return;
        }
        proceedIds.add(facetId);

        FacetConfig fc = getFacet(facetId);
        IConfigurationElement currentFacetElement = fc
                .getConfigurationElement();

        registerProperty(ctx, propertyNames, currentFacetElement);
        resolveExtendsProperty(ctx, proceedIds, propertyNames,
                currentFacetElement);
        resolveIfProperty(ctx, propertyNames, currentFacetElement);
    }

    protected void registerProperty(Map<String, String> ctx,
            Set<String> propertyNames, IConfigurationElement element) {
        IConfigurationElement[] propertyElements = element
                .getChildren(TAG_CONTEXT_PROPERTY);
        for (IConfigurationElement propNode : propertyElements) {
            String name = propNode.getAttribute(ATTR_CTXPROP_NAME);
            if (propertyNames.contains(name) == false) {
                ctx.put(name, propNode.getAttribute(ATTR_CTXPROP_VALUE));
                propertyNames.add(name);
            }
        }
    }

    protected void resolveExtendsProperty(Map<String, String> ctx,
            Set<String> proceedIds, Set<String> propertyNames,
            IConfigurationElement current) throws CoreException {
        String extendsAttr = current.getAttribute(ATTR_FACET_EXTENDS);
        if (StringUtil.isEmpty(extendsAttr) == false) {
            for (String parentId : extendsAttr.split("[ ]*,[ ]*")) {
                resolveProperty(parentId, ctx, proceedIds, propertyNames);
            }
        }
    }

    protected void resolveIfProperty(Map<String, String> ctx,
            Set<String> propertyNames, IConfigurationElement facetNode) {
        for (IConfigurationElement ifNode : facetNode.getChildren(TAG_IF)) {
            String ifAttr = ifNode.getAttribute(ATTR_IF_JRE);
            String jreVersion = ctx
                    .get(org.seasar.dolteng.eclipse.Constants.CTX_JAVA_VERSION_NUMBER);
            for (String ver : ifAttr.split("[ ]*,[ ]*")) {
                if (jreVersion.equals(ver)) {
                    registerProperty(ctx, propertyNames, ifNode);
                }
            }
        }
    }

    /* ------------------------------------------------------------------ */

    /**
     * プロジェクトビルダを生成する。
     * 
     * @param facetIds
     *            ファセットIDの配列
     * @param project
     *            ビルドされるプロジェクト
     * @param location
     *            プロジェクトロケーション
     * @param configContext
     *            ビルドコンテキスト情報
     * @return 生成されたプロジェクトビルダ
     * @throws CoreException
     */
    public ProjectBuilder resolve(String[] facetIds, IProject project,
            IPath location, Map<String, String> configContext)
            throws CoreException {

        ProjectBuilder builder = new ProjectBuilder(project, location,
                configContext);

        Set<String> proceedIds = new HashSet<String>();
        for (String facetId : facetIds) {
            resolveFacet(facetId, builder, proceedIds);
        }
        return builder;
    }

    protected void resolveFacet(String facetId, ProjectBuilder builder,
            Set<String> proceedIds) throws CoreException {

        if (proceedIds.contains(facetId)) {
            return;
        }
        proceedIds.add(facetId);

        FacetConfig pc = getFacet(facetId);
        IConfigurationElement current = pc.getConfigurationElement();
        // ResourceLoader loader = (ResourceLoader) current
        // .createExecutableExtension(EXTENSION_POINT_RESOURCE_LOADER);

        resolveExtends(builder, current, proceedIds);
        resolveMain(builder, current);
        resolveIf(builder, current);
    }

    protected void resolveExtends(ProjectBuilder builder,
            IConfigurationElement current, Set<String> proceedIds)
            throws CoreException {
        String extendsAttr = current.getAttribute(ATTR_FACET_EXTENDS);
        if (StringUtil.isEmpty(extendsAttr) == false) {
            for (String parentId : extendsAttr.split("[ ]*,[ ]*")) {
                resolveFacet(parentId, builder, proceedIds);
            }
        }
    }

    protected void resolveMain(ProjectBuilder builder,
            IConfigurationElement current) {
        registerRoot(builder, current);
        registerHandler(builder, current);
    }

    protected void resolveIf(ProjectBuilder builder,
            IConfigurationElement facetNode) {
        for (IConfigurationElement ifNode : facetNode.getChildren(TAG_IF)) {
            String ifAttr = ifNode.getAttribute(ATTR_IF_JRE);
            String jreVersion = builder.getConfigContext().get(
                    org.seasar.dolteng.eclipse.Constants.CTX_JAVA_VERSION_NUMBER);
            for (String ver : ifAttr.split("[ ]*,[ ]*")) {
                if (jreVersion.equals(ver)) {
                    resolveMain(builder, ifNode);
                }
            }
        }
    }

    protected void registerRoot(ProjectBuilder builder,
            IConfigurationElement element) {
        String rootAttr = element.getAttribute(ATTR_FACET_ROOT);
        if (StringUtil.isEmpty(rootAttr) == false) {
            for (String root : rootAttr.split("[ ]*,[ ]*")) {
                builder.addRoot(root);
            }
        }
    }

    protected void registerHandler(ProjectBuilder builder,
            IConfigurationElement element) {
        for (IConfigurationElement handNode : element.getChildren(TAG_HANDLER)) {
            ResourceHandler handler = createHandler(handNode);
            manageHandlerContents(builder, handNode, handler);
            builder.addHandler(handler);
        }
    }

    protected ResourceHandler createHandler(IConfigurationElement handNode) {
        ResourceHandler handler = null;
        String type = handNode.getAttribute(ATTR_HAND_TYPE);
        if (type == null) {
            return new DefaultHandler();
        }
        IConfigurationElement factory = handlerFactories.get(type);
        if (factory == null) {
            DoltengCore.log("resource handler (" + type + ") is not defined.");
            return new DefaultHandler();
        }

        try {
            handler = (ResourceHandler) factory
                    .createExecutableExtension(ATTR_HAND_CLASS);
        } catch (CoreException e) {
            DoltengCore.log(e);
        }

        if (handler == null) {
            handler = new DefaultHandler();
        }
        return handler;
    }

    protected ResourceLoader createLoader(IConfigurationElement handNode) {
        ResourceLoader loader = null;
        String type = handNode.getAttribute(ATTR_HAND_LOADER);
        if (type == null) {
            return new CompositeResourceLoader();
        }
        IConfigurationElement factory = loaderFactories.get(type);
        if (factory == null) {
            DoltengCore.log("resource loader (" + type + ") is not defined.");
            return new CompositeResourceLoader();
        }

        try {
            loader = (ResourceLoader) factory
                    .createExecutableExtension(ATTR_LOADER_CLASS);
        } catch (CoreException e) {
            DoltengCore.log(e);
        }

        if (loader == null) {
            loader = new CompositeResourceLoader();
        }
        return loader;
    }

    protected void manageHandlerContents(ProjectBuilder builder,
            IConfigurationElement handNode, ResourceHandler handler) {
        ResourceLoader loader = createLoader(handNode);

        if (handler instanceof DiconHandler) {
            manageDiconHandler(handNode, (DiconHandler) handler);
        } else {
            IConfigurationElement[] entNodes = handNode.getChildren(TAG_ENTRY);
            for (IConfigurationElement entryElement : entNodes) {
                Entry entry = new Entry(loader);
                for (String attrName : entryElement.getAttributeNames()) {
                    String attr = entryElement.getAttribute(attrName);
                    if (StringUtil.isEmpty(attr) == false) {
                        attr = ScriptingUtil.resolveString(attr, builder
                                .getConfigContext());
                        entry.attribute.put(attrName, attr);
                    }
                }
                String value = entryElement.getValue();
                if (StringUtil.isEmpty(value) == false) {
                    value = ScriptingUtil.resolveString(value, builder
                            .getConfigContext());
                    entry.value = value;
                }
//                entry.dependency = findDependency(entryElement);
                handler.add(entry);
            }
        }
    }

//    private DependencyModel findDependency(IConfigurationElement entryElement) {
//        if (findValue(entryElement, "groupId") == null) {
//            return null;
//        }
//        DependencyModel result = new DependencyModel();
//        result.groupId = findValue(entryElement, "groupId");
//        result.artifactId = findValue(entryElement, "artifactId");
//        result.version = findValue(entryElement, "version");
//        result.scope = findValue(entryElement, "scope");
//        IConfigurationElement[] exclusions = entryElement
//                .getChildren("exclusions");
//        if (exclusions != null && exclusions.length > 0) {
//            for (IConfigurationElement exclusion : exclusions[0]
//                    .getChildren("exclusion")) {
//                DependencyModel d = new DependencyModel();
//                d.groupId = findValue(exclusion, "groupId");
//                d.artifactId = findValue(exclusion, "artifactId");
//                result.exclusions.add(d);
//            }
//        }
//        return result;
//    }

    private String findValue(IConfigurationElement entryElement, String tagName) {
        for (IConfigurationElement child : entryElement.getChildren()) {
            if (child.getName().equalsIgnoreCase(tagName)) {
                return child.getValue();
            }
        }
        return null;
    }

    protected void manageDiconHandler(IConfigurationElement handNode,
            DiconHandler handler) {
        DiconModel model = handler.getModel();

        IConfigurationElement[] incNodes = handNode.getChildren(TAG_INCLUDE);
        for (IConfigurationElement includeElement : incNodes) {
            final String includePath = includeElement
                    .getAttribute(ATTR_INCLUDE_PATH);
            
            ArrayMap map = new ArrayMap();
            map.put(ATTR_INCLUDE_PATH, includePath);
            model.appendChild(new DiconElement("include", map));
        }

        IConfigurationElement[] compoNodes = handNode
                .getChildren(TAG_COMPONENT);
        for (IConfigurationElement compNode : compoNodes) {
            String compName = compNode.getAttribute(ATTR_COMPONENT_NAME);
            String compClazz = compNode.getAttribute(ATTR_COMPONENT_CLASS);
            DiconElement target = model.getComponent(compName, compClazz);
            for (IConfigurationElement node : compNode.getChildren()) {
                target.appendChild(assebleElement(node));
            }
        }
    }

    private DiconElement assebleElement(IConfigurationElement node) {
        DiconElement result = new DiconElement(node.getName(),
                (ArrayMap) createAttributeMap(node), node.getValue());
        result.setCounteract(Boolean.valueOf(node.getAttribute("counteract")));
        for (IConfigurationElement child : node.getChildren()) {
            result.appendChild(assebleElement(child));
        }
        result.appendChild(new DiconElement("", null, node.getValue()));
        return result;
    }

    protected Map<String, String> createAttributeMap(IConfigurationElement node) {
        @SuppressWarnings("unchecked")
        Map<String, String> result = new ArrayMap();
        for (String attributeName : node.getAttributeNames()) {
            result.put(attributeName, node.getAttribute(attributeName));
        }
        return result;
    }    
}
