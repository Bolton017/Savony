/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package faturefournisseur;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.ClassMere;
import java.sql.Connection;
import java.sql.Date;
import java.util.Vector;

import change.TauxDeChange;
import historique.MapUtilisateur;
import utilitaire.ConstanteEtat;
import utilitaire.UtilDB;
import utils.ConstanteAsync;
import utils.ConstanteSavonnerie;
import utils.ConstanteSocobis;
import vente.*;
import utilitaire.Utilitaire;

/**
 *
 * @author micha
 */
public class As_BonDeCommande extends ClassMere {
    
    private String id;
    private Date daty , dateEcheance ;
    private int etat;
    private String remarque , service ;
    private String designation;
    private String fournisseur;
    private String modepaiement;
    private String reference;
    private String modepaiementlib;
    private String fournisseurlib;
    private String idDevise;
    private String idMagasin;
    private String idOrigine;
    private Date dateLimite;
    private double remisemontant,remise;
    private int echeance ;

    public Date getDateEcheance() {
        return dateEcheance;
    }

    public void setDateEcheance(Date dateEcheance) {
        this.dateEcheance = dateEcheance;
    }

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    public int getEcheance() {
        return echeance;
    }

    public void setEcheance(int echeance) {
        this.echeance = echeance;
    }

    public Date getDateLimite() {
        return dateLimite;
    }

    public void setDateLimite(Date dateLimite) {
        this.dateLimite = dateLimite;
    }

    public String getIdMagasin() {
        return idMagasin;
    }

    public void setIdMagasin(String idMagasin) {
        this.idMagasin = idMagasin;
    }

    // private ArrayList<As_BonDeCommande_Fille> bcFilles;

    public String getModepaiementlib() {
        return modepaiementlib;
    }

    public void setModepaiementlib(String modepaiementlib) {
        this.modepaiementlib = modepaiementlib;
    }

    public String getFournisseurlib() {
        return fournisseurlib;
    }

    public void setFournisseurlib(String fournisseurlib) {
        this.fournisseurlib = fournisseurlib;
    }

    public As_BonDeCommande() {
        this.setNomTable("AS_BONDECOMMANDE");
        this.setLiaisonFille("idbc");

    }
    public ClassMAPTable createObject(String u, Connection c) throws Exception{
        double montantTTCCalc= AdminGen.calculSommeDouble(this.getFille(),"montantTTCCalc");
        double proportion=0;
        if(montantTTCCalc>0) proportion= this.getRemisemontant() *100/montantTTCCalc;
        if(proportion>0){
            this.setRemise(proportion);
            this.setRemisemontant(0);
        }
        // Application du dernier taux de change quand la devise n'est pas AR
        double taux=1;
        if(this.getIdDevise().compareToIgnoreCase("AR")!=0)
            taux= TauxDeChange.getLastTaux(c,Utilitaire.formatterDaty(this.getDaty()),this.getIdDevise());

        As_BonDeCommande_Fille[] filles = (As_BonDeCommande_Fille[]) this.getFille();

        for (As_BonDeCommande_Fille bcf : filles) {
            bcf.setIdDevise(this.getIdDevise());
            if(bcf.getIdDevise().compareToIgnoreCase("AR")!=0&&bcf.getTauxDeChange()<=1)
                bcf.setTauxDeChange(taux);
        }

        construirePK(c);
        String lien = "?but=bondecommande/bondecommande-fiche.jsp&id=" + this.getTuppleID();
        this.setMessageNotif("Un nouveau bon de commande a &eacute;t&eacute; ajout&eacute; : <a href='" + lien + "'>" + this.getTuppleID() + "</a>");
        this.setNotifAWhere(" and idrole in('"+ ConstanteSavonnerie.ROLE_RESPACHAT+"')");

        return super.createObject(u,c);
    }

    public String getIdOrigine() {
        return idOrigine;
    }

