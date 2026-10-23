package remise;

import bean.ClassFille;
import java.sql.Connection;
import java.sql.Date;

public class RemiseFille extends ClassFille {
    private String id;
    private double remise;
    private String idcategorieclient;
    private String idproduit;
    private String categorieproduit;
    private String idpoint;
    private String idremise;
    Date daty,dateDebut,dateFin;
    String nom;

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public Date getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(Date dateDebut) {
        this.dateDebut = dateDebut;
    }

    public Date getDateFin() {
        return dateFin;
    }

    public void setDateFin(Date dateFin) {
        this.dateFin = dateFin;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public double getRemise()  {
        return remise;
    }

    public void setRemise(double remise) throws  Exception{
        if(this.getMode().equals("modif")){
            if(remise<=0){
                throw new Exception("Remise doit etre positive");
            }
        }
        this.remise = remise;
    }

    public String getIdcategorieclient() {
        return idcategorieclient;
    }

    public void setIdcategorieclient(String idcategorieclient) {
        this.idcategorieclient = idcategorieclient;
    }

    public String getIdproduit() {
        return idproduit;
    }

    public void setIdproduit(String idproduit) {
        this.idproduit = idproduit;
    }

    public String getCategorieproduit() {
        return categorieproduit;
    }

    public void setCategorieproduit(String categorieproduit) {
        this.categorieproduit = categorieproduit;
    }

    public String getIdpoint() {
        return idpoint;
    }

    public void setIdpoint(String idpoint) {
        this.idpoint = idpoint;
    }

    public String getIdremise() {
        return idremise;
    }

    public void setIdremise(String idremise) {
        this.idremise = idremise;
    }


    @Override
    public String getNomClasseMere() {
        return "remise.Remise";
    }

    @Override
    public String getLiaisonMere() {
        return "idremise";
    }

    public RemiseFille() throws Exception {
        this.setNomTable("REMISEFILLE");
        this.setNomClasseMere("remise.Remise");
        this.setLiaisonMere("idremise");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("RMSF","GETSEQ_REMISEFILLE");
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
}

