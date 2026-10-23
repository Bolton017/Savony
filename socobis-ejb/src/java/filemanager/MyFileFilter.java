/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package filemanager;

import java.io.File;
import java.io.FileFilter;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 *
 * @author Estcepoire
 */
public class MyFileFilter implements FileFilter{
    private String name = "";
    private String sort = "0";
    
    public MyFileFilter(){}
    @Override
    public boolean accept(File file) {
        return file.getName().toLowerCase().matches(".*"+getName().toLowerCase()+".*");
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        if(name != null && !name.trim().isEmpty())
            this.name = name.trim();
    }
    
    public List<File> applyTo(File parent){
        List<File> result = Arrays.asList(parent.listFiles(this));
        MyFileComparator cmp = new MyFileComparator();
        if(sort.equals("1")) Collections.sort(result, Collections.reverseOrder(cmp));
        else Collections.sort(result, cmp);
        
        return result;
    }

    public String getSort() {
        return sort;
    }

    public void setSort(String sort) {
        if(sort != null && !sort.trim().isEmpty())
            this.sort = sort.trim();
    }
    
    
    public static String getPreviousPath(String path){
        if(path == null || path.isEmpty()) return null;
        String[] parts = path.split("/");
        String[] nvparts = new String[parts.length - 1];
        System.arraycopy(parts, 0, nvparts, 0, parts.length - 1);
        return String.join("/", nvparts);
    }
}
