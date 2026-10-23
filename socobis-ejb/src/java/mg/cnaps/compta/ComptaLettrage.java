
package mg.cnaps.compta;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.ClassMere;
import com.google.gson.Gson;
import mg.cnaps.configuration.Configuration;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;

import affichage.PageRecherche;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Arrays;
import java.util.Map;

import utilitaire.*;

import javax.swing.plaf.nimbus.State;

public class ComptaLettrage extends ClassMere {

    private String id,lettre;
    private Date date_lettrage;
    private String remarque;
    private double montant;

    public ComptaLettrage(String id, String lettre, Date date_lettrage, String remarque, double montant){
        super.setNomTable("compta_lettrage");
        this.setId(id);
        this.setLettre(lettre);
        this.setDate_lettrage(date_lettrage);
        this.setRemarque(remarque);
        this.setMontant(montant);
    }

    public ComptaLettrage(String lettre, Date date_lettrage, String remarque, double montant){
        super.setNomTable("compta_lettrage");
        this.setLettre(lettre);
        this.setDate_lettrage(date_lettrage);
        this.setRemarque(remarque);
        this.setMontant(montant);
    }

    public ComptaLettrage() {
        super.setNomTable("compta_lettrage");

    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("LET", "GETSEQCOMPTALETTRAGE");
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
    public ComptaLettrage createLettrageMF(String[] ids, String lettrage, String u) throws Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }

          ComptaEcriture tmp = new ComptaEcriture();
          tmp.setNomTable("COMPTA_ECRITURE_MF");
            ComptaEcriture[] ce = (ComptaEcriture[]) CGenUtil.rechercher(tmp, null, null, c, " and id in ("+Utilitaire.tabToString(ids, "'", ",")+" ) ");
            

          double[] credit = AdminGen.calculSommeDouble(ce,new String[] {"credit"});
          double[] debit = AdminGen.calculSommeDouble(ce,new String[] {"debit"});
            String idSources = "";
          for(int i=0; i<ce.length; i++) {
            idSources = idSources + " ; " + ce[i].getIdobjet();
        }
        if(debit[0] != credit[0])
            throw new Exception ("Le debit et credit ne sont pas equilibrés");
        String remarque = "Lettrage associ&eacute;e au " + idSources;

        ComptaLettrage cl = new ComptaLettrage(lettrage,utilitaire.Utilitaire.dateDuJourSql(), remarque, credit[0]);
        Configuration[] lettrageParram = null;
        lettrageParram = (Configuration[]) CGenUtil.rechercher(new Configuration(), null, null, c, " AND TYPECONFIG = 'lettrage'");

        if (lettrageParram.length == 0) return null;

        lettrageParram[0].setRemarque(lettrage);
        lettrageParram[0].updateToTableWithHisto(u,c);

        this.testLettre(c);

