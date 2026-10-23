package fabrication;

import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.ClassEtat;
import java.sql.Connection;
import java.sql.Date;
import utilitaire.UtilDB;
import java.time.LocalDateTime;
import utilitaire.Utilitaire;

public class RessourceParFabrication extends ClassEtat{
    String id, idFabrication, idPoste, idRessource, idOF, matricule, estTemporaire, idQualification, idCategorie, idPosteEffective, idQualificationEffective, idRessourceLib;
    double smig, tauxHoraire, HS, MN, JF, HD, IF;
    String remarque;

    public String getIdQualification() {
        return idQualification;
    }

    public void setIdQualification(String idQualification) {
        this.idQualification = idQualification;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdFabrication() {
        return idFabrication;
    }

    public void setIdFabrication(String idFabrication) {
        this.idFabrication = idFabrication;
    }

    public String getIdPoste() {
        return idPoste;
    }

    public void setIdPoste(String idPoste) {
        this.idPoste = idPoste;
    }

    public String getIdRessource() {
        return idRessource;
    }

    public void setIdRessource(String idRessource) {
        this.idRessource = idRessource;
    }

    public String getIdOF() {
        return idOF;
    }

    public void setIdOF(String idOF) {
        this.idOF = idOF;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getEstTemporaire() {
        return estTemporaire;
    }

    public void setEstTemporaire(String estTemporaire) {
        this.estTemporaire = estTemporaire;
    }

    public String getIdCategorie() {
        return idCategorie;
    }

    public void setIdCategorie(String idCategorie) {
        this.idCategorie = idCategorie;
    }

    public String getIdPosteEffective() {
        return idPosteEffective;
    }

    public void setIdPosteEffective(String idPosteEffective) {
        this.idPosteEffective = idPosteEffective;
    }

    public String getIdQualificationEffective() {
        return idQualificationEffective;
    }

    public void setIdQualificationEffective(String idQualificationEffective) {
        this.idQualificationEffective = idQualificationEffective;
    }

    public double getSmig() {
        return smig;
    }

    public void setSmig(double smig) {
        this.smig = smig;
    }

    public double getTauxHoraire() {
        return tauxHoraire;
    }

    public void setTauxHoraire(double tauxHoraire) {
        this.tauxHoraire = tauxHoraire;
    }

    public double getHS() {
        return HS;
    }

    public void setHS(double HS) {
        this.HS = HS;
    }

    public double getMN() {
        return MN;
    }

    public void setMN(double MN) {
        this.MN = MN;
    }

    public double getJF() {
        return JF;
    }

    public void setJF(double JF) {
        this.JF = JF;
    }

    public double getHD() {
        return HD;
    }

    public void setHD(double HD) {
        this.HD = HD;
    }

    public double getIF() {
        return IF;
    }

    public void setIF(double IF) {
        this.IF = IF;
    }

    public String getIdRessourceLib() {
        return idRessourceLib;
    }

    public void setIdRessourceLib(String idRessourceLib) {
        this.idRessourceLib = idRessourceLib;
    }

    public RessourceParFabrication() {
        this.setNomTable("ressourceParFabrication");
    }

    public String getAttributIDName() {
        return "id";
    }

    public String getTuppleID() {
        return id;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("RPFAB", "getseqressourceParFabrication");
        this.setId(makePK(c));
    }

    public HeureSupFabricationCPL getHeureSupFabrication(Connection c) throws Exception{
        String id = this.getId();
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            HeureSupFabricationCPL crt=new HeureSupFabricationCPL();
            crt.setNomTable("HEURESUPFABRICATION_CPL");
            crt.setIdRessParFab(id);
            HeureSupFabricationCPL[] rep = (HeureSupFabricationCPL[])CGenUtil.rechercher(crt,null,null,c,"");
            return rep[0];
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
}
