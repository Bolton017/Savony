package charge;

import java.sql.Connection;
import java.sql.Date;
import bean.ClassEtat;
import historique.MapUtilisateur;
import utils.ConstanteSocobis;
import bean.ClassMAPTable;

public class Charge extends  ClassEtat{
    
    
    private String id; 
    private Date daty;
    private String libelle,type,idfabrication,typelib,etatlib,idingredients;
    private double pu,qte; 

    public Charge() {
        this.setNomTable("charge");
    }
 
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CHG", "GETSEQ_CHARGE");
        this.setId(makePK(c));
    }

    public String getIdingredients() {
        return idingredients;
    }

    public void setIdingredients(String idingredients) {
        this.idingredients = idingredients;
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }


    
    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }


    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) {
        this.pu = pu;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) {
        this.qte = qte;
    }
    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getIdfabrication() {
        return idfabrication;
    }

    public void setIdfabrication(String idfabrication) {
        this.idfabrication = idfabrication;
    }

    public String getTypelib() {
        return typelib;
    }

    public void setTypelib(String typelib) {
        this.typelib = typelib;
    }

    @Override
    public ClassMAPTable createObject(MapUtilisateur u, Connection c)throws Exception{
        if((u.getIdrole().compareTo(ConstanteSocobis.CHEFFABR_RANG) != 0)&&(u.getIdrole().compareTo(ConstanteSocobis.CONTREMAITRE_RANG) != 0)){
            throw new Exception("Vous n’avez pas le droit de creer une charge");
        }
        return super.createObject(u,c);
    }

    @Override
    public Object validerObject(MapUtilisateur u, Connection c) throws Exception {
        if((u.getIdrole().compareTo(ConstanteSocobis.CHEFFABR_RANG) != 0)&&(u.getIdrole().compareTo(ConstanteSocobis.CONTREMAITRE_RANG) != 0)){
            throw new Exception("Vous n’avez pas le droit de valider une charge");
        }
        return super.validerObject(u, c);
    }

    public double getMontant() {
        return pu * qte;
    }

}