package maintenance.ressources;

import java.sql.Date;
import bean.ClassMAPTable;
import java.sql.Connection;
public class Autocarburant extends ClassMAPTable{

    private String id, idAuto;
    private Date daty;
    private double montant, odometre;
    private int volume;

    public Autocarburant() {
        this.setNomTable("autocarburant");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdAuto() {
        return idAuto;
    }

    public void setIdAuto(String idAuto) throws Exception {
        
        this.idAuto = idAuto;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) throws Exception {
            if(montant <= 0){
                throw new Exception("champ odometre est obligatoire");                
            }
        
        this.montant = montant;
    }

    public double getOdometre() {
        return odometre;
    }

    public void setOdometre(double odometre) throws Exception {
            if( odometre <= 0 ){
                throw new Exception("champ odometre est obligatoire");                
            }
        
        this.odometre = odometre;
    }

    public int getVolume() {
        return volume;
    }

    public void setVolume(int volume) throws Exception {
        if(odometre<= 0){
            throw new Exception("champ volume est obligatoire");                
        }
        
        this.volume = volume;
    }

    
    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    public void construirePK(Connection c) throws Exception {
        this.preparePk("AUC", "GETSEQAUTOCARBURANT");
        this.setId(makePK(c));
    }
}
