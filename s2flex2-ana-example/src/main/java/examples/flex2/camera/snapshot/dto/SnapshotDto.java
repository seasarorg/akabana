package examples.flex2.camera.snapshot.dto;

import org.seasar.flex2.core.format.amf3.type.ByteArray;

public class SnapshotDto {
    private ByteArray source;

    public ByteArray getSource() {
        return source;
    }

    public void setSource(ByteArray source) {
        this.source = source;
    }
}
