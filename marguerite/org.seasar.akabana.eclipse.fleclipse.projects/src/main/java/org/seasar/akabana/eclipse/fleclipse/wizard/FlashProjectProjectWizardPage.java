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
package org.seasar.akabana.eclipse.fleclipse.wizard;

import static org.seasar.dolteng.eclipse.Constants.CTX_APP_TYPE_PACKAGING;
import static org.seasar.dolteng.eclipse.Constants.CTX_PACKAGE_NAME;
import static org.seasar.dolteng.eclipse.Constants.CTX_PACKAGE_PATH;
import static org.seasar.dolteng.eclipse.Constants.CTX_PROJECT_NAME;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.layout.RowLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Text;
import org.eclipse.ui.dialogs.WizardNewProjectCreationPage;
import org.seasar.akabana.eclipse.fleclipse.nls.Images;
import org.seasar.akabana.eclipse.fleclipse.nls.Labels;
import org.seasar.akabana.eclipse.fleclipse.projects.FPProjectBuilderConfigResolver;
import org.seasar.dolteng.eclipse.nls.Messages;
import org.seasar.dolteng.projects.model.ApplicationType;
import org.seasar.dolteng.projects.model.FacetCategory;
import org.seasar.dolteng.projects.model.FacetConfig;
import org.seasar.dolteng.projects.model.FacetDisplay;
import org.seasar.framework.util.ArrayMap;
import org.seasar.framework.util.StringUtil;

public class FlashProjectProjectWizardPage extends WizardNewProjectCreationPage {

    private FPProjectBuilderConfigResolver resolver = new FPProjectBuilderConfigResolver();
    // UI Controls
    private Combo applicationType;

    private Text rootPkgName;

    @SuppressWarnings("unchecked")
    private Map<String, Combo> facetCombos = new ArrayMap/* <String, Combo> */();

    @SuppressWarnings("unchecked")
    private List<Button> facetChecks = new ArrayList<Button>();

    private Label guidance;

    private Listener validateListener = new Listener() {
        public void handleEvent(Event event) {
            boolean valid = validatePage();
            setPageComplete(valid);
        }
    };

    public FlashProjectProjectWizardPage() {
        super("FlashPlatformProjectWizard");
        setTitle(Labels.WIZARD_FP_PROJECT_TITLE);
        setImageDescriptor(Images.FP);

        resolver.initialize();
    }

    @Override
    public void createControl(Composite parent) {
        super.createControl(parent);
        Composite composite = (Composite) getControl();

        createBasicSettingsGroup(composite);
        createFacetSettingsGroup(composite);

        refreshFacets();
    }

    private void createBasicSettingsGroup(Composite parent) {
        Group group = new Group(parent, SWT.NONE);
        group.setLayout(new GridLayout(2, false));
        group.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
        group.setText(Labels.WIZARD_PAGE_FP_BASIC_SETTINGS);

        Label label = new Label(group, SWT.NONE);
        
        label.setText(Labels.WIZARD_PAGE_FP_ROOT_PACKAGE);
        label.setFont(parent.getFont());

        rootPkgName = new Text(group, SWT.BORDER);
        GridData gd = new GridData(GridData.FILL_HORIZONTAL);
        gd.widthHint = 250;
        rootPkgName.setLayoutData(gd);
        rootPkgName.setFont(parent.getFont());
        rootPkgName.addListener(SWT.Modify, validateListener);

        label = new Label(group, SWT.NONE);
        label.setText(Labels.WIZARD_PAGE_FP_TYPE_SELECTION);
        label.setFont(parent.getFont());
        applicationType = new Combo(group, SWT.BORDER | SWT.READ_ONLY);
        applicationType.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
        setApplicationTypeItems(applicationType);
        // applicationTypeCombo.setToolTipText(...);
        applicationType.select(0);
        applicationType.pack();
        applicationType.addListener(SWT.Modify, new Listener() {
            public void handleEvent(Event event) {
                refreshFacets();
            }
        });
    }

