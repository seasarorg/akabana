package examples.flex2.camera.snapshot.service.impl;

import java.util.Date;

import org.seasar.flex2.rpc.remoting.service.annotation.RemotingService;

import examples.flex2.camera.snapshot.dto.SnapshotDto;
import examples.flex2.camera.snapshot.logic.SnapshotSaveLogic;
import examples.flex2.camera.snapshot.service.SnapshotService;

/**
 * @ RemotingService
 */
@RemotingService
public class SnapshotServiceImpl implements SnapshotService {

    private SnapshotSaveLogic snapshotSaveLogic;

    public SnapshotSaveLogic getSnapshotSaveLogic() {
        return snapshotSaveLogic;
    }

    public String save(SnapshotDto snapshot) {
        System.out.println("[take a snapshot]" + new Date());
        return snapshotSaveLogic.save(snapshot);
    }

    public void setSnapshotSaveLogic(SnapshotSaveLogic saveLogic) {
        this.snapshotSaveLogic = saveLogic;
    }
}
