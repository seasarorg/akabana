package examples.flex2.camera.snapshot.logic.impl;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import org.seasar.framework.util.FileOutputStreamUtil;

import examples.flex2.camera.snapshot.config.SnapshotServiceConfig;
import examples.flex2.camera.snapshot.dto.SnapshotDto;
import examples.flex2.camera.snapshot.logic.SnapshotSaveLogic;
import examples.flex2.camera.snapshot.naming.FileNameResolver;

public class SnapshotSaveLogicImpl implements SnapshotSaveLogic {

	private FileNameResolver fileNameResolver;

	private SnapshotServiceConfig snapshotServiceConfig;

	public FileNameResolver getFileNameResolver() {
		return fileNameResolver;
	}

	public SnapshotServiceConfig getSnapshotServiceConfig() {
		return snapshotServiceConfig;
	}

	public String save(SnapshotDto snapshot) {
		Byte[] bytes = snapshot.getSource();
		File file = createSnapshotFile();
		FileOutputStream fileOutputStream = FileOutputStreamUtil.create(file);

		try {
			for (int i = 0; i < bytes.length; i++) {
				fileOutputStream.write(bytes[i].byteValue());
			}
			fileOutputStream.flush();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (fileOutputStream != null) {
				try {
					fileOutputStream.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return snapshotServiceConfig.getRootUri() + file.getName();
	}

	public void setFileNameResolver(FileNameResolver fileNameResolver) {
		this.fileNameResolver = fileNameResolver;
	}

	public void setSnapshotServiceConfig(SnapshotServiceConfig serviceConfig) {
		this.snapshotServiceConfig = serviceConfig;
	}

	private final String createFileName() {
		return snapshotServiceConfig.getPrefix()
				+ fileNameResolver.getFileName(null)
				+ snapshotServiceConfig.getSuffix();
	}

	private final File createSnapshotFile() {
		File saveDir = new File(snapshotServiceConfig.getRootPath());
		if (!saveDir.exists()) {
			saveDir.mkdir();
		}
		return new File(snapshotServiceConfig.getRootPath() + createFileName());
	}
}
