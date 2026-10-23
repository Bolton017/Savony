package paie.conge;

import bean.CGenUtil;
import bean.ClassMAPTable;

public class CongeDroitCPL extends ClassMAPTable {

    private String id;
    private String idpersonnel;
    private int mois;
    private int annee;
    private double conge;
    private int etat;
    private String idpersonnellib;

    public CongeDroitCPL() {
        this.setNomTable("CONGE_DROIT_LIBCOMPLET");
    }

    public static CongeDroitCPL getCongeDroitPersonnel(String idpersonnel) {
        try {
            CongeDroitCPL tmp = new CongeDroitCPL();
            tmp.setIdpersonnel(idpersonnel);
            CongeDroitCPL congeDroitCPL = (CongeDroitCPL) CGenUtil.rechercher(tmp, null, null, "")[0];
            return congeDroitCPL;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdpersonnel() {
        return idpersonnel;
    }

    public void setIdpersonnel(String idpersonnel) {
        this.idpersonnel = idpersonnel;
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public double getConge() {
        return conge;
    }

    public void setConge(double conge) {
        this.conge = conge;
    }

    public int getEtat() {
        return etat;
    }

    public void setEtat(int etat) {
        this.etat = etat;
    }

    public String getIdpersonnellib() {
        return idpersonnellib;
    }

    public void setIdpersonnellib(String idpersonnellib) {
        this.idpersonnellib = idpersonnellib;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
}
