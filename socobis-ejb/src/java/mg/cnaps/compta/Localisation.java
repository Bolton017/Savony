package mg.cnaps.compta;

import bean.CGenUtil;
import bean.ClassMAPTable;
import magasin.Magasin;
import utilitaire.Utilitaire;

import java.sql.Connection;

public class Localisation extends ComptaCompte {
    String departement;

    public Localisation() {
        super.setNomTable("localisation");
    }

    public String getDepartement() {
        return departement;
    }

    public void setDepartement(String departement) throws Exception{
        this.departement = departement;
    }

    @Override
    public void setClassy(String classy) throws Exception{
        super.setmagasin(classy);
    }

    @Override
    public void setCompte(String compte) throws Exception {
        super.setEmplacement(compte);
    }

    @Override
    public void setTypeCompte(String typeCompte) throws Exception {

    }

    /**
     * construction PK avec sequence localisation
     */
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("LOC", "get_SEQ_localisation");
        this.setId(makePK(c));
    }

    /**
     * mots clés pour recherche
     */
    @Override
    public String[] getMotCles() {
        String[] motCles = { "id","compte", "libelle" };
        return motCles;
    }

    /**
     * valeurs mots clés pour recherche
     */
    @Override
    public String[] getValMotCles() {
        String[] valMotCles = { "id","compte", "libelle" };
        return valMotCles;
    }

    @Override
    public void controler(Connection c) throws Exception {
        super.supercontroler(c);
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        Magasin mag = new Magasin();
        System.out.println("magasin " + this.getClassy());
        mag = (Magasin) mag.getById(this.getClassy(),"magasin",c);
        if(mag!= null && mag.getIdDepartement() != null){
            this.setDepartement(mag.getIdDepartement());
        }
        return super.supercreateObject(u,c);
    }

    @Override
    public int updateToTableWithHisto(String refUser, Connection c) throws Exception {
        return super.superupdateToTableWithHisto(refUser, c);
    }

    @Override
    public void controlerUpdate(Connection c) throws Exception {
        super.supercontrolerUpdate(c);
    }
}