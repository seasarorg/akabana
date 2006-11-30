package examples.flex2.performance.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.seasar.flex2.rpc.remoting.service.annotation.RemotingService;

import examples.flex2.performance.service.PerformanceTestService;

/**
 * 
 * @ RemotingService
 */
@RemotingService
public class PerformanceTestServiceImpl implements PerformanceTestService {

    public ArrayList getArray(int size) {
        ArrayList list = new ArrayList();
        Map data;
        long start = System.currentTimeMillis();
        for (int i = 0; i < size; i++) {
            data = new HashMap();
            data.put("col1", "This is row " + i);
            data.put("col2", "10000000");
            data.put("col3", "More text to add to this row.");
            list.add(data);
        }
        System.out.println("size:" + size + ", total:"
                + (System.currentTimeMillis() - start));
        return list;
    }
}
