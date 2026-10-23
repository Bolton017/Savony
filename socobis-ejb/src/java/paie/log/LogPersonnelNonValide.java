package paie.log;

import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;
import paie.employe.PaieInfoPersonnel;
import paie.employe.PaieInfoPersonnelEnfant;
import utilitaire.ConstanteEtat;
import paie.avancement.PaieAvancement;
import utilitaire.ConstanteEtatPaie;

import java.sql.Connection;
import java.sql.Date;
import paie.elementpaie.PaiePersonnelElementpaie;
import paie.employe.PaieInfoPersonnel;
import utils.ConstantePaie;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Finaritra
 */
public class LogPersonnelNonValide extends ClassEtat {

    private String id, idlogpers,idpassation;
    private Date dateapplication, date_decision,date_reintegration;
    private String idtypedebauche, refdecision, idavancement, motif;
    private String matricule;
    private double dureePreavis;
    private int stc;

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        this.savePersonnelNonValide(c, u);
        this.setDate_reintegration(null);
        
        if(this.stc==1){
            
        }
        return super.createObject(u, c);
    }

    public LogPersonnelNonValide() {
        this.setNomTable("LOG_PERSONNEL_NON_VALIDE");
    }

    public LogPersonnelNonValide(String idlogpers, Date dateapplication, String idtypedebauche) {
        try {
            this.setNomTable("LOG_PERSONNEL_NON_VALIDE");
            this.setIdlogpers(idlogpers);
            this.setDateapplication(dateapplication);
            this.setIdtypedebauche(idtypedebauche);
        } catch (Exception ex) {

        }
    }

    public LogPersonnelNonValide(String idlogpers, Date dateapplication, String idtypedebauche,String idpassation) {
        try {
            this.setNomTable("LOG_PERSONNEL_NON_VALIDE");
            this.setIdlogpers(idlogpers);
            this.setDateapplication(dateapplication);
            this.setIdtypedebauche(idtypedebauche);
            this.setIdpassation(idpassation);
        } catch (Exception ex) {

        }
    }

    public LogPersonnelNonValide(String id, String idlogpers, Date dateapplication, String idtypedebauche) {
        try {
            this.setNomTable("LOG_PERSONNEL_NON_VALIDE");
            this.setId(id);
            this.setIdlogpers(idlogpers);
            this.setDateapplication(dateapplication);
            this.setIdtypedebauche(idtypedebauche);
        } catch (Exception ex) {

        }
    }

    public LogPersonnelNonValide(String id, String idlogpers, Date dateapplication, String idtypedebauche,String idpassation) {
        try {
            this.setNomTable("LOG_PERSONNEL_NON_VALIDE");
            this.setId(id);
            this.setIdlogpers(idlogpers);
            this.setDateapplication(dateapplication);
            this.setIdtypedebauche(idtypedebauche);
            this.setIdpassation(idpassation);
        } catch (Exception ex) {

        }
    }

    public static LogPersonnelNonValide getLogPersNonValideById(String id) throws Exception {
        Connection connection = null;
        boolean isOpen = true;

        try {
            LogPersonnelNonValide tmp = new LogPersonnelNonValide();
            LogPersonnelNonValide logPersonnelNonValide = (LogPersonnelNonValide) tmp.getById(id, tmp.getNomTable(), connection);

            if (logPersonnelNonValide != null) {
                return logPersonnelNonValide;
            } else {
                throw new Exception("Personnel Invalide introuvable avec l'ID: " + id);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (connection != null && isOpen) {
                connection.close();
            }
        }
    }

    public LogPersonnelNonValide savePersonnelNonValide(Connection c, String tuppleId) throws Exception {
        try {
            if (this != null) {
//                this.construirePK(c);
                this.setIdtypedebauche(this.getIdtypedebauche());
                this.setEtat(ConstanteEtat.getEtatCreer());
                String avancement = handleSavePaieAvancement(c, tuppleId);
                this.setIdavancement(avancement);
//                this.insertToTableWithHisto(tuppleId, c);
            } else {
                throw new Exception("Avancement introuvable");
            }
            return this;
        } catch (Exception ex) {
            throw ex;
        }
    }

    private String handleSavePaieAvancement(Connection c, String tuppleId) throws Exception {
        String avancementid = null;
        if (this != null) {
            PaieInfoPersonnelEnfant[] infoPersonnel = (PaieInfoPersonnelEnfant[]) CGenUtil.rechercher(new PaieInfoPersonnelEnfant(), null, null, c, " AND ID = '" + this.getIdlogpers() + "'");
            LogPersonnel[] logp = (LogPersonnel[]) CGenUtil.rechercher(new LogPersonnel(), null, null, c, " AND ID = '" + this.getIdlogpers() + "'");
            if (infoPersonnel != null && infoPersonnel.length > 0 && logp != null && logp.length > 0) {
                PaieAvancement avancement = new PaieAvancement();
                avancement.construirePK(c);
                avancement.setId_logpers(this.getIdlogpers());
                avancement.setDate_application(this.getDateapplication());
                avancement.setDatedecision(this.getDate_decision());
                avancement.setMotif(this.getIdtypedebauche());
                avancement.setRefdecision(this.getRefdecision());
                avancement.setDirection(logp[0].getDirection());
                avancement.setService(logp[0].getService());
                avancement.setIdfonction(infoPersonnel[0].getIdfonction());
                avancement.setIdcategorie(infoPersonnel[0].getIdcategorie());
                avancement.setEchelon(infoPersonnel[0].getEchelon());
                avancement.setClassee(infoPersonnel[0].getClassee());
                //if (infoPersonnel[0].getIndicegrade() != null) {
                avancement.setIndicegrade(infoPersonnel[0].getIndicegrade());
                /*}
                if (infoPersonnel[0].getIndice_fonctionnel() != null) {*/
                avancement.setIndice_fonctionnel(infoPersonnel[0].getIndice_fonctionnel());
                //}
                avancement.setMatricule_patron(infoPersonnel[0].getMatricule_patron());
                avancement.setStatut(infoPersonnel[0].getStatut());
                avancement.setVehiculee(infoPersonnel[0].getVehiculee());
                avancement.setDroit_hs(infoPersonnel[0].getDroit_hs());
                avancement.setCtg(infoPersonnel[0].getCtg());
                //if (infoPersonnel[0].getIndice_ct() != null) {
                avancement.setIndice_ct(infoPersonnel[0].getIndice_ct());
                //}
                avancement.setEtat(ConstanteEtat.getEtatCreer());
                avancement.setIduser(tuppleId);
                avancement.insertToTableWithHisto(tuppleId, c);
                avancementid = avancement.getId();
            }
        }
        return avancementid;
    }


    public LogPersonnelNonValide find( LogPersonnelNonValide obj ) throws Exception{
        LogPersonnelNonValide[] ls = null ;
            ls =(LogPersonnelNonValide[]) CGenUtil.rechercher(obj, null, null, null, "  " );
            if( ls.length == 0 ){
                return null;
            }
        return ls[0] ;
    }

    public double getDureePreavis() {
        return dureePreavis;
    }

    public void setDureePreavis(double dureePreavis) {
        this.dureePreavis = dureePreavis;
    }

    @Override
    public void construirePK(Connection c) throws Exception {

        this.preparePk("LPN", "GETSEQLOGPERSONNELNONVALIDE");
        this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() {
        return getId();
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getMotif() {
        return motif;
    }

    public void setMotif(String motif) {
        this.motif = motif;
    }

    public int getStc() {
        return stc;
    }

    public void setStc(int stc) {
        this.stc = stc;
    }

    /**
     * @return the id
     */
    public String getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(String id) {
        this.id = id;
    }

    /**
     * @return the idlogpers
     */
    public String getIdlogpers() {
        return idlogpers;
    }

    /**
     * @param idlogpers the idlogpers to set
     */
    public void setIdlogpers(String idlogpers) throws Exception {
        if ((getMode().compareToIgnoreCase("modif") == 0) && idlogpers.isEmpty()) {
            throw new Exception("Champ personnel obligatoire");
        }
        this.idlogpers = idlogpers;
    }

    /**
     * @return the dateapplication
     */
    public Date getDateapplication() {
        return dateapplication;
    }

    /**
     * @param dateapplication the dateapplication to set
     */
    public void setDateapplication(Date dateapplication) throws Exception {
        if ((getMode().compareToIgnoreCase("modif") == 0) && dateapplication == null) {
            throw new Exception("Champ date application obligatoire");
        }
        this.dateapplication = dateapplication;
    }

    /**
     * @return the idtypedebauche
     */
    public String getIdtypedebauche() {
        return idtypedebauche;
    }

    /**
     * @param idtypedebauche the idtypedebauche to set
     */
    public void setIdtypedebauche(String idtypedebauche) throws Exception {
        if ((getMode().compareToIgnoreCase("modif") == 0) && idtypedebauche.isEmpty()) {
            throw new Exception("Champ motif obligatoire");
        }
        this.idtypedebauche = idtypedebauche;
    }

    public Date getDate_decision() {
        return date_decision;
    }

    public void setDate_decision(Date date_decision) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.date_decision = date_decision;
            return;
        }
        if (getDateapplication().before(date_decision)) {
            throw new Exception("La date de l'application est antérieure à la date de décision.");
        }
        this.date_decision = date_decision;
    }

    public String getRefdecision() {
        return refdecision;
    }

    public void setRefdecision(String refdecision) {
        this.refdecision = refdecision;
    }

    public String getIdavancement() {
        return idavancement;
    }

    public void setIdavancement(String idavancement) {
        this.idavancement = idavancement;
    }

    public Date getDate_reintegration() {
        return date_reintegration;
    }

    public void setDate_reintegration(Date date_reintegration) {
        this.date_reintegration = date_reintegration;
    }

    public String getIdpassation() {
        return idpassation;
    }

    public void setIdpassation(String idpassation) {
        this.idpassation = idpassation;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={ "IDLOGPERS","MATRICULE" };
        return motCles;
    }
    

    @Override
    public Object validerObject(String user, Connection connection) throws Exception {
        PaieInfoPersonnel paie = new PaieInfoPersonnel();
        paie.setNomTable("PAIE_INFO_PERSONNEL");
        paie.setId(this.getIdlogpers());
        PaieInfoPersonnel[] resPaie = (PaieInfoPersonnel[]) CGenUtil.rechercher(paie, null, null, "");

        if(resPaie != null && resPaie.length > 0){
            resPaie[0].setEtat(ConstanteEtatPaie.getEtatDesactiver());
            resPaie[0].setDate_depart(this.getDateapplication());
            resPaie[0].updateToTable(connection);
        } else {
            throw new Exception("Personnel non trouvé ");
        }
        return super.validerObject(user, connection);
        // Initialisation de l’élément de paie
//        PaiePersonnelElementpaie elp = new PaiePersonnelElementpaie();
//        elp.setDate_debut(this.getDateapplication());
//        elp.setEtat(11);
//        elp.setIdpersonnel(this.getIdlogpers());
//        System.out.println("IDPERS => " + this.getIdlogpers());
//
//        // Récupération du montant de base du salarié
//        PaieInfoPersonnel info = new PaieInfoPersonnel();
//        info.setNomTable("paie_info_personnel_sb");
//        PaieInfoPersonnel[] clients = (PaieInfoPersonnel[]) CGenUtil.rechercher(info,null,null,connection," AND id = '" + this.getIdlogpers() + "'");
//        double salaire = clients[0].getMontant();
//        System.out.println("salaire==>"+salaire);
//        // Calcul selon le type de débauche
//        if (ConstantePaie.idlicenciement.equals(this.getIdtypedebauche())) {
//            System.out.println("Licenciement");
//            elp.setCode_rubrique(ConstantePaie.inndemlicenciement);
//            elp.setGain(salaire / 30 * this.getDureePreavis());
//            elp.insertToTableWithHisto(user, connection);
//
//        } else if (ConstantePaie.iddemission.equals(this.getIdtypedebauche())) {
//            System.out.println("Démission – préavis non effectué");
//            elp.setCode_rubrique(ConstantePaie.idpreavis);
//            elp.setRetenue(salaire / 30 * this.getDureePreavis());
//            elp.insertToTableWithHisto(user, connection);
//            System.out.println("Insertion préavis terminée");
//        }
//
//        // Appel au traitement parent
//        super.validerObject(user, connection);
//        return this;
    }

    
}