package examples.flex2.camera.snapshot.naming.impl;

import examples.flex2.camera.snapshot.naming.FileNameResolver;


public class FileNameResolverImpl implements FileNameResolver {

    public String getFileName(Object object) {
        return "" + System.currentTimeMillis();
    }
}
