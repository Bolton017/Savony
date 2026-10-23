package machine;

import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.ClassMere;
import vente.NumeroFacture;
import vente.VenteDetails;

import java.sql.Connection;
import java.sql.Date;
import java.util.HashSet;
import java.util.Set;

public class InspectionMere extends ClassMere {
    private String id;
    private Date daty;
    private String heure;
    private String idinspecteur;
    private String idelement;
    private String remarque;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getHeure() {
        return heure;
    }

    public void setHeure(String heure) {
        this.heure = heure;
    }

    public String getIdinspecteur() {
        return idinspecteur;
    }

    public void setIdinspecteur(String idinspecteur) {
        this.idinspecteur = idinspecteur;
    }

    public String getIdelement() {
        return idelement;
    }

    public void setIdelement(String idelement) {
        this.idelement = idelement;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }



    public InspectionMere() throws Exception {
        this.setNomTable("INSPECTIONMERE");
        this.setNomClasseFille("machine.InspectionFille");
        this.setLiaisonFille("idmere");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("ISPM","getSeqInspectionMere");
        this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        InspectionMere obj = new InspectionMere();

        return new InspectionMere();
    }
}