    private void createFacetSettingsGroup(Composite parent) {
        Group group = new Group(parent, SWT.NONE);
        group.setLayout(new GridLayout(2, false));
        group.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
        group.setText("Project Facet Settings");

        for (FacetCategory category : resolver.getCategoryList()) {
            Label label = new Label(group, SWT.NONE);
            label.setText(category.getName());
            label.setFont(parent.getFont());

            final Combo facetCombo = new Combo(group, SWT.BORDER
                    | SWT.READ_ONLY);
            facetCombo.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
            facetCombo.addListener(SWT.Modify, validateListener);
            facetCombo.addListener(SWT.Modify, new Listener() {
                public void handleEvent(Event event) {
                    updateDirectories();
                    facetCombo.setToolTipText(getFacetDesc(facetCombo));
                    displayLegacyTypeGuidance();
                }
            });
            facetCombos.put(category.getKey(), facetCombo);
        }

        List<FacetConfig> nonCategorizedFacets = getAvailableFacets();
        if (nonCategorizedFacets.size() != 0) {
            Group otherGroup = new Group(group, SWT.NONE);
            otherGroup.setLayout(new RowLayout(SWT.HORIZONTAL));
            GridData gd = new GridData(GridData.FILL_BOTH);
            gd.horizontalSpan = 2;
            otherGroup.setLayoutData(gd);
            otherGroup.setText("Other Category Facets");
            for (FacetConfig fc : nonCategorizedFacets) {
                Button facetCheck = new Button(otherGroup, SWT.CHECK);
                facetCheck.setText(fc.getName());
                // facetCheck.setToolTipText(fc.getDescription());
                facetCheck.setData(fc.getName(), fc);
                facetCheck.addListener(SWT.Selection, validateListener);
                facetCheck.addListener(SWT.Selection, new Listener() {
                    public void handleEvent(Event event) {
                        updateDirectories();
                        displayLegacyTypeGuidance();
                    }
                });
                facetChecks.add(facetCheck);
            }
        }

        guidance = new Label(group, SWT.BORDER);
        GridData gd = new GridData(GridData.FILL_BOTH);
        gd.horizontalSpan = 2;
        guidance.setLayoutData(gd);
    }

    private void refreshFacets() {
        refreshFacetComboItems();
        refreshFacetChecks();
        setSelectedFacetIds(getApplicationType().getDefaultFacets());
    }

    private void refreshFacetComboItems() {
        for (FacetCategory category : resolver.getCategoryList()) {
            Combo facetCombo = facetCombos.get(category.getKey());
            List<FacetConfig> facets = getAvailableFacets(category);
            facetCombo.removeAll();
            facetCombo.add("None"); // TODO String外部化
            for (FacetConfig fc : facets) {
                facetCombo.add(fc.getName());
                facetCombo.setData(fc.getName(), fc);
            }
            facetCombo.setToolTipText(getFacetDesc(facetCombo));
            facetCombo.select(0);

            facetCombo.setEnabled(!getApplicationType().isDisabled(category));
            if (facetCombo.getEnabled() == false) {
                facetCombo.setText("None");
            }
        }
    }

    private void refreshFacetChecks() {
        for (Button facetCheck : facetChecks) {
            FacetConfig fc = getFacetConfig(facetCheck);

            if (getApplicationType().isDisabled(fc)
                    ) {
                facetCheck.setSelection(false);
                facetCheck.setEnabled(false);
            } else {
                facetCheck.setEnabled(true);
            }
        }
    }

    private List<FacetConfig> getAvailableFacets(FacetCategory category) {
        List<FacetConfig> result = new ArrayList<FacetConfig>();
        for (FacetConfig fc : resolver.getSelectableFacets()) {
        	
            if (getApplicationType().isDisabled(fc)) {
                continue;
            }


            String categoryKey = fc.getCategory();
            if (category == null) {
                if (categoryKey == null
                        || resolver.getCategoryByKey(categoryKey) == null) {
                    result.add(fc);
                }
            } else {
                if (category.getKey().equals(categoryKey)) {
                    result.add(fc);
                }
            }
        }
        return result;
    }

    private List<FacetConfig> getAvailableFacets() {
        return getAvailableFacets(null);
    }

    private void setApplicationTypeItems(Combo applicationTypeCombo) {
        applicationTypeCombo.removeAll();
        for (ApplicationType type : resolver.getApplicationTypeList()) {
            applicationTypeCombo.add(type.getName());
            applicationTypeCombo.setData(type.getName(), type);
        }
    }

    protected void updateDirectories() {
    }

    private String getFacetDesc(Combo facetCombo) {
        if (facetCombo.getSelectionIndex() <= 0) {
            return "";
        }
        FacetDisplay fd = getFacetConfig(facetCombo);
        if (fd == null) {
            return "";
        }
        String desc = fd.getDescription();
        return desc == null ? "" : desc;
    }

