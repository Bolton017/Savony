/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package filemanager;

import java.io.File;
import java.util.Comparator;

/**
 *
 * @author Estcepoire
 */
public class MyFileComparator implements Comparator<File>{

    @Override
    public int compare(File o1, File o2) {
        return o1.getName().compareToIgnoreCase(o2.getName());
    }

    

    
    
}
