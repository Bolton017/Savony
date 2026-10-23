package fabrication;

import bean.CGenUtil;
import bean.ClassMAPTable;
import charge.Charge;
import produits.Recette;

import java.sql.Connection;

public class ProcessFab extends bean.Process {
    public Recette[] getListeRecette(String nt, Connection c) throws Exception {
        try {
            if(nt==null || nt.equals("")) nt = "AS_RECETTEFABLIBSERVICE";
            Recette ctr = new Recette();
            ctr.setNomTable(nt);
            ctr.setIdproduits(this.getRefObjet());
            Recette[] recettes = (Recette[]) CGenUtil.rechercher(ctr,null,null,c, "");
            return recettes;
        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    public Charge[] genererCharge(Connection c) throws Exception {
        try{
            Recette[] recettes = this.getListeRecette("AS_RECETTEFABLIBSERVICE", c);
            Charge[] charges = new Charge[recettes.length];
            for(int i=0;i<recettes.length;i++){
                charges[i] = recettes[i].genererCharge(this.getEcart());
            }
            return  charges;
        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        ClassMAPTable process = super.createObject(u, c);
        if (this.getObjet().equals("maintenance.travaux.Travaux")==false){
            if (this.getAction().equalsIgnoreCase("bloquer") || this.getAction().equalsIgnoreCase("terminer")) {
                Charge[] charges = genererCharge(c);
                for (int i = 0; i < charges.length; i++) {
                    charges[i].createObject(u, c);
                }
            }
        }
        return process;
    }
}
