package paie.pointage;

import bean.CGenUtil;

public class PointageHeureSup extends Pointage {

    private double total_heure_sup;

    public PointageHeureSup() throws Exception {
        super.setNomTable("v_pointage_total_heure_sup");
    }

    public static PointageHeureSup getByIdPersonnel(String idPersonnel) throws Exception {
        /* 
          PointageHeureSup tmp = new PointageHeureSup();
        tmp.setIdPersonnel(idPersonnel);
        PointageHeureSup pointageHeureSup = (PointageHeureSup) CGenUtil.rechercher(tmp, null, null, " ")[0];
        */
      
        return null;
    }

    public double getTotal_heure_sup() {
        return total_heure_sup;
    }

    public void setTotal_heure_sup(double total_heure_sup) {
        this.total_heure_sup = total_heure_sup;
    }
}
