package faturefournisseur;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.ClassMere;
import budget.UtilisateurService;
import faturefournisseur.historique.HistoriqueValidationDmdAchat;
import faturefournisseur.proforma.ProformaFournisseur;
import faturefournisseur.proforma.ProformaFournisseurDetails;
import faturefournisseur.proforma.ProformaFournisseurDetailsCpl;
import faturefournisseur.service.Service;
import historique.MapUtilisateur;
import produits.Ingredients;
import utilitaire.ConstanteEtat;
import utilitaire.UtilDB;
import utils.ConstanteSavonnerie;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Vector;

import static utils.ConstanteSavonnerie.identifierRole;

public class DmdAchat extends ClassMere {
    private String id;
    private Date daty;
    private String fournisseur;
    private String remarque , destinataire;

    private Date dateLimite;

    private String idMagasin;

    private String idCategorie;

    private String idObjet;
    private int echeance;
    private Date dateEcheance;
    private String idPriorite;

    public String getIdPriorite() {
        return idPriorite;
    }

    public void setIdPriorite(String idPriorite) {
        this.idPriorite = idPriorite;
    }

    public int getEcheance() {
        return echeance;
    }

    public void setEcheance(int echeance) {
        this.echeance = echeance;
    }

    public Date getDateEcheance() {
        return dateEcheance;
    }

    public void setDateEcheance(Date dateEcheance) {
        this.dateEcheance = dateEcheance;
    }

    public DmdAchat() throws Exception {
        this.setNomTable("DMDACHAT");
        this.setLiaisonFille("idmere");
        this.setNomClasseFille("faturefournisseur.DmdAchatFille");
    }

    public String getDestinataire() {
        return destinataire;
    }

    public void setDestinataire(String destinataire) {
        this.destinataire = destinataire;
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

    public String getIdCategorie() {
        return idCategorie;
    }

    public void setIdCategorie(String idCategorie) {
        this.idCategorie = idCategorie;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date date) {
        this.daty = date;
    }

    public String getFournisseur() {
        return fournisseur;
    }

    public void setFournisseur(String fournisseur) {
        this.fournisseur = fournisseur;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getIdObjet() {
        return idObjet;
    }

    public void setIdObjet(String idObjet) {
        this.idObjet = idObjet;
    }

    public void retourDirection(Connection c) throws Exception {
        boolean canClose = false;
        try {
            if (c == null) {
                canClose = true;
                c = new UtilDB().GetConn();
            }
            updateEtat(ConstanteSavonnerie.VALIDERCHEFFAB, getId(), c);
        } finally {
            if (canClose) {
                if (c != null) {
                    c.close();
                }
            }
        }
    }

    public FactureFournisseurDetails[] getFactureFournisseurDetails(Connection c) throws Exception {
        int indice = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                indice = 1;
            }
            DmdAchatFille[] dmdAchatFille = (DmdAchatFille[])this.getFille("DMDACHATFILLE",c,"");
            FactureFournisseurDetails[] factureFoDetails = new  FactureFournisseurDetails[dmdAchatFille.length];

            for (int i = 0; i < dmdAchatFille.length; i++) {
                Ingredients ing = (Ingredients)new Ingredients().getById(dmdAchatFille[i].getIdproduit(),"AS_INGREDIENTS",c);
                factureFoDetails[i] = new FactureFournisseurDetails();
                factureFoDetails[i].setIdProduit(dmdAchatFille[i].getIdproduit());
                factureFoDetails[i].setPu(dmdAchatFille[i].getPu());
                factureFoDetails[i].setQte(dmdAchatFille[i].getQuantite());
                factureFoDetails[i].setTva(dmdAchatFille[i].getTva());
                factureFoDetails[i].setIdDevise("AR");
                factureFoDetails[i].setCompte(ing.getCompte_achat());
            }
            return factureFoDetails;
        }catch (Exception ex) {
            ex.printStackTrace();
            throw ex;
        }finally{
            if(indice == 1 && c!=null)c.close();
        }
    }

    public ProformaFournisseur[] getProformaFournisseurValideNonGenere(Connection c) throws Exception {
        ProformaFournisseur pro = new ProformaFournisseur();
        pro.setIdOrigine(getId());
        pro.setNomTable("proformafournisseur_non_genere");

        return (ProformaFournisseur[]) CGenUtil.rechercher(pro, null, null, c, "");
    }

    public void genererBcMultiple(Connection c) throws Exception {
        for (ProformaFournisseur pro : getProformaFournisseurValideNonGenere(c)) {
            pro.genererBc(c);
        }
    }

