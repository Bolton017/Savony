package avoir;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMere;
import client.Client;
import faturefournisseur.Fournisseur;
import mg.cnaps.compta.ComptaEcriture;
import mg.cnaps.compta.ComptaSousEcriture;
import utilitaire.UtilDB;
import utils.ConstanteStation;

import java.sql.Connection;
import java.sql.Date;

public class AvoirAchat extends ClassMere {
    String id;
    String designation;
    String idMagasin;
    Date daty;
    String remarque;
    String idFournisseur;
    String idFacture;

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("AVRAC", "GETSEQ_AVOIRACHAT");
        this.setId(makePK(c));
    }

    public AvoirAchat() throws  Exception{
        this.setNomTable("AVOIRACHAT");
        setLiaisonFille("idMere");
        setNomClasseFille("avoir.AvoirAchatFille");
    }

    @Override
    public String getNomClasseFille() {
        return "avoir.AvoirAchatFille";
    }

    @Override
    public String getLiaisonFille() {
        return "idMere";
    }

    public AvoirAchat(String nomtable){
        this.setNomTable(nomtable);
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getIdMagasin() {
        return idMagasin;
    }

    public void setIdMagasin(String idMagasin) {
        this.idMagasin = idMagasin;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getIdFournisseur() {
        return idFournisseur;
    }

    public void setIdFournisseur(String idFournisseur) {
        this.idFournisseur = idFournisseur;
    }

    public String getIdFacture() {
        return idFacture;
    }

    public void setIdFacture(String idFacture) {
        this.idFacture = idFacture;
    }

    public void genererEcriture(String u, Connection c) throws Exception{
        ComptaEcriture mere = new ComptaEcriture();
        Date dateDuJour = utilitaire.Utilitaire.dateDuJourSql();
        int exercice = utilitaire.Utilitaire.getAnnee(daty);
        mere.setDaty(dateDuJour);
        mere.setDesignation("Ecriture d'avoir achat: "+this.getIdFacture());
        mere.setExercice(""+exercice);
        mere.setDateComptable(this.getDaty());
        mere.setJournal(ConstanteStation.journalAchat);
        mere.setOrigine(this.getId());
        mere.setIdobjet(this.getId());
        mere.createObject(u, c);

        ComptaSousEcriture[] filles = this.genererSousEcriture(c);
        for(int i=0; i<filles.length; i++){
            filles[i].setIdMere(mere.getId());
            filles[i].setExercice(exercice);
            filles[i].setDaty(this.getDaty());
            filles[i].setJournal(ConstanteStation.JOURNALVENTE);

            if(filles[i].getDebit()>0 || filles[i].getCredit()>0) filles[i].createObject(u, c);
        }
    }

    public ComptaSousEcriture[] genererSousEcriture(Connection c) throws Exception{
        ComptaSousEcriture[] compta={};
        boolean canClose=false;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                canClose=true;
            }
            AvoirAchatLib[] avoirs = (AvoirAchatLib[]) CGenUtil.rechercher(new AvoirAchatLib("AVOIRACHATCALC_AVEC_LIB"), null, null, c, " and id = '"+this.getId()+"'");
            if(avoirs.length<1) throw new Exception("Avoir Introuvable");
            Fournisseur fournisseur = getFournisseur(c);
            AvoirAchatFilleLib [] details = this.getDetails(c);
            int taille = details.length;
            compta = new ComptaSousEcriture[taille+2];
            int i=0;
            for(i=i;i<taille;i++){
                compta[i]=new ComptaSousEcriture();
                compta[i].setLibellePiece(this.getDesignation());
                compta[i].setRemarque(details[i].getDesignation());
                compta[i].setCompte(details[i].getCompte());
                compta[i].setCredit(details[i].getMontantHT());
            }

            compta[i]=new ComptaSousEcriture();
            compta[i].setLibellePiece("TVA Deductible");
            compta[i].setRemarque("TVA Deductible");
            compta[i].setCompte(ConstanteStation.compteTVADeductible);
            compta[i].setCredit(avoirs[0].getMontantTva());
            i++;

            compta[i]=new ComptaSousEcriture();
            compta[i].setLibellePiece("Avoir Fournisseur "+avoirs[0].getIdFournisseurLib());
            compta[i].setRemarque("Avoir Fournisseur "+avoirs[0].getIdFournisseurLib());
            compta[i].setCompte(fournisseur.getCompte());
            compta[i].setDebit(avoirs[0].getMontantTtcAr());
            compta[i].setCompte_aux(fournisseur.getCompteauxiliaire());
        } catch(Exception e){
            throw e;
        } finally {
            if(canClose){
                c.close();
            }
        }
        return compta;
    }

    public AvoirAchatFilleLib[] getDetails(Connection c) throws Exception{
        AvoirAchatFilleLib[] avoirAchatFilles = null;
        try{
            String awhere = " and IDMERE = '"+this.getId()+"'";
            avoirAchatFilles = (AvoirAchatFilleLib[]) CGenUtil.rechercher(new AvoirAchatFilleLib("AVOIRACHATFILLELIBECRITURE"), null, null, c, awhere);
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }
        return avoirAchatFilles;
    }

    public Fournisseur getFournisseur(Connection c) throws Exception{
        Fournisseur fournisseur = new Fournisseur();
        Fournisseur[] fournisseurs = (Fournisseur[]) CGenUtil.rechercher(fournisseur,null,null,c, " and id = '"+this.getIdFournisseur()+"'");
        if(fournisseurs.length > 0){
            return fournisseurs[0];
        }
        throw new Exception("Le fournisseur n'existe pas");
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {

        genererEcriture(u, c);

        return super.validerObject(u, c);
    }
}
