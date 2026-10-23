package faturefournisseur;

import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.TypeObjet;
import mg.cnaps.compta.ComptaExercice;
import mg.cnaps.compta.ConstanteCompta;
import mg.cnaps.compta.ComptaEcriture;
import produits.Ingredients;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.time.YearMonth;
import java.util.Calendar;
import java.sql.Date;

public class DepenseSaisie extends FactureFournisseur{
    private int exercice;
    private String periode;
    private String libelle;
    private double totalfacture;
    private String jour;

    public String getJour() {
        return jour;
    }

    public void setJour(String jour) {
        this.jour = jour;
    }

    public double getTotalfacture() {
        return totalfacture;
    }

    public void setTotalfacture(double totalfacture) {
        this.totalfacture = totalfacture;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public int getExercice() {
        return exercice;
    }

    public void setExercice(int exercice) throws Exception {
        if (exercice < 1900 || exercice > 2100) {
            throw new Exception("Exercice invalide : " + exercice + ". Doit \u00EAtre compris entre 1900 et 2100.");
        }
        this.exercice = exercice;
    }

    public String getPeriode() {
        return periode;
    }

    public void setPeriode(String periode) throws Exception{
        /*if (periode == null || !periode.matches("\\d{1,2}/\\d{1,2}")) {
            throw new Exception(
                    "P\u00E9riode invalide : " + periode + ". Format attendu : jj/MM"
            );
        }
        String[] parts = periode.split("/");
        int jour = Integer.parseInt(parts[0]);
        int mois = Integer.parseInt(parts[1]);
        if (jour < 1 || jour > 31) {
            throw new Exception("Jour invalide dans la p\u00E9riode : " + jour);
        }*/

        int mois = Integer.parseInt(periode);
        if (mois < 1 || mois > 12) {
            throw new Exception("Mois invalide dans la p\u00E9riode : " + mois);
        }
        this.periode = periode;
    }

    public DepenseSaisie(){
        this.setNomTable("DEPENSESAISIE");
    }
    public void controleJourPeriode() throws Exception {
        try {
            int annee = Utilitaire.getAnnee(this.getDaty());
            YearMonth yearMonth = YearMonth.of(annee, Integer.parseInt(this.getPeriode()));
            int j = new Integer(this.getJour());
            if( j < 1 || j> yearMonth.lengthOfMonth())throw new Exception("Le jour entr\u00E9 n'existe pas dans la p\u00E9riode s\u00E9lectionn\u00E9e.");
            this.setDaty(java.sql.Date.valueOf(java.time.LocalDate.of(annee,Integer.parseInt(this.getPeriode()),j)));
        } catch (Exception e) {
            throw new Exception("Le jour entr\u00E9 n'existe pas dans la p\u00E9riode s\u00E9lectionn\u00E9e.");
        }
    }
    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        this.setNomTable("FACTUREFOURNISSEUR");
        controleJourPeriode();
        Fournisseur f = (Fournisseur) new Fournisseur().getById(this.getIdFournisseur(),"FOURNISSEUR",c);
        String nomFournisseur="";
        if(f!=null)nomFournisseur=f.getNom();
        String designation = "FA N\u00B0 "+this.getReference()+"-"+nomFournisseur+"-"+this.getLibelle();
        this.setDesignation(designation);
        int exercice = this.getExercice();
        String periode = this.getPeriode();
        int jour = Utilitaire.getJourDateNombre(this.getDaty());
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.set(exercice, Utilitaire.stringToInt(periode) - 1, jour);
        Date daty = new Date(cal.getTimeInMillis());
        //this.setDaty(daty);

        if(this.getIdFournisseur()==null || this.getIdFournisseur().trim().isEmpty()){
            throw new Exception("Fourisseur obligatoire");
        }

        this.setDatyPrevu(this.getDateEcheancePaiement());
        double totalreel = 0;

        for (int i = 0; i < this.getFille().length; i++) {
            FactureFournisseurDetails factureFournisseurDetails = (FactureFournisseurDetails) this.getFille()[i];
            System.err.println("=====================A"+factureFournisseurDetails.getIdProduit()+"A====================");
            Ingredients [] ing = (Ingredients []) CGenUtil.rechercher(new Ingredients(), null,null, c," AND libelle='"+factureFournisseurDetails.getIdProduit()+"'");
            if(ing.length>0){
                factureFournisseurDetails.setIdProduit(ing[0].getId());
            }else{
                Ingredients ingredients = new Ingredients();
                ingredients.setLibelle(factureFournisseurDetails.getIdProduit());
                ingredients.setCompte_achat(factureFournisseurDetails.getCompte());
                ingredients.setCompte_vente(ConstanteCompta.compte_vente);
                Ingredients in = (Ingredients) ingredients.createObject(u,c);
                factureFournisseurDetails.setIdProduit(in.getId());
            }
            System.err.println(factureFournisseurDetails.getCompte());
            factureFournisseurDetails.setNomTable("FACTUREFOURNISSEURFILLE");
            double tva = factureFournisseurDetails.getTva();
            /*
            if (this.getTypeTva().equalsIgnoreCase(ConstanteCompta.contanteTypeTva) ) {
                if (tva > 0) {
                    throw new Exception("TVA invalide : le montant ne correspond pas au type de TVA s\u00E9lectionn\u00E9.");
                }
//                TypeObjet typeTva = (TypeObjet) new TypeObjet().getById(this.getTypeTva(),"TYPETVA",c);
            } else {
                if (tva < 0) {
                    throw new Exception("TVA invalide : le montant ne correspond pas au type de TVA s\u00E9lectionn\u00E9.");
                }
            }
             */
            double montantttc = factureFournisseurDetails.getPu() * factureFournisseurDetails.getQte() * (1 + tva / 100);
            totalreel += montantttc;
            // factureFournisseurDetails.setPu(factureFournisseurDetails.getPu());
        }
        double ecart = this.getTotalfacture() - totalreel;
        if (ecart <= -200 || ecart >= 200) {
//            this.genererPerteProfit(c);
        }
        checkTotalFacture(totalreel);
        return super.createObject(u, c);
    }

    public void checkTotalFacture(double totalreel)throws Exception {
        if (totalreel-this.getTotalfacture()!=0) {
            throw new Exception("Le total reel est different du total de la facture.");
        }
    }

    public String creerViserValider(Connection c,String u) throws Exception {
        boolean canClose=false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                canClose = true;
            }
            DepenseSaisie dep = (DepenseSaisie) super.createObject(u,c);
            DepenseFilleSaisie[] depenseFille = (DepenseFilleSaisie[]) this.getFille();
            for (int i = 0; i < depenseFille.length; i++) {
                depenseFille[i].setNomTable("FACTUREFOURNISSEURFILLE");
                depenseFille[i].setLiaisonMere("idFactureFournisseur");
                depenseFille[i].setIdFactureFournisseur(dep.getId());
                depenseFille[i].createObject(u,c);
            }

            dep.validerObject(u, c);
            ComptaEcriture[] ecritures = (ComptaEcriture[]) CGenUtil.rechercher(new ComptaEcriture(), null, null, c, " and idobjet = '" + dep.getId() + "'");
            if (ecritures.length > 0) {
                ecritures[0].validerObject(u, c);
            }
            return dep.id;
        } catch(Exception e){
            throw e;
        } finally {
            if(canClose){
                c.close();
            }
        }
    }
}