    public As_BonDeCommande_Fille[] getBonDeCommandeDetails(Connection c) throws Exception {
        int indice = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                indice = 1;
            }
            DmdAchatFille[] dmdAchatFille = (DmdAchatFille[])this.getFille("DMDACHATFILLE",c,"");
            As_BonDeCommande_Fille[] factureFoDetails = new  As_BonDeCommande_Fille[dmdAchatFille.length];

            for (int i = 0; i < dmdAchatFille.length; i++) {
//                Ingredients ing = (Ingredients)new Ingredients().getById(dmdAchatFille[i].getIdproduit(),"AS_INGREDIENTS",c);
                factureFoDetails[i] = new As_BonDeCommande_Fille();
                factureFoDetails[i].setProduit(dmdAchatFille[i].getIdproduit());
                factureFoDetails[i].setPu(dmdAchatFille[i].getPu());
                factureFoDetails[i].setQuantite(dmdAchatFille[i].getQuantite());
                factureFoDetails[i].setTva(dmdAchatFille[i].getTva());
                factureFoDetails[i].setIdDevise("AR");
                factureFoDetails[i].setTauxDeChange(1);
                factureFoDetails[i].setProduitLib(dmdAchatFille[i].getDesignation());
            }
            return factureFoDetails;
        }catch (Exception ex) {
            ex.printStackTrace();
            throw ex;
        }finally{
            if(indice == 1 && c!=null)c.close();
        }
    }


    public ProformaFournisseurDetails[] getProformaFournisseurDetails(Connection c) throws Exception {
        int indice = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                indice = 1;
            }
            DmdAchatFille[] dmdAchatFille = (DmdAchatFille[])this.getFille("DMDACHATFILLE",c,"");
            ProformaFournisseurDetails[] factureFoDetails = new  ProformaFournisseurDetails[dmdAchatFille.length];

            for (int i = 0; i < dmdAchatFille.length; i++) {
//                Ingredients ing = (Ingredients)new Ingredients().getById(dmdAchatFille[i].getIdproduit(),"AS_INGREDIENTS",c);
                factureFoDetails[i] = new ProformaFournisseurDetails();
                factureFoDetails[i].setProduit(dmdAchatFille[i].getIdproduit());
                factureFoDetails[i].setPu(dmdAchatFille[i].getPu());
                factureFoDetails[i].setQuantite(dmdAchatFille[i].getQuantite());
                factureFoDetails[i].setTva(dmdAchatFille[i].getTva());
                factureFoDetails[i].setIdDevise("AR");
                factureFoDetails[i].setTauxdechange(1);
//                factureFoDetails[i].setProduitLib(dmdAchatFille[i].getDesignation());
            }
            return factureFoDetails;
        }catch (Exception ex) {
            ex.printStackTrace();
            throw ex;
        }finally{
            if(indice == 1 && c!=null)c.close();
        }
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("DMDA", "GETSEQDMDACHAT");
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

