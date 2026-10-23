package paie.conge;

import bean.CGenUtil;
import bean.ClassMAPTable;
import utilitaire.*;
import utils.ConstantePaie;
import java.sql.Connection;
import java.sql.Date;
import paie.log.LogPersonnelNonValide;

public class MouvementAbsence extends ClassMAPTable {

    private String id;
    private String idSource;
    private String idPersonnel;
    private Date dateDebut;
    private int mois;
    private int annee;
    private double plus;
    private double moins;
    private String motif;
    private String remarque;
    private String idRemplacant;
    private Date dateDemande;
    private double solde, permissionPris;
    private double salaire_base;

    public double getSalaire_base() {
        return salaire_base;
    }

    public void setSalaire_base(double salaire_base) {
        this.salaire_base = salaire_base;
    }

    public MouvementAbsence() {
        this.setNomTable("MOUVEMENTABSENCE");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("MTAS", "GET_SEQ_MVTABSENCE");
        this.setId(makePK(c));
    }

//    public double getSoldeCongePers() {
//
//    }

    public double getSoldeCongePers() throws Exception {
        this.setNomTable("SOLDECONGE_PERS");
        this.setIdSource(ConstantePaie.id_typeabsenceconge);
        System.out.println("ID" + this.getIdPersonnel());
        MouvementAbsence[] mvt = (MouvementAbsence[]) CGenUtil.rechercher(this, null, null, " AND IDPERSONNEL = '" +  this.getIdPersonnel() + "' ");
        if(mvt.length>0){
            return mvt[0].getSolde();
        }
        if(mvt == null || mvt.length < 1) {
            throw new Exception("Pas encore de solde pour ce personnel, veuillez verifier son ancienet\\u00E9");
        }
        return 0;
    }
    
    public double getSoldeCongePers(Date daty) throws Exception {
        this.setNomTable("SOLDECONGE_PERS");
        this.setIdSource(ConstantePaie.id_typeabsenceconge);
        MouvementAbsence[] mvt = (MouvementAbsence[]) CGenUtil.rechercher(this, null, null, "" );
//        System.out.println("=========> solde " + mvt[0].getSolde() + " pers = " + mvt[0].getIdPersonnel() + " length = " + mvt.length);
        if(mvt == null || mvt.length < 0) {
            throw new Exception("Pas encore de solde pour ce personnel, veuillez verifier son ancienet&eacute;");
        }
        double solde = mvt[0].getSolde();
        solde += Utilitaire.calculerProrataCongeUp(daty);
        return solde;
    }
    
    public void SoldeCongeStc(String idpersonnel,String refUser,Connection c) throws Exception {
        this.setIdPersonnel(idpersonnel);
        double solde = this.getSoldeCongePers();
        LogPersonnelNonValide lnv = new LogPersonnelNonValide();
        lnv.setIdlogpers(this.getIdPersonnel());
        LogPersonnelNonValide[] mvt = (LogPersonnelNonValide[]) CGenUtil.rechercher(lnv, null, null, "" );
        if(mvt == null || mvt.length< 0) throw new Exception("Personnel pas encore debaucher");
        
        System.out.println("idpers=====================>"+idpersonnel);
        
        this.setNomTable("MOUVEMENTABSENCE");
        this.setMoins(solde);
        this.setDateDebut(mvt[0].getDateapplication());
        this.setIdRemplacant(mvt[0].getIdpassation());
        this.setIdSource(mvt[0].getId());
        this.setDateDemande(mvt[0].getDate_decision());
        this.setMois(utilitaire.Utilitaire.getMois(mvt[0].getDateapplication()));
        this.setAnnee(utilitaire.Utilitaire.getAnnee(mvt[0].getDateapplication()));
        this.createObject(refUser,c);
    }    

    public double getSoldePermissionPers() throws Exception {
        double soldePermission = 0;
        this.setNomTable("SOLDEPERMISSION_PERS");
        this.setIdSource(ConstantePaie.id_typeabsencepermission);
        MouvementAbsence[] mvt = (MouvementAbsence[]) CGenUtil.rechercher(this, null, null,"");
        if(mvt == null || mvt.length< 0) {
            throw new Exception("Pas encore de solde pour ce personnel, veuillez verifier son ancienet&eacute;");
        }
        soldePermission = ConstantePaie.permissionParAnnee - mvt[0].getPermissionPris();
        return soldePermission;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdPersonnel() {
        return idPersonnel;
    }

    public void setIdPersonnel(String idPersonnel) {
        this.idPersonnel = idPersonnel;
    }

    public Date getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(Date dateDebut) {
        this.dateDebut = dateDebut;
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

    public double getPlus() {
        return plus;
    }

    public void setPlus(double plus) {
        this.plus = plus;
    }

    public double getMoins() {
        return moins;
    }

    public void setMoins(double moins) {
        this.moins = moins;
    }

    public String getMotif() {
        return motif;
    }

    public void setMotif(String motif) {
        this.motif = motif;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getIdRemplacant() {
        return idRemplacant;
    }

    public void setIdRemplacant(String idRemplacant) {
        this.idRemplacant = idRemplacant;
    }

    public Date getDateDemande() {
        return dateDemande;
    }

    public void setDateDemande(Date dateDemande) {
        this.dateDemande = dateDemande;
    }

    public String getIdSource() {
        return idSource;
    }

    public void setIdSource(String idSource) {
        this.idSource = idSource;
    }

    public double getSolde() {
        return solde;
    }

    public void setSolde(double solde) {
        this.solde = solde;
    }

    public double getPermissionPris() {
        return permissionPris;
    }

    public void setPermissionPris(double permissionPris) {
        this.permissionPris = permissionPris;
    }
}
