/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.edition;

/**
 *
 * @author Sanda
 */
import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassEtat;
//import fournisseur.Retenue;
import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import bean.ClassMere;
import mg.cnaps.compta.ComptaEcriture;
import mg.cnaps.compta.ComptaSousEcriture;
import configuration.Configuration;
import paie.conge.MouvementAbsence;
import paie.ecriture.EcritureDeLaPaieRegr;
import paie.log.LogPersonnel;
import utilitaire.Constante;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

public class PaieEditionmoisannee extends ClassMere {

    private String id, idpersonnel, iduser, iddirection;
    private int mois, annee;
    private double montant, gain, retenue;
    private Date daty, dateOuverture, dateFermeture;
    private String idperiodepaie;
    

    public String getIdperiodepaie() {
        return idperiodepaie;
    }

    public void setIdperiodepaie(String idperiodepaie) {
        this.idperiodepaie = idperiodepaie;
    }

    @Override
    public String getTuppleID() {
        return this.getId();
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public PaieEditionmoisannee() throws Exception {
        super.setNomTable("paie_editionmoisannee");
        super.setNomClasseFille("paie.edition.TraitementPaie");
        super.setLiaisonFille("idEdition");
    }

    public int getNbSemaine() {
        LocalDate startDate = this.getDateOuverture().toLocalDate();
        LocalDate endDate = this.getDateFermeture().toLocalDate();

        long joursEntreDeuxDates = ChronoUnit.DAYS.between(startDate, endDate) + 1;
        int nbSemaine = (int) (joursEntreDeuxDates / 7);

        return nbSemaine;
    }

    @Override
    public String getLiaisonFille() {
        return "idEdition";
    }

    public String getNomClasseFille() {
        return "paie.edition.TraitementPaie";
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        Paie_edition paie = new Paie_edition();
        paie.setIdedition(this.getId());
        Paie_edition[] listEdition = (Paie_edition[]) CGenUtil.rechercher(paie, null, null, c, "");
        for(int i=0; i<listEdition.length; i++) {
            listEdition[i].validerObject(u, c);
        }
        this.genererSoldeConge(u, c);
        return super.validerObject(u, c);
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PEM", "getseqpaieeditionmoisannee");
        this.setId(makePK(c));
    }

    public void genererSoldeConge(String u, Connection c) throws Exception {
        try {
            if(c == null) {
                c = new UtilDB().GetConn();
            }
            LogPersonnel log = new LogPersonnel();
            String[] personnelConcerne = log.getPersonnelsByDirection(this.getIddirection(), c);
            double soldeConge = 2.5;
            MouvementAbsence tmp = new MouvementAbsence();
            tmp.setNomTable("mvtcongebymoisannee");
            String aWhere = "AND MOIS=" + this.getMois() + " AND ANNEE=" +this.getAnnee();
            tmp.setMois(this.getMois());
            tmp.setAnnee(this.getAnnee());
            MouvementAbsence[] mvt = (MouvementAbsence[]) CGenUtil.rechercher(tmp, null, null, c, "");

            Set<String> idsDejaDansMvt = new HashSet<>();
            if(mvt != null && mvt.length > 0) {
                for (MouvementAbsence m : mvt) {
                    idsDejaDansMvt.add(m.getIdPersonnel());
                }
            }

            for (String idPersonnel : personnelConcerne) {
                if (!idsDejaDansMvt.contains(idPersonnel)) {
                    MouvementAbsence mva = new MouvementAbsence();
                    mva.setIdSource(this.getId());
                    mva.setIdPersonnel(idPersonnel);
                    mva.setMois(this.getMois());
                    mva.setAnnee(this.getAnnee());
                    mva.setPlus(soldeConge);
                    String remarque = "Solde cong&eacute; ajout&eacute; le " + Utilitaire.dateDuJour();
                    mva.setRemarque(remarque);
                    mva.createObject(u, c);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @Override
    public boolean getEstIndexable() {
        return true;
    }

    @Override
    public String rajoutRemarque(Connection c) throws Exception {
        return "Edition de la paie du "+this.getMois() + "/" + this.getAnnee();
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

    public String getIduser() {
        return iduser;
    }

    public void setIduser(String iduser) {
        this.iduser = iduser;
    }

    public String getIddirection() {
        return iddirection;
    }

    public void setIddirection(String iddirection) {
        this.iddirection = iddirection;
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

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {

        this.montant = montant;
    }

    public double getGain() {
        return gain;
    }

    public void setGain(double gain) {
        this.gain = gain;
    }

    public double getRetenue() {
        return retenue;
    }

    public void setRetenue(double retenue) {
        this.retenue = retenue;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public EcritureDeLaPaieRegr[] getDetails(Connection c, String idEdition) throws Exception {
        boolean estconnect = false;
        EcritureDeLaPaieRegr[] listepaie = null;
        try {
            if (c != null) {
                c = new UtilDB().GetConn();
                estconnect = true;
            }

            EcritureDeLaPaieRegr reg = new EcritureDeLaPaieRegr();
            reg.setNomTable("ecriture_dela_paie_regr_compte");
            reg.setIdedition(idEdition);
            listepaie = (EcritureDeLaPaieRegr[]) CGenUtil.rechercher(reg, null, null, c, " and idedition = '" + idEdition + "' ");

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (c != null && estconnect == true) {
                c.close();
            }
        }
        return listepaie;
    }
    
/*
    public ComptaSousEcriture[] genererSousEcriture(Connection c) throws Exception {
        ComptaSousEcriture[] compta = {};
        boolean canClose = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                canClose = true;
            }
            EcritureDeLaPaieRegr detail[] = this.getDetails(c, this.getId());
            int taille = detail.length;
            compta = new ComptaSousEcriture[taille + 1];
            double bruteImposable = 0;
//            double ostieEntreprise = 5;
            double cnapsEntreprise = 0;
            Configuration[] conf1s = (Configuration[]) CGenUtil.rechercher(new Configuration(), null, null, c, " and id in ('"+ Constante.idCnapsEmpl +"', '"+ Constante.idCnaps +"') order by cast (valmin as decimal) asc ");
            int i = 0;
            for (i = 0; i < taille; i++) {
                compta[i] = new ComptaSousEcriture();
                compta[i].setLibellePiece(detail[i].getComptelibelle());
                compta[i].setCompteLib(detail[i].getComptelibelle());
                compta[i].setRemarque(detail[i].getComptelibelle());
                System.out.println("Compte=="+detail[i].getComptegen_debit()+" +====+"+detail[i].getGain());
                if (detail[i].getComptegen_debit() != null && !detail[i].getComptegen_debit().isEmpty()) {
                    compta[i].setCompte(detail[i].getComptegen_debit());
                    compta[i].setDebit(detail[i].getGain());
//                    if(detail[i].getImposable()!=null&&detail[i].getImposable().compareToIgnoreCase("I")==0){
//                        bruteImposable += detail[i].getGain();
//                    }
                    
                } else if(detail[i].getComptegen_credit() != null && !detail[i].getComptegen_credit().isEmpty()){
//                    if(detail[i].getComptegen_credit().startsWith("43300")){
//                        ostieEntreprise = detail[i].getRetenue()*ostieEntreprise;
//                        detail[i].setRetenue(detail[i].getRetenue()+ostieEntreprise);
//                    } else 
                    if(detail[i].getComptegen_credit().startsWith("43100000")){
                        cnapsEntreprise = detail[i].getRetenue()*(Double.valueOf(conf1s[1].getValmax())*100)/(Double.valueOf(conf1s[0].getValmax())*100);
                        
                        detail[i].setRetenue(detail[i].getRetenue()+cnapsEntreprise);
                    }
                    compta[i].setCompte(detail[i].getComptegen_credit());
                    compta[i].setCredit(detail[i].getRetenue() > 0 ? detail[i].getRetenue() : detail[i].getGain());
                }
            }
//            double sommegain = AdminGen.calculSommeDouble(detail, "gain");
//            double sommeretenue = AdminGen.calculSommeDouble(detail, "retenue");
//            double difference = sommegain - sommeretenue;
            
            compta[i] = new ComptaSousEcriture();
            compta[i].setLibellePiece("CNaPS cotisation patronales FER");
            compta[i].setRemarque("CNaPS cotisation patronales FER");
            compta[i].setCompte("64511000");
            compta[i].setDebit(cnapsEntreprise);
//            i++;
            
//            compta[i] = new ComptaSousEcriture();
//            compta[i].setLibellePiece("Frais medicaux FER");
//            compta[i].setRemarque("Frais medicaux FER");
//            compta[i].setCompte("64541");
//            compta[i].setCredit(ostieEntreprise);

        } catch (Exception e) {
            throw e;
        } finally {
            if (canClose) {
                c.close();
            }

        }
        return compta;
    }*/
    
    /*
    public void genererEcriture(String u, Connection c) throws Exception{
        Date dateDuJour = Utilitaire.dateDuJourSql();
        int exercice = Utilitaire.getAneeEnCours();
        ComptaEcriture mere = new ComptaEcriture();
        mere.setDaty(dateDuJour);
        mere.setDesignation("Ecriture liee a l'edtion paie "+this.getMois()+"/"+this.getAnnee() +" pour la direction "+this.getIddirection());
        mere.setExercice(exercice);
        mere.setDateComptable(dateDuJour);
        mere.setJournal(Constante.journalAchat);
        mere.setIdobjet(this.getId());
        mere.setOrigine(Constante.comptaoriginepaie);
        mere.createObject(u, c);
        ComptaSousEcriture[] filles = this.genererSousEcriture(c);
        for(int i=0; i<filles.length; i++){
            filles[i].setMere(mere.getId());
            filles[i].setExercice(exercice);
            filles[i].setDaty(dateDuJour);
            filles[i].setJournal(Constante.journalAchat);
            filles[i].createObject(u, c);
        }
    }
    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        super.validerObject(u, c); 
        genererEcriture(u, c);
        return this;
    }*/
    
    /*
    public void genererEcritureFraisMedicaux(String u, Connection c) throws Exception{
        Date dateDuJour = Utilitaire.dateDuJourSql();
        int exercice = Utilitaire.getAneeEnCours();
        ComptaEcriture mere = new ComptaEcriture();
        mere.setDaty(dateDuJour);
        mere.setDesignation("Ecriture liee a l'edtion paie "+this.getMois()+"/"+this.getAnnee() +" pour la direction "+this.getIddirection());
        mere.setExercice(exercice);
        mere.setDateComptable(dateDuJour);
        mere.setJournal(Constante.journalAchat);
        mere.setIdobjet(this.getId());
        mere.setOrigine(Constante.comptaoriginepaie);
        mere.createObject(u, c);
        ComptaSousEcriture[] filles = this.genererSousEcriture(c);
        for(int i=0; i<filles.length; i++){
            filles[i].setMere(mere.getId());
            filles[i].setExercice(exercice);
            filles[i].setDaty(dateDuJour);
            filles[i].setJournal(Constante.journalAchat);
            filles[i].createObject(u, c);
        }
    }*/

    public TraitementPaie[] genererTraitementPaie() throws Exception {
        Connection connection = null;
        boolean isOpen = false;
        String nomTable = "paie_editionmoisannee";
        String nomTableTraitementPaie = "TRAITEMENT_PAIE_LIB";
        try {
            isOpen = true;
            PaieEditionmoisannee paieEdition = (PaieEditionmoisannee) this.getById(this.getId(), nomTable, connection);
            TraitementPaie traitementPaie = new TraitementPaie();
            traitementPaie.setNomTable(nomTableTraitementPaie);
            traitementPaie.setIdEdition(paieEdition.getId());
            TraitementPaie[] filles = (TraitementPaie[]) CGenUtil.rechercher(traitementPaie, null, null, connection, "");
            if (filles != null && filles.length > 0) {
                return filles;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (isOpen && connection != null) {
                connection.close();
            }
        }
        return null;
    }

    public Date getDateOuverture() {
        return dateOuverture;
    }

    public void setDateOuverture(Date dateOuverture) {
        this.dateOuverture = dateOuverture;
    }

    public Date getDateFermeture() {
        return dateFermeture;
    }

    public void setDateFermeture(Date dateFermeture) {
        this.dateFermeture = dateFermeture;
    }
}