//    @Override
//    public String[] getRoleValidation() {
//        return new String[]{"cheffab", "respachat", "cg","dg"};
//    }

    @Override
    public Object validerObject(MapUtilisateur u, Connection c) throws Exception {
        String role = u.getIdrole();
        UtilisateurService us = new UtilisateurService();
        us.setRefuser(u.getRefuser());
        us = us.getUserService(c);
        this.setRoleValidation(new String[0]);
        String lien = "?but=facturefournisseur/dmdachat/dmdachat-fiche.jsp&id=" + this.getTuppleID();

        boolean initiateur = role.equalsIgnoreCase(ConstanteSavonnerie.ROLE_ACHAPPROV);
        boolean chefdep = role.equalsIgnoreCase(ConstanteSavonnerie.ROLE_CHEF_DEP);
        Service[] services = new Service().servicesImpliques(this.getService(), this.getDestinataire());
        boolean directionSource = us.getIdDepartement() != null && us.getIdDepartement().equalsIgnoreCase(services[0].getDepartement());
        boolean directionCible = us.getIdDepartement() != null && us.getIdDepartement().equalsIgnoreCase(services[1].getDepartement());

        if (initiateur && this.getEtat() <= ConstanteEtat.getEtatCreer()){
            this.setEtat(ConstanteSavonnerie.VALIDERACHAPPROV);
            this.setMessageNotif("Une nouvelle demande d'achat aura besoin de votre validation : <a href='" + lien + "'>" + this.getTuppleID() + "</a>");
            this.setNotifAWhere(" and idrole in('"+ConstanteSavonnerie.ROLE_CHEF_DEP+"') and idService = '"+this.getService()+"'");
        } else if(chefdep && this.getEtat() <= ConstanteSavonnerie.VALIDERACHAPPROV) {
            this.setEtat(ConstanteSavonnerie.VALIDERCHEFDEP);
            this.setMessageNotif("Une nouvelle demande d'achat aura besoin de votre validation : <a href='" + lien + "'>" + this.getTuppleID() + "</a>");
            this.setNotifAWhere(" and idDepartement = '"+services[0].getDepartement()+"'");
        } else if (directionSource && this.getEtat() <= ConstanteSavonnerie.VALIDERCHEFDEP){
            if (services[0].getCompte().equals(services[1].getCompte())){
                this.setEtat(ConstanteEtat.getEtatValider());
            }else{
                this.setEtat(ConstanteSavonnerie.VALIDERDIRSOURCE);
                this.setMessageNotif("Une nouvelle demande d'achat nécessite l'ajout de proformas : <a href='" + lien + "'>" + this.getTuppleID() + "</a>");
                this.setNotifAWhere(" and idrole in('"+ConstanteSavonnerie.ROLE_ACHAPPROV+"') and idService = '"+this.getDestinataire()+"'");

                this.creerNotification(u.getTuppleID(), c);

                this.setMessageNotif("Une nouvelle demande d'achat aura besoin de votre validation : <a href='" + lien + "'>" + this.getTuppleID() + "</a>");
                this.setNotifAWhere(" and idrole in('"+ConstanteSavonnerie.ROLE_CHEF_DEP+"') and idService = '"+this.getDestinataire()+"'");
            }
        } else if (chefdep && this.getEtat() == ConstanteSavonnerie.VALIDERDIRSOURCE) {
            this.setEtat(ConstanteSavonnerie.VALIDERCHEFDEPCIBLE);
            this.setMessageNotif("Une nouvelle demande d'achat aura besoin de votre validation : <a href='" + lien + "'>" + this.getTuppleID() + "</a>");
            this.setNotifAWhere(" and idDepartement = '"+services[1].getDepartement()+"'");
        } else if (directionCible && this.getEtat() == ConstanteSavonnerie.VALIDERCHEFDEPCIBLE) {
            this.setEtat(ConstanteEtat.getEtatValider());
        }

        HistoriqueValidationDmdAchat h = this.genererHistoriqueValidation(u);
        h.createObject(u, c);
        return super.validerObject(u, c);
    }

    public HistoriqueValidationDmdAchat genererHistoriqueValidation(MapUtilisateur u)throws Exception{
        HistoriqueValidationDmdAchat h = new HistoriqueValidationDmdAchat();
        h.setNomTable("HISTORIQUEVALIDATIONDMDACHAT");
        h.setIdDmdAchat(this.getId());
        h.setRefuser(""+u.getRefuser());
        h.setNomuser(u.getNomuser());
        h.setDaty(Utilitaire.dateDuJourSql());
        h.setHeure(Utilitaire.heureCourante());
        return h;
    }

    public ProformaFournisseur[] validerProformas(MapUtilisateur u, Connection c) throws Exception {
        ProformaFournisseur[] proformaFournisseurs = (ProformaFournisseur[]) CGenUtil.rechercher(new ProformaFournisseur(), null, null, c, " AND idOrigine='"+this.getIdObjet()+"'");
        System.out.println("Nombre de proforma a valider : "+proformaFournisseurs.length);
        for (ProformaFournisseur proformaFournisseur : proformaFournisseurs) {
            proformaFournisseur.validerObject(u, c);
            System.out.println(">>> Proforma validée : "+proformaFournisseur.getId()+" | Etat : "+proformaFournisseur.getEtat());
        }
        return proformaFournisseurs;
    }

    public ProformaFournisseur[] validerProformas(MapUtilisateur u) throws Exception {
        try {
            Connection c = new UtilDB().GetConn();
            return validerProformas(u, c);
        } catch (Exception ex) {
            ex.printStackTrace();
            throw ex;
        }
    }

    public void checkSelectionValidation(ProformaFournisseurDetails[] proformaFournisseurDetails, DmdAchatFille[] dmdAchatFilles)throws Exception{
        for (DmdAchatFille dmdAchatFille : dmdAchatFilles) {
            boolean exist = false;
            for (ProformaFournisseurDetails proformaFournisseurDetail : proformaFournisseurDetails) {
                if(dmdAchatFille.getIdproduit().equals(proformaFournisseurDetail.getProduit())){
                    exist = true;
                    break;
                }
            }
            if(!exist){
                throw new Exception("Le produit "+dmdAchatFille.getIdproduit()+" n'est pas encore s\u00E9l\u00E9ctionn\u00E9 dans un proforma");
            }
        }
    }

    public boolean estAvecProformaDetailsValide(Connection c) throws Exception {
        boolean canClose = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                canClose = true;
            }
            ProformaFournisseurDetailsCpl p = new ProformaFournisseurDetailsCpl();
            p.setIdOrigineMere(this.getId());
            p.setNomTable("comparaisonprixproforma");
            ProformaFournisseurDetailsCpl[] proformas = (ProformaFournisseurDetailsCpl[]) CGenUtil.rechercher(p, null, null, c, " and etatFille = '"+ConstanteEtat.getEtatValider()+"'");
            return proformas.length > 0;
        } finally {
            if (canClose) c.close();
        }
    }

    public As_BonDeCommande[] genererBcProformaSelectionne(String u, Connection c) throws Exception{
        int indice = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                indice = 1;
            }

            ProformaFournisseurDetailsCpl p = new ProformaFournisseurDetailsCpl();
            p.setIdOrigineMere(this.getId());
            p.setNomTable("comparaisonprixproforma");
            ProformaFournisseurDetailsCpl[] proformas = (ProformaFournisseurDetailsCpl[]) CGenUtil.rechercher(p, null, null, c, " and etatFille = '"+ConstanteEtat.getEtatValider()+"'");
            ProformaFournisseurDetails[] proformaFournisseurDetails = new ProformaFournisseurDetails[proformas.length];
            for (int i = 0; i < proformaFournisseurDetails.length; i++) {
                proformaFournisseurDetails[i] = proformas[i];
                proformaFournisseurDetails[i].setEtat(ConstanteEtat.getEtatValider());
            }

            DmdAchatFille d = new DmdAchatFille();
            d.setIdmere(this.getId());
            DmdAchatFille[] ds = (DmdAchatFille[]) CGenUtil.rechercher(d, null, null, c, "");

            this.checkSelectionValidation(proformas, ds);

            LinkedHashMap<String, ClassMAPTable[]> h = AdminGen.toHashLinked(proformaFournisseurDetails, "idMere");
            As_BonDeCommande[] as = new As_BonDeCommande[h.size()];
            int i = 0;
            for (String key : h.keySet()) {
                System.out.println(key);
                ProformaFournisseur proforma = (ProformaFournisseur)
                        new ProformaFournisseur().getById(key, "PROFORMAFOURNISSEUR", c);

                ClassMAPTable[] raw = h.get(key);
                ProformaFournisseurDetails[] proformaDetails =
                        new ProformaFournisseurDetails[raw.length];
                for (int j = 0; j < raw.length; j++) {
                    proformaDetails[j] = (ProformaFournisseurDetails) raw[j];
                }

                as[i] = proforma.genererBc(c, proformaDetails);
                as[i].createObject(u, c);
                i++;
            }
            return as;
        }catch (Exception ex) {
            ex.printStackTrace();
            throw ex;
        }finally{
            if(indice == 1 && c!=null)c.close();
        }
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {

        if(this.getService() == null || this.getService().equalsIgnoreCase("")){
            throw new Exception("D\u00E9partement vide. Cause: D\u00E9partement vide pour l'utilisateur");
        }

        construirePK(c);
        String lien = "?but=facturefournisseur/dmdachat/dmdachat-fiche.jsp&id=" + this.getTuppleID();
        this.setMessageNotif("Une nouvelle demande d'achat a &eacute;t&eacute; cr&eacute;&eacute;e : <a href='" + lien + "'>" + this.getTuppleID() + "</a>");

        String aWhere = " and idrole in('"+ConstanteSavonnerie.ROLE_CHEF_DEP+"') ";
        boolean estServiceCible = ConstanteSavonnerie.SERVICE_MTE.equalsIgnoreCase(this.getDestinataire())
            || ConstanteSavonnerie.SERVICE_MTM.equalsIgnoreCase(this.getDestinataire())
            || ConstanteSavonnerie.SERVICE_MTCH.equalsIgnoreCase(this.getDestinataire())
            || ConstanteSavonnerie.SERVICE_BMT.equalsIgnoreCase(this.getDestinataire())
            || ConstanteSavonnerie.SERVICE_DTAU.equalsIgnoreCase(this.getDestinataire());

        if (estServiceCible) {
            aWhere = aWhere + " and idService in ('"+this.getDestinataire()+"','"+ConstanteSavonnerie.SERVICE_DMT+"')";
        } else {
            aWhere = aWhere + " and idService = '"+this.getDestinataire()+"'";
        }

        if (!this.getDestinataire().equalsIgnoreCase(this.getService())) {
            aWhere = " and idrole in ('"+ConstanteSavonnerie.ROLE_RESPACHAT+"') and idService = '"+this.getService() + "'";
        }
        this.setNotifAWhere(aWhere);

        DmdAchat created = (DmdAchat) super.createObject(u, c);
        MapUtilisateur[] utilisateur = (MapUtilisateur[]) CGenUtil.rechercher(new MapUtilisateur(), null, null, c, " and refuser = "+u);
        HistoriqueValidationDmdAchat h = this.genererHistoriqueValidation(utilisateur[0]);
        h.createObject(u, c);

        return created;
    }

}
