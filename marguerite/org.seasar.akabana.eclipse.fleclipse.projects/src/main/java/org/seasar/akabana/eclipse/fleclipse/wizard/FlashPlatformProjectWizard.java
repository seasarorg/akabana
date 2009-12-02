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
import java.lang.reflect.InvocationTargetException;
import java.util.Map;

import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.jface.operation.IRunnableWithProgress;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.wizard.Wizard;
import org.eclipse.ui.INewWizard;
import org.eclipse.ui.IWorkbench;
import org.seasar.akabana.eclipse.fleclipse.projects.FPProjectBuilderConfigResolver;
import org.seasar.dolteng.eclipse.DoltengCore;
import org.seasar.dolteng.eclipse.util.ProgressMonitorUtil;
import org.seasar.dolteng.projects.ProjectBuilder;

/**
 * @author nod
 */
public class FlashPlatformProjectWizard extends Wizard implements INewWizard {
    private FlashProjectProjectWizardPage page;


    public FlashPlatformProjectWizard() {
        super();
        setNeedsProgressMonitor(true);
    }

    /*
     * (non-Javadoc)
     * 
     * @see org.eclipse.jface.wizard.Wizard#addPages()
     */
    @Override
    public void addPages() {
        super.addPages();
        page = new FlashProjectProjectWizardPage();
        addPage(page);
    }

    /*
     * (non-Javadoc)
     * 
     * @see org.eclipse.jface.wizard.Wizard#performFinish()
     */
    @Override
    public boolean performFinish() {
        try {
            getContainer().run(false, false, new NewFPProjectCreation());
            return true;
        } catch (InvocationTargetException e) {
            DoltengCore.log(e.getTargetException());
        } catch (Exception e) {
            DoltengCore.log(e);
        }
        return false;
    }

    /*
     * (non-Javadoc)
     * 
     * @see org.eclipse.ui.IWorkbenchWizard#init(org.eclipse.ui.IWorkbench,
     *      org.eclipse.jface.viewers.IStructuredSelection)
     */
    public void init(IWorkbench workbench, IStructuredSelection selection) {

    }

    private class NewFPProjectCreation implements IRunnableWithProgress {
        public void run(IProgressMonitor monitor) throws InterruptedException {
            monitor = ProgressMonitorUtil.care(monitor);
            try {
                FPProjectBuilderConfigResolver resolver = page.getResolver();

                String[] facetIds = page.getSelectedFacetIds();
                
                Map<String, String> ctx = resolver.resolveProperty(facetIds, "");//new HashMap<String, String>();
                ctx.putAll(page.getConfigureContext());

                ProjectBuilder builder = resolver.resolve(facetIds, page
                        .getProjectHandle(), page.getLocationPath(), ctx);
                builder.build(monitor);
                
            } catch (Exception e) {
                DoltengCore.log(e);
                throw new InterruptedException();
            } finally {
                monitor.done();
            }
        }
    }
}
