package vente;

import chatbot.AiTabDesc;
import chatbot.ClassIA;

import java.io.Serializable;
import java.text.DecimalFormat;

@AiTabDesc("La structure de ma table de bon de commande, Dans ma table de bon de commande ou BC, on parle de OF (ordre de fabrication), FAB (fabrication) et LIVRE (livraison) de produits, la colonne nombrepargroupe n'existe pas, ne l'utilise jamais: ")
public class BonDeCommandeFIlleCpl extends BonDeCommandeFille implements ClassIA {
    String produitLib, categorieingredient;
    double qteOfRestante;
    double qteFabRestante;
    double qteNonLivre;
    String compte, uniteLib;
    double qtereste,montanttotal,montantremise,montanttva, montantdelaremise, montantristourne, fraistransport, poidstotal;

    private double punet, montantht,montantttc;

    public String getCategorieingredient() {
        return categorieingredient;
    }

    public void setCategorieingredient(String categorieingredient) {
        this.categorieingredient = categorieingredient;
    }

    public double getMontantdelaremise() {
        return montantdelaremise;
    }

    public void setMontantdelaremise(double montantdelaremise) {
        this.montantdelaremise = montantdelaremise;
    }

    public double getFraistransport() {
        return fraistransport;
    }

    public void setFraistransport(double fraistransport) {
        this.fraistransport = fraistransport;
    }

    public double getPoidstotal() {
        return poidstotal;
    }

    public void setPoidstotal(double poidstotal) {
        this.poidstotal = poidstotal;
    }

    public double getPunet() {
        return punet;
    }

    public void setPunet(double punet) {
        this.punet = punet;
    }

    public double getMontantht() {
        return montantht;
    }

    public void setMontantht(double montantht) {
        this.montantht = montantht;
    }

    public double getMontantttc() {
        return montantttc;
    }

    public void setMontantttc(double montantttc) {
        this.montantttc = montantttc;
    }

    public String getUniteLib() {
        return uniteLib;
    }

    public void setUniteLib(String uniteLib) {
        this.uniteLib = uniteLib;
    }

    public double getMontantremise() {
        return montantremise;
    }

    public void setMontantremise(double montantremise) {
        this.montantremise = montantremise;
    }

    public double getMontanttva() {
        return montanttva;
    }

    public void setMontanttva(double montanttva) {
        this.montanttva = montanttva;
    }

    public double getMontanttotal() {
        return montanttotal;
    }

    public void setMontanttotal(double montanttotal) {
        this.montanttotal = montanttotal;
    }

    @Override
    public String getNomTableIA() {
        return "BC_CLIENT_FILLE_CPL_LIB_VISEE";
    }
    @Override
    public String getUrlListe() {
        return "/savonnerie/pages/module.jsp?but=vente/bondecommande-liste.jsp&currentMenu=MNDN000000001072";
    }
    @Override
    public String getUrlAnalyse() {
        return "/savonnerie/pages/module.jsp?but=vente/bondecommande-liste.jsp&currentMenu=MNDN000000001072";
    }
    @Override
    public String getUrlSaisie() {
        return "/savonnerie/pages/module.jsp?but=vente/bondecommande/bondecommande-saisie.jsp&currentMenu=MNDN000000001071";
    }
    @Override
    public ClassIA getClassListe() {
        return this;
    }
    @Override
    public ClassIA getClassAnalyse() {
        return this;
    }
    @Override
    public ClassIA getClassSaisie() {
        return new BonDeCommande();
    }

    public BonDeCommandeFIlleCpl() throws Exception {
        super();
        setNomTable("BC_CLIENT_FILLE_CPL_LIB");
    }

    public String getProduitLib() {
        return produitLib;
    }

    public void setProduitLib(String produitLib) {
        this.produitLib = produitLib;
    }

    public double getQteOfRestante() {
        return qteOfRestante;
    }

    public void setQteOfRestante(double qteOfRestante) {
        this.qteOfRestante = qteOfRestante;
    }

    public double getQteFabRestante() {
        return qteFabRestante;
    }

    public void setQteFabRestante(double qteFabRestante) {
        this.qteFabRestante = qteFabRestante;
    }

    public double getQteNonLivre() {
        return qteNonLivre;
    }

    public void setQteNonLivre(double qteNonLivre) {
        this.qteNonLivre = qteNonLivre;
    }

    @Override
    public void setIdDevise(String idDevise) {
        super.setIdDevise(idDevise);
    }

    public double getMontant() {
        return this.getPu() * this.getQuantite();
    }
    public String getCompte() {
        return compte;
    }
    public void setCompte(String compte) {
        this.compte = compte;
    }

    public double getMontantristourne() {
        return montantristourne;
    }

    public void setMontantristourne(double montantristourne) {
        this.montantristourne = montantristourne;
    }

    public double getQtereste() {
        return qtereste;
    }
    public void setQtereste(double qtereste) {
        this.qtereste = qtereste;
    }
    public VenteDetailsLib createVenteFilleLib() throws Exception {
        if(this.getQtereste()<=0) return null;
        try {
            VenteDetailsLib ligne = new VenteDetailsLib();
            ligne.setIdProduit(this.getProduit());
            ligne.setQte(this.getQtereste());
            ligne.setPu(this.getPu());
            ligne.setTva(this.getTva());
            ligne.setIdDevise(this.getIdDevise());
            ligne.setDesignation(this.getProduitLib());
            ligne.setCompte(this.getCompte());
            ligne.setIdbcfille(this.getId());
            ligne.setRemise(this.getRemise());
            ligne.setUnitelib(this.getUniteLib());
            ligne.setUnite(this.getUnite());
            ligne.setMontantht((this.getPu() - (this.getPu() * this.getRemise() / 100)) * this.getQtereste());
            ligne.setPunet(this.getPu() - (this.getPu() * this.getRemise() / 100));
            ligne.setRistourne(getRistourne());
            ligne.setTauxDeChange(this.getTauxdechange());

            double montantttc = ligne.getMontantht() + (ligne.getMontantht() * (this.getTva() / 100));
            ligne.setMontantttc(montantttc);
//            ligne.setMontantttc((this.getPu() - (this.getPu() * this.getRemise() / 100) + ((this.getPu() * this.getTva() / 100)))* this.getQtereste());
            return ligne;
        }catch(Exception ex) {
            ex.printStackTrace();
            throw ex;
        }

    }
}
