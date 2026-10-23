/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.employe;

import bean.CGenUtil;

/**
 *
 * @author Sam25v14
 */
public class PaieInfoPersonnelLib extends PaieInfoPersonnel {
    private String typecontrat;

    public PaieInfoPersonnelLib() {
        this.setNomTable("paie_info_personnel_lib3");
    }

    public String getTypecontrat() {
        return typecontrat;
    }

    public void setTypecontrat(String typecontrat) {
        this.typecontrat = typecontrat;
    }
 
    public PaieInfoPersonnelLib  find( PaieInfoPersonnelLib obj ) throws Exception{
        PaieInfoPersonnelLib[] ls = null ;
        ls =(PaieInfoPersonnelLib[]) CGenUtil.rechercher(obj, null, null, null, "  " );
        if(ls.length==0){
            return null;
        }
        return ls[0] ;
    }
}
