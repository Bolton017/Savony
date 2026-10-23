package panier;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;
import produits.Ingredients;
import utilitaire.ConstanteEtat;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteAsync;
import utils.ConstanteSavonnerie;
import utils.ConstanteSocobis;
import vente.BonDeCommande;
import vente.BonDeCommandeFille;

import java.sql.Connection;
import java.sql.Date;
import java.sql.Statement;
import java.util.LinkedHashMap;

public class Panier extends ClassEtat {
    private String id;
    private String idClient;
    private double qte;
    private String idProduit;
    private double pu;
    private String idUnite;
    private Date daty;

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public double getMontantCalc() {
        return this.getPu() * this.getQte();
    }

    public String getIdUnite() {
        return idUnite;
    }

    public void setIdUnite(String idUnite) {
        this.idUnite = idUnite;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) throws Exception{
        if (this.getMode().equals("modif") && pu < 0) {
            throw new Exception("Pu ne peut pas \u00EAtre inf\u00E9rieur \u00E0 0");
        }
        this.pu = pu;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdClient() {
        return idClient;
    }

    public void setIdClient(String idClient) {
        this.idClient = idClient;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) throws Exception {
        if (this.getMode().equals("modif") && qte <= 0) {
            throw new Exception("Quantit\u00E9 doit \u00EAtre sup\u00E9rieur \u00E0 0");
        }
        this.qte = qte;
    }

    public String getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(String idProduit) {
        this.idProduit = idProduit;
    }

    public Panier() {
        this.setNomTable("PANIER");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PAN","GETSEQPANIER");
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

    public String getCleGroupe() {
        return getIdProduit() + "|" + getIdUnite() + "|" + getPu();
    }

    public BonDeCommandeFille[] genererBCClientFille(Panier[] paniers) throws Exception {
        LinkedHashMap<String, ClassMAPTable[]> groupes = AdminGen.toHashLinked(paniers, "cleGroupe");
        BonDeCommandeFille[] bcFilles = new BonDeCommandeFille[groupes.size()];
        int i = 0;
        for (ClassMAPTable[] g : groupes.values()) {
            Panier p = (Panier) g[0];
            double qte = AdminGen.calculSommeDouble(g, "qte");
            BonDeCommandeFille f = new BonDeCommandeFille();
            f.setProduit(p.getIdProduit());
            f.setQuantite(qte);
            f.setPu(p.getPu());
            f.setIdDevise("AR");
            f.setUnite(p.getIdUnite());
            f.setMontant(qte * p.getPu());
            f.setTauxdechange(1);
            bcFilles[i++] = f;
        }
        return bcFilles;
    }

    public void genererBCClient(String u,Connection c,Panier[] paniers) throws Exception {
        BonDeCommande bc = new BonDeCommande();
        bc.setDesignation("Bon de commande commercial : "+Utilitaire.dateDuJour());
        bc.setDaty(Utilitaire.dateDuJourSql());
        bc.setIdClient(this.getIdClient());
        bc.setIdDevise("AR");
        bc.setModepaiement(ConstanteAsync.PAIEMENT_ESPECE);
        bc.setIdMagasin(ConstanteSocobis.MAGASIN);
        bc.setModelivraison(1);
        bc.setFraislivraison(0);
        bc.setTypefraistransport(0);
        bc.setCommercial(u);
        BonDeCommandeFille[] filles = genererBCClientFille(paniers);
        Ingredients[] ingredients = (Ingredients[]) CGenUtil.rechercher(new Ingredients(),null,null,c,"");
        for (BonDeCommandeFille bcfille : filles) {
            Ingredients ing = new Ingredients();
            ing.setId(bcfille.getProduit());
            bcfille.setTva(ing.getIngredient(ingredients).getTva());
        }
        bc.setFille(filles);
        bc.setEtat(ConstanteEtat.getEtatCreer());
        bc.createObject(u,c);
    }

    public void validerObjectMultiple(String u, Connection c, Panier[] paniers) throws Exception {
        boolean canClose = false;
        Statement st = null;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                canClose = true;
            }
            st = c.createStatement();
            for (Panier p : paniers) {
                p.validerObjectBatch(u,st);
            }
            genererBCClient(u,c,paniers);
            st.executeBatch();
        } finally {
            try {
                if (st != null) st.close();
            } finally {
                if (canClose) c.close();
            }
        }
    }
}