    public void setIdOrigine(String idOrigine) {
        this.idOrigine = idOrigine;
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("BC", "GETSEQBONCOMMANDE");
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

    public String getId() {
        return this.id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDaty() {
        return this.daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public int getEtat() {
        return this.etat;
    }

    public void setEtat(int etat) {
        this.etat = etat;
    }

    public String getRemarque() {
        return this.remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getDesignation() {
        return Utilitaire.champNull(designation);
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getFournisseur() {
        return this.fournisseur;
    }

    public void setFournisseur(String fournisseur) throws Exception{
        if(fournisseur == null || fournisseur.compareToIgnoreCase("") == 0 )throw new Exception("Fournisseur manquant");
        this.fournisseur = fournisseur;
    }

    public String getModepaiement() {
        return Utilitaire.champNull(modepaiement);
    }

    public void setModepaiement(String modepaiement) {
        if (getMode().equals("modif") && (modepaiement == null || modepaiement.isEmpty())) {
            setModepaiement(ConstanteAsync.PAIEMENT_BONACHAT);
        } else {
            this.modepaiement = modepaiement;
        }
    }

    public String getReference() {
        return this.reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public double getRemisemontant() {
        return remisemontant;
    }

    public void setRemisemontant(double remisemontant) {
        this.remisemontant = remisemontant;
    }

    public double getRemise() {
        return remise;
    }

    public void setRemise(double remise) {
        this.remise = remise;
    }

    // public ArrayList<As_BonDeCommande_Fille> getBcFilles() {
    //     return bcFilles;
    // }

    // public void setBcFilles(ArrayList<As_BonDeCommande_Fille> bcFilles) {
    //     this.bcFilles = bcFilles;
    // }
     @Override
    public String getLiaisonFille() {
        return "idbc";
    }
    @Override
    public String getNomClasseFille() {
        return "faturefournisseur.As_BonDeCommande_Fille";
    }
    @Override
    public void controler(Connection c) throws Exception
    {
        As_BonDeCommande_Fille[] bcfille = (As_BonDeCommande_Fille[]) CGenUtil.rechercher(new As_BonDeCommande_Fille(), null, null, c, "and idbc  ='" + this.getId() + "' and idDevise!='"+this.getIdDevise()+"'");
         if(bcfille.length>0){
             throw new Exception("Devise diff\u00E9rent non accept\u00E9");
         }
    }
            
    public String getIdDevise() {
        return idDevise;
    }

    public void setIdDevise(String idDevise) {
        if (getMode().equalsIgnoreCase("modif")) {
            if (idDevise == null) {
                setIdDevise("AR");
            }
        }
        this.idDevise = idDevise;
    }
    
    public String genererFacture(String u) throws Exception{
        Connection c = null;
        try{
            c = new UtilDB().GetConn();
            c.setAutoCommit(false);
            String idFacture =  genererFacture(u,c);
            c.commit();
            return idFacture;
        }
        catch(Exception e){
            if(c!=null) c.rollback();
            throw e;
        }
        finally{
            if(c!=null) c.close();
        }
    }

    public String genererFacture(String u,Connection c) throws Exception{
        As_BonDeCommande enBase = (As_BonDeCommande)this.getById(this.getId(), this.getNomTable(), c);
        As_BonDeCommande_Fille vLib = new As_BonDeCommande_Fille();
        vLib.setNomTable("AS_BONDECOMMANDE_FILLE");
        As_BonDeCommande_Fille[] details = (As_BonDeCommande_Fille[]) CGenUtil.rechercher(vLib,null,null,c," AND idBc='"+this.getId()+"'");
        if(details.length > 0){
            Vente vente = new Vente();
            vente.setIdClient(enBase.getFournisseur());
            vente.setDesignation("Facture de la BC "+this.getId());
            vente.setDaty(Utilitaire.dateDuJourSql());
            vente.setIdOrigine(enBase.getId());
            // vente.setIdMagasin(enBase.getIdMagasin());
            vente.setEtat(1);
            vente.createObject(u, c);
            for(As_BonDeCommande_Fille detail:details){
                VenteDetails detailVente= new VenteDetails();
                detailVente.setIdOrigine(detail.getId());
                detailVente.setIdProduit(detail.getProduit());
                detailVente.setQte(detail.getQuantite());
                detailVente.setPu(detail.getPu());
                detailVente.setTva(detail.getTva());
                detailVente.setIdVente(vente.getId());
                detailVente.setIdDevise(detail.getIdDevise());
                detailVente.setTauxDeChange(detail.getTauxDeChange());
                detailVente.createObject(u, c);
            }
            return vente.getId();
        }
        throw new Exception("Plus aucun article à facturer");
    }    


    public As_BonDeLivraison createBL() throws Exception {
        As_BonDeLivraison bl = new As_BonDeLivraison();
        bl.setDaty(Utilitaire.dateDuJourSql());
        bl.setIdbc(this.getId());
        bl.setIdFournisseur(fournisseur);
        return bl;
    }

    public As_BonDeCommande_Fille[] getBCFilleResteALivrer(Connection c, String nomtable) {
        As_BonDeCommande_Fille[] bcfilles = null;
        try {
            if (c == null) {
                throw new Exception("Connexion non établie");
            }
            if (nomtable == null) {
                nomtable = "BCFILLERESTEALIVRERLIB";
            }
            As_BonDeCommande_Fille temp = new As_BonDeCommande_Fille();
            temp.setNomTable(nomtable);
            bcfilles = (As_BonDeCommande_Fille[]) CGenUtil.rechercher(temp, null, null, c, " and idbc = '" + this.getId() + "'");
            for (int i = 0; i < bcfilles.length; i++) {
                As_BonDeCommande_Fille bcfille = bcfilles[i];
                bcfille.calculerTva();
                bcfille.calculerHT();
                bcfille.calculerTTC();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return bcfilles;
    }

    public As_BonDeLivraison[] getBondelivraisons(Connection c, String nomtable) throws Exception {
        As_BonDeLivraison crt = new As_BonDeLivraison();
        if(nomtable!=null){
            crt.setNomTable(nomtable);
        }
        crt.setIdbc(this.getId());
        return (As_BonDeLivraison[]) CGenUtil.rechercher(crt, null, null, c, "");
    }

    private void generateBLFille(As_BonDeLivraison bl, Connection c, String u) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
                c.setAutoCommit(false);
            }
            As_BonDeCommande_Fille[] details = getBCFilleResteALivrer(c, "BCFILLERESTEALIVRERLIB");
            for (As_BonDeCommande_Fille d : details) {
                As_BonDeLivraison_Fille blf = d.createBLFille(bl.getId());
                blf.createObject(u, c);
            }
            
            if(estOuvert){
                c.commit();
            }
            
        } catch (Exception e) {
            if(estOuvert){
                c.rollback();
            }
            throw e;
        } finally {
            if (estOuvert) {
                c.close();
            }
        }
    }

    private As_BonDeLivraison genererBL(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
                c.setAutoCommit(false);
            }
            As_BonDeLivraison bl = createBL();
            bl.setEtat(1);
            bl = (As_BonDeLivraison) bl.createObject(u, c);
            generateBLFille(bl, c, u);
            
            if(estOuvert){
                c.commit();
            }
            
            return bl;
        } catch (Exception e) {
            if(estOuvert){
                c.rollback();
            }
            throw e;
        } finally {
            if (estOuvert) {
                c.close();
            }
        }
    }

    public As_BonDeLivraison genererLivraisonPourPrerempli(String id, Connection c) throws Exception {
        boolean estOuvert = false;
        As_BonDeLivraison bl = new As_BonDeLivraison();
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
                c.setAutoCommit(false);
            }
            As_BonDeCommande f = new As_BonDeCommande();
            f = (As_BonDeCommande)f.getById(id,"AS_BONDECOMMANDE", c);
            bl = f.createBL();
            As_BonDeCommande_Fille_CPL_Livre vLib = new As_BonDeCommande_Fille_CPL_Livre();
            vLib.setNomTable("as_bondecommande_livre");
            vLib.setIdbc(id);
            As_BonDeCommande_Fille_CPL_Livre[] details = (As_BonDeCommande_Fille_CPL_Livre[]) CGenUtil.rechercher(vLib,null,null,c,"");
            Vector<As_BonDeLivraison_Fille> listeBLF = new Vector<>();
            for(As_BonDeCommande_Fille_CPL_Livre detail: details){
                As_BonDeLivraison_Fille blf = new As_BonDeLivraison_Fille();
                blf.setIdbc_fille(detail.getId());
                blf.setProduit(detail.getProduit());
                blf.setPu(detail.getPu()*(1-(detail.getRemise()/100))*detail.getTauxDeChange());
                blf.setUnite(detail.getUnite());
                blf.setDesignation(detail.getProduitlib());
                double qteReste = 0.0;
                try{
                    qteReste = Double.parseDouble(detail.getQte_reste());
                }
                catch(Exception e){
                    qteReste = 0.0;
                }
                blf.setQuantite(qteReste);
                listeBLF.add(blf);
            }
            bl.setFille(listeBLF.toArray(new As_BonDeLivraison_Fille[0]));


            return bl;
        } catch (Exception e) {
            if(estOuvert){
                c.rollback();
            }
            throw e;
        } finally {
            if (estOuvert && c != null) {
                c.close();
            }
        }
    }

    public As_BonDeCommande getAS_BonDommance_By_ID(String id, Connection c) throws Exception {
        boolean estOuvert = false;
        As_BonDeCommande f = new As_BonDeCommande();
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
                c.setAutoCommit(false);
            }
            f = (As_BonDeCommande)f.getById(id,"AS_BONDECOMMANDE", c);
            return f;
        } catch (Exception e) {
            if(estOuvert){
                c.rollback();
            }
            throw e;
        } finally {
            if (estOuvert && c != null) {
                c.close();
            }
        }
    }


    public String genererLivraison(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
                c.setAutoCommit(false);
            }
            As_BonDeCommande f = new As_BonDeCommande();
            f.setId(this.getId());
            As_BonDeCommande[] ff = (As_BonDeCommande[]) CGenUtil.rechercher(f, null, null, c, "");
            String idLivraison = ff[0].genererBL(u, c).getId();
            if(estOuvert){
                c.commit();
            }
            return idLivraison;
        } catch (Exception e) {
            if(estOuvert){
                c.rollback();
            }
            throw e;
        } finally {
            if (estOuvert) {
                c.close();
            }
        }
    }

    public As_BonDeCommande_Fille[] getBonDeCommandeFille(Connection c) throws Exception {
        As_BonDeCommande_Fille abfCrt=new As_BonDeCommande_Fille();
        abfCrt.setIdbc(this.getId());
        As_BonDeCommande_Fille[] abf=(As_BonDeCommande_Fille[]) CGenUtil.rechercher(abfCrt , null, null, c, " ");
        return abf;
    }

    public FactureFournisseurDetails[] getDetailsFacture(String idBL, Connection c) throws Exception {
        boolean connectionWasOpenedInside = false;

        FactureFournisseurDetails[] var5;
        try {
            if (c == null) {
                c = (new UtilDB()).GetConn();
                connectionWasOpenedInside = true;
            }

            this.setId(idBL);
            As_BonDeCommande[] searchBL = (As_BonDeCommande[])CGenUtil.rechercher(this, (String[])null, (String[])null, c, "");
            if (searchBL != null && searchBL.length != 0) {
                As_BonDeCommande bl = searchBL[0];
                Fournisseur fournisseur = new Fournisseur();
                fournisseur.setId(bl.getFournisseur());
                Fournisseur[] searchFournisseur = (Fournisseur[])CGenUtil.rechercher(fournisseur, (String[])null, (String[])null, c, "");
                if (searchFournisseur != null && searchFournisseur.length != 0) {
                    fournisseur = searchFournisseur[0];

                    As_BonDeCommande_Fille[] blFilles = bl.getBonDeCommandeFille(c);
                    FactureFournisseurDetails[] detailsFille = new FactureFournisseurDetails[blFilles.length];

                    for(int i = 0; i < blFilles.length; ++i) {
                        detailsFille[i] = blFilles[i].toFactureFournisseurDetails();
                        detailsFille[i].setMois(Utilitaire.getMoisEnCoursReel());
                        detailsFille[i].setAnnee(Utilitaire.getAnnee(Utilitaire.dateDuJourSql()));
                        detailsFille[i].setTauxDeChange(blFilles[i].getTauxDeChange());
                        detailsFille[i].setRemise(blFilles[i].getRemise());

                        As_BonDeCommande_Fille_CPL bfc = new As_BonDeCommande_Fille_CPL();
                        bfc.setNomTable("AS_BONDECOMMANDE_CPL_RECEPT");

                        bfc.setIdbc(idBL);
                        bfc.setProduit(blFilles[i].getProduit());


                        As_BonDeCommande_Fille_CPL[] sr = (As_BonDeCommande_Fille_CPL[]) CGenUtil.rechercher(bfc, null, null, c, "");
                        if (sr.length != 0) {
                            detailsFille[i].setQte(sr[0].getResteFacture());

                            // validation reste a livre
                            if (sr[0].getResteLivre() != 0) {
                                throw new Exception(
                                        "Le produit " + sr[0].getProduitlib() +
                                                " doit etre livre en totalite pour generer une facture."
                                );
                            }
                        }
                    }

                    FactureFournisseurDetails[] var28 = detailsFille;
                    return var28;
                }

                FactureFournisseurDetails[] var8 = new FactureFournisseurDetails[0];
                return var8;
            }

            var5 = new FactureFournisseurDetails[0];
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (connectionWasOpenedInside && c != null) {
                try {
                    c.close();
                } catch (Exception ce) {
                    ce.printStackTrace();
                }
            }

        }

        return var5;
    }

    public FactureFournisseur genererFacture(){
        FactureFournisseur fact = new FactureFournisseur();
        fact.setIdFournisseur(this.getFournisseur());
        fact.setIdModePaiement(this.getModepaiement());
        fact.setDaty(this.getDaty());
        fact.setIdDevise(this.getIdDevise());
        fact.setIdMagasin(this.getIdMagasin());
        fact.setIdBc(this.getId());
        fact.setIdtypefacture(ConstanteSocobis.TYPE_FACTURE);
        fact.setIdObjet(this.getId());
        return fact;
    }

    @Override
    public Object validerObject(MapUtilisateur u, Connection c) throws Exception {
        String role = u.getIdrole();

        this.setRoleValidation(new String[0]);
        System.out.println(role+" - "+ConstanteSavonnerie.ROLE_RESPACHAT);

        String lien = "?but=bondecommande/bondecommande-fiche.jsp&id=" + this.getTuppleID();
        if (role.equalsIgnoreCase(ConstanteSavonnerie.ROLE_RESPACHAT)){
            this.setEtat(ConstanteSavonnerie.VALIDERRSPACHAT);
            this.setMessageNotif("Un nouveau bon de commande a &eacute;t&eacute; ajout&eacute; : <a href='" + lien + "'>" + this.getTuppleID() + "</a>");
            this.setNotifAWhere(" and idrole in('"+ ConstanteSavonnerie.ROLE_CG+"')");
        }
        if (role.equalsIgnoreCase(ConstanteSavonnerie.ROLE_CG)) {
            this.setEtat(ConstanteSavonnerie.VALIDERCG);
            this.setMessageNotif("Un nouveau bon de commande a &eacute;t&eacute; ajout&eacute; : <a href='" + lien + "'>" + this.getTuppleID() + "</a>");
            this.setNotifAWhere(" and idrole in('"+ ConstanteSavonnerie.ROLE_DG+"')");
        }
        if (role.equalsIgnoreCase(ConstanteSavonnerie.ROLE_DG))
            this.setEtat(ConstanteEtat.getEtatValider());

        return super.validerObject(u, c);
    }
}