    @Override
    protected boolean validatePage() {
        if (super.validatePage() == false) {
            return false;
        }

        //Dolteng設定からMavenかどうかをチェックする。
//        DoltengCommonPreferences pref = DoltengCore.getPreferences();
//        if (pref.isDownloadOnline()
//                && !new File(pref.getMavenReposPath()).exists()) {
//            setErrorMessage("Maven Local Repository Directory is not found: "
//                    + pref.getMavenReposPath());
//            setPageComplete(false);
//            return false;
//        }

        String packageName = getRootPackageName();
        
        Combo projectTypeCombo=applicationType;
        String selectedProjectType=projectTypeCombo.getText();
        //TODO:
        if(selectedProjectType!=null && selectedProjectType.equals(selectedProjectType)) {
        	
        }
        
        if (StringUtil.isEmpty(packageName)||projectTypeCombo.getSelectionIndex()>1) {
            setErrorMessage(Messages.PACKAGE_NAME_IS_EMPTY);
            setPageComplete(false);
            return false;
        }

        setErrorMessage(null);
        setMessage(null);
        return true;
    }

    private FacetConfig getFacetConfig(Control facetControl) {
        String text;
        if (facetControl instanceof Button) {
            text = ((Button) facetControl).getText();
        } else if (facetControl instanceof Combo) {
            text = ((Combo) facetControl).getText();
        } else {
            throw new IllegalArgumentException();
        }
        return (FacetConfig) facetControl.getData(text);
    }

    private ApplicationType getApplicationType() {
        return resolver.getApplicationTypeList().get(
                applicationType.getSelectionIndex());
    }


    private String getRootPackageName() {
        if (rootPkgName == null) {
            return "";
        }
        return rootPkgName.getText();
    }

    private String getRootPackagePath() {
        return getRootPackageName().replace('.', '/');
    }

    private void deselectAll() {
        for (Combo facetCombo : facetCombos.values()) {
            facetCombo.select(0);
        }
        for (Button facetCheck : facetChecks) {
            facetCheck.setSelection(false);
        }
    }

    private void displayLegacyTypeGuidance() {
    }

    private boolean checkProject(String appType, String... elements) {
        if (!getApplicationType().getName().equals(appType)) {
            return false;
        }
        List<String> selected = Arrays.asList(getSelectedFacetIds());
        if (selected.size() != elements.length) {
            return false;
        }
        for (String e : elements) {
            if ("teeda".equals(e)) {
            } else {
                if (!selected.contains(e)) {
                    return false;
                }
            }
        }

        return true;
    }

    private void setSelectedFacetIds(String[] facetIds) {
        deselectAll();
        outer: for (String facetId : facetIds) {
            if (getApplicationType().getFirstFacets().contains(facetId)
                    || getApplicationType().getLastFacets().contains(facetId)) {
                continue;
            }
            for (Combo facetCombo : facetCombos.values()) {
                for (int i = 0; i < facetCombo.getItems().length; i++) {
                    String name = facetCombo.getItems()[i];
                    FacetConfig fc = (FacetConfig) facetCombo.getData(name);
                    if (fc != null && facetId.equals(fc.getId())) {
                        facetCombo.select(i);
                        continue outer;
                    }
                }
            }
            for (Button facetCheck : facetChecks) {
                FacetConfig fc = getFacetConfig(facetCheck);
                if (fc != null && facetId.equals(fc.getId())) {
                    facetCheck.setSelection(true);
                    continue outer;
                }
            }
        }
        displayLegacyTypeGuidance();
    }

    String[] getSelectedFacetIds() {
        List<String> keys = new ArrayList<String>(getApplicationType()
                .getFirstFacets());
        for (Combo facetCombo : facetCombos.values()) {
            if (facetCombo.getSelectionIndex() < 0) {
                continue;
            }
            FacetDisplay fd = getFacetConfig(facetCombo);
            if (fd != null) {
                keys.add(fd.getId());
            }
        }
        for (Button facetCheck : facetChecks) {
            if (facetCheck.getSelection()) {
                FacetDisplay fd = getFacetConfig(facetCheck);
                if (fd != null) {
                    keys.add(fd.getId());
                }
            }
        }
        keys.addAll(getApplicationType().getLastFacets());
        return keys.toArray(new String[keys.size()]);
    }

    FPProjectBuilderConfigResolver getResolver() {
        return resolver;
    }

    Map<String, String> getConfigureContext() {
        Map<String, String> ctx = new HashMap<String, String>();

//        ctx.put("libPath", "libs");
//        ctx.put("flexSDK", "Flex 3.3");
        ctx.put(CTX_PROJECT_NAME, getProjectName());
        ctx.put(CTX_PACKAGE_NAME, getRootPackageName());
        ctx.put(CTX_PACKAGE_PATH, getRootPackagePath());
        ctx.put(CTX_APP_TYPE_PACKAGING, getApplicationType().getPackaging());
        ctx.put("appType", getApplicationType().getId());

        return ctx;
    }
}