        cl.createObject(u, c);
        for(int i=0; i<ce.length; i++) {
            ce[i].updateComptaEcritureWithLettrage(cl.getTuppleID(), u, c);
        }
        return cl;
         } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
        
    }
    public ComptaLettrage createLettrageCSEMF(String[] ids, String lettrage, String u,Connection con) throws Exception{
        Connection c = con;
        Statement st=null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }

            Configuration[] lettrageParram = null;
            lettrageParram = (Configuration[]) CGenUtil.rechercher(new Configuration(), null, null, c, " AND TYPECONFIG = 'lettrage'");
            if(lettrage==null||lettrage.compareToIgnoreCase("")==0)
            {
                char[] l = lettrageParram[0].getRemarque().toLowerCase().toCharArray();
                lettrage = Utilitaire.incrementLettre(l);
            }
            ComptaSousEcritureLib tmp = new ComptaSousEcritureLib();
            tmp.setNomTable("COMPTA_SOUS_ECRITURE_CSEMF");
            ComptaSousEcritureLib[] ce = (ComptaSousEcritureLib[]) CGenUtil.rechercher(tmp, null, null, c, " and id in ("+Utilitaire.tabToString(ids, "'", ",")+" ) ");
            ComptaSousEcritureLib[] ceGauche = Arrays.stream(ce)
                    .filter(se -> se.getOrigine() != null
                            && (se.getOrigine().equalsIgnoreCase("FCF")
                            || se.getOrigine().equalsIgnoreCase("VNT")))
                    .toArray(ComptaSousEcritureLib[]::new);


            ComptaSousEcritureLib[] ceDroite = Arrays.stream(ce)
                    .filter(se -> se.getOrigine() == null
                            || (!se.getOrigine().equalsIgnoreCase("FCF")
                            && !se.getOrigine().equalsIgnoreCase("VNT")))
                    .toArray(ComptaSousEcritureLib[]::new);

            String idLettrageExistant = "";
            if(ceGauche.length>0 && ceGauche[0].getLettrage()!=null && !ceGauche[0].getLettrage().isEmpty()){
                idLettrageExistant = ceGauche[0].getLettrage();
            }
   
            double[] credit = AdminGen.calculSommeDouble(ceDroite,new String[] {"montant"});
            double[] debit = AdminGen.calculSommeDouble(ceGauche,new String[] {"montant"});

            BigDecimal totalCredit = Arrays.stream(credit)
                    .mapToObj(BigDecimal::valueOf)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            BigDecimal totalDebit = Arrays.stream(debit)
                    .mapToObj(BigDecimal::valueOf)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

          
            if(debit[0] != credit[0])
                lettrage = lettrage.toLowerCase();
            if(debit[0] ==credit[0])
                lettrage = lettrage.toUpperCase();
            String remarque = "Lettrage associ&eacute;e au " + Utilitaire.tabToString(ids, "", " ; ");

            ComptaLettrage cl = new ComptaLettrage(lettrage,utilitaire.Utilitaire.dateDuJourSql(), remarque, credit[0]);
            String idLettrageAUtiliser = "";
            if (idLettrageExistant != null && !idLettrageExistant.isEmpty()) {
                ComptaLettrage ancienneLettrage = (ComptaLettrage) this.getById(idLettrageExistant,this.getNomTable(),c);
                if(ancienneLettrage!=null){
                    ancienneLettrage.setLettre(ancienneLettrage.getLettre().toUpperCase());
                    ancienneLettrage.setMontant(ancienneLettrage.getMontant() + cl.getMontant());
                    ancienneLettrage.setRemarque(ancienneLettrage.getRemarque() + " ; " + Utilitaire.tabToString(AdminGen.getDistinct(ceDroite, "id"), "", " ; "));
                    ancienneLettrage.updateToTableWithHisto(u,c);
                    idLettrageAUtiliser = idLettrageExistant;
                    cl.setId(idLettrageAUtiliser);
                }
            } else {
                cl.createObject(u, c);
            }
            

            if (lettrageParram.length == 0) return null;

            lettrageParram[0].setRemarque(lettrage);
            lettrageParram[0].updateToTableWithHisto(u,c);

            this.testLettre(c);
            st=c.createStatement();
            //cl.createObject(u, c);
            for(int i=0; i<ce.length; i++) {
                ce[i].setNomTable("compta_sous_ecriture");
                ce[i].setLettrage(cl.getId());
                ce[i].updateToTableWithHistoBatch( u, st);
            }
            st.executeBatch();
            if(estOuvert==true)c.commit();
            return cl;
        } catch (Exception e) {
            throw e;
        } finally {
            if(st!=null)st.close();
            if (c != null && estOuvert == true) {
                c.close();
            }
        }

    }
    public void delettrerSousEcritureLiees(String u,Connection c)throws Exception{
        ComptaSousEcriture sousEcriture=new ComptaSousEcriture();
        sousEcriture.setLettrage(id);
        ComptaSousEcriture[] listeSousEcriture= (ComptaSousEcriture[]) CGenUtil.rechercher(sousEcriture,null, null, c, "");
        for(int i=0 ; i<listeSousEcriture.length ; i++){
            listeSousEcriture[i].setLettrage(null);
            listeSousEcriture[i].updateToTableWithHisto(u,c);
        }
    }

    public void updateSousEcritureLiees(String u , Connection c)throws Exception{
        ComptaSousEcriture sousEcriture=new ComptaSousEcriture();
        sousEcriture.setLettrage(id);
        ComptaSousEcriture[] listeSousEcriture= (ComptaSousEcriture[]) CGenUtil.rechercher(sousEcriture,null, null, c, "");
        for(int i=0 ; i<listeSousEcriture.length ; i++){
            listeSousEcriture[i].setLettrage(id);
            listeSousEcriture[i].updateToTableWithHisto(u,c);
        }
    }
    @Override
    public int updateToTableWithHisto(String u, Connection c)throws Exception{
        updateSousEcritureLiees(u,c);
        return super.updateToTableWithHisto(u,c);
    }

    @Override
    public int deleteToTableWithHisto (String u,Connection c) throws Exception{
        delettrerSousEcritureLiees(u,c);
        return super.deleteToTableWithHisto(u,c);  
    }

    public void testLettre (Connection c) throws Exception{
        ComptaLettrage[] cl = null;
        cl = (ComptaLettrage[]) CGenUtil.rechercher(new ComptaLettrage(), null, null, c, " AND lettre = '" + this.getLettre() + "'");
        if(cl.length > 0){
            throw new Exception(" Lettre "+cl[0].getLettre()+ " deja utiliser veuillez choisir un autre");
        }
    }

//    @Override
//    public void controler (Connection c ) throws Exception{
//        double[] debit =AdminGen.calculSommeDouble(this.getFille(), new String[] {"debit"});
//        double[] credit = AdminGen.calculSommeDouble(this.getFille(),new String[] {"credit"});
//        if(credit[0]<debit[0]){
//            throw new Exception("Debit supérieur à crédit");
//        }
//        if(debit[0]<credit[0]){
//            throw new Exception("Crédit supérieur à débit");
//       }
//       //this.testLettre(c);
//
//    }

//    @Override
//    public int insertToTableWithHisto(String u, Connection c) throws Exception{
//        setDate_lettrage(Utilitaire.dateDuJourSql());
//        double[] credit = AdminGen.calculSommeDouble(this.getFille(),new String[] {"credit"});
//        setMontant((credit.length == 0) ? 0 : credit[0]);
//        setEtat(1);
//        setRemarque("");
//        construirePK(c);
//        Configuration[] lettrageParram = null;
//        lettrageParram = (Configuration[]) CGenUtil.rechercher(new Configuration(), null, null, c, " AND TYPECONFIG = 'lettrage'");
//
//        if (lettrageParram.length == 0) return 1;
//
//        lettrageParram[0].setRemarque(lettre);
//        lettrageParram[0].updateToTableWithHisto(u,c);
//        return super.insertToTableWithHisto(u,c);
//    }
//
//    @Override
//    public ClassMAPTable createObject(String u , Connection c ) throws Exception{
//        this.insertToTableWithHisto(u,c);
//        this.controler(c);
//        return this;
//    }

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
     * @return the lettre
     */
    public String getLettre() {
        return lettre;
    }

    /**
     * @param lettre the lettre to set
     */
    public void setLettre(String lettre) {
        this.lettre = lettre;
    }



    /**
     * @return the date_lettrage
     */
    public Date getDate_lettrage() {
        return date_lettrage;
    }

    /**
     * @param date_lettrage the date_lettrage to set
     */
    public void setDate_lettrage(Date date_lettrage) {
        this.date_lettrage = date_lettrage;
    }

    /**
     * @return the remarque
     */
    public String getRemarque() {
        return remarque;
    }

    /**
     * @param remarque the remarque to set
     */
    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    /**
     * @return the montant
     */
    public double getMontant() {
        return montant;
    }

    /**
     * @param montant the montant to set
     */
    public void setMontant(double montant) {
        this.montant = montant;
    }
}

