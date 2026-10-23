package vente;

import bean.*;
import chatbot.FilleOcr;
import equivalenceproduit.EquivalenceProduit;
import produits.Ingredients;

import java.sql.Connection;
import fabrication.Of;
import fabrication.OfFille;
import fabrication.Fabrication;
import fabrication.FabricationFille;
import utilitaire.UtilDB;
import vente.Carton;
import vente.CartonFille;

public class BonDeCommandeFille extends ClassFille {
    private String id, produit, idbc, unite;
    private double quantite,qteOf ,qteFab ,qteLivre, qteFacture;
    private double pu;
    private double montant;
    private double tva;
    private double remise;
    private double reste, ristourne;
    private String idDevise;
    private double taux,puRevient;
    String libelleProduit;
    String designation;
    double tauxdechange;
    public void calculerRevient(Connection c) throws Exception {
        if(this.getProduit()==null)setPuRevient(0);
        Ingredients i=(Ingredients)new Ingredients().getById(this.getProduit(),null,c);
        if(i==null)setPuRevient(0);
        if(i.getCompose()==0)
        {
            this.setPuRevient(i.getPu());
            return;
        }
        double revient=i.calculerRevient(c);
        this.setPuRevient(revient);
    }
    public double getMontantRevient()
    {
        return this.getQuantite()*this.getPuRevient();
    }
    public double getPuRevient() {
        return puRevient;
    }
    public double getMontantCalc()
    {
        return this.getQuantite()*this.getPu();
    }
    public double getMargeBruteCalc()
    {
        return this.getMontantCalc()-this.getMontantRevient();
    }

    public void setPuRevient(double puRevient) {
        this.puRevient = puRevient;
    }

    public double getRistourne() {
        return ristourne;
    }

    public void setRistourne(double ristourne) throws Exception {
        if (this.getMode().equals("modif") && (ristourne > 100 || ristourne < 0)) {
            throw new Exception("Ristourne invalide : elle doit \\u00EAtre comprise entre 0 et 100");
        }
        this.ristourne = ristourne;
    }

    public String getLibelleProduit() {
        return libelleProduit;
    }

    public void setLibelleProduit(String libelleProduit) {
        this.libelleProduit = libelleProduit;
    }
    public double getQteOf() {
        return qteOf;
    }

    public void setQteOf(double qteOf) {
        this.qteOf = qteOf;
    }

    public double getQteFab() {
        return qteFab;
    }

    public void setQteFab(double qteFab) {
        this.qteFab = qteFab;
    }

    public double getQteLivre() {
        return qteLivre;
    }

    public void setQteLivre(double qteLivre) {
        this.qteLivre = qteLivre;
    }
    public double getResteOf() throws Exception{
        double qte = this.getQuantite() - this.getQteOf();
        return qte;
    }
    public double getResteFab() throws Exception{
        double qte = this.getQuantite() - this.getQteFab();
        return qte;
    }
    public double getResteLivre()throws Exception{
        double qte = this.getQuantite() - this.getQteLivre();
        return qte;
    }

    public static BonDeCommandeFille fromOcr(FilleOcr filleOcr) throws Exception {
        BonDeCommandeFille details = new BonDeCommandeFille();
        details.setQuantite(filleOcr.getQte());
        details.setPu(filleOcr.getPu());
        Ingredients ing = new Ingredients();
        ing.setId(filleOcr.getIdProduit());
        Ingredients[] filles = (Ingredients[]) CGenUtil.rechercher(ing,null,null,"");
        if(filles!=null && filles.length>0){
            details.setProduit(filles[0].getId());
        }
        return details;
    }

    public String getDesignation() {
        return designation;
    }
    public void setDesignation(String designation) {
        this.designation = designation;
    }
    public double getTaux() {
        return taux;
    }

    public void setTaux(double taux) {
        this.taux = taux;
    }

    public double getTauxdechange() {
        return tauxdechange;
    }

    public void setTauxdechange(double tauxdechange) {
        this.tauxdechange = tauxdechange;
    }

    public String getIdDevise() {
        return idDevise;
    }

    public void setIdDevise(String idDevise) {
        this.idDevise = idDevise;
    }

    public double getReste() {
        return reste;
    }

    public void setReste(double reste) {
        this.reste = reste;
    }

    public BonDeCommandeFille() throws Exception {
        super.setNomTable("BONDECOMMANDE_CLIENT_FILLE");
        this.setNomClasseMere("vente.BonDeCommande");
        this.setLiaisonMere("idbc");
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("CBCF", "getseqBC_CLIENT_FILLE");
        this.setId(makePK(c));
    }
    public As_BondeLivraisonClientFille genererBLFille() throws Exception{
        As_BondeLivraisonClientFille clientFille = new As_BondeLivraisonClientFille();
        clientFille.setMode("modif");
        clientFille.setProduit(this.getProduit());
        clientFille.setUnite(this.getUnite());
        clientFille.setQuantite(this.getReste());
        clientFille.setIdbc_fille(this.getId());
        return clientFille;
    }
    
    public OfFille genererOfFille() throws Exception{
        OfFille clientFille = new OfFille();
        clientFille.setIdIngredients(this.getProduit());
        clientFille.setQte(this.getResteOf());
        clientFille.setIdBcFille(this.getId());
        clientFille.setIdunite(this.getUnite());
        return clientFille;
    }

    
    public CartonFille genererCartonFille()throws Exception{
        CartonFille cf = new CartonFille();
        cf.setIdIngredient(this.getProduit());
        cf.setQuantite(this.getQuantite());
        cf.setIdBcFille(this.getId());
        return cf;
    }
    
    public FabricationFille genererFabFille() throws Exception {
        FabricationFille clientFille = new FabricationFille();
        clientFille.setIdIngredients(this.getProduit());
        clientFille.setQte(this.getResteFab());
        clientFille.setIdBcFille(this.getId());
        clientFille.setRemarque(this.getUnite());
        return clientFille;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void setLiaisonMere(String liaisonMere) {
        super.setLiaisonMere("idbc");
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getProduit() {
        return this.produit;
    }

    public void setProduit(String produit) {
        this.produit = produit;
    }

    public String getIdbc() {
        return this.idbc;
    }

    public void setIdbc(String idbc) throws Exception {

        this.idbc = idbc;
    }

    public double getQuantite() {
        return this.quantite;
    }

    public void setQuantite(double quantite) throws Exception{
        if(this.getMode().equals("modif")){
            if(quantite<=0){
                throw new Exception("Une des lignes a une qte < 0");
            }
        }
        this.quantite = quantite;
    }

    public double getPu() {
        return this.pu;
    }

    public void setPu(double pu) throws Exception {
        if (this.getMode().equals("modif") && pu < 0) {
            throw new Exception("Le prix unitaire ne peut pas \\u00EAtre inf\\u00E9rieur \\u00E0 0");
        }
        this.pu = pu;
    }

    public double getMontant() {
        return this.montant;
    }

    public void setMontant(double montant) throws Exception{
        if (this.getMode().equals("modif") && montant < 0) {
            throw new Exception("Le prix total ne peut pas \\u00EAtre inf\\u00E9rieur \\u00E0 0");
        }
        this.montant = montant;
    }

    public double getTva() {
        return this.tva;
    }

    public void setTva(double tva) throws Exception {
        if(this.getMode().compareToIgnoreCase("modif")==0)
        {
            if(tva>100||tva<0) throw new Exception("TVA invalide");
        }
        this.tva = tva;
    }

    public String getUnite() {
        return this.unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }

    public double getRemise() {
        return this.remise;
    }

    public void setRemise(double remise) throws Exception{
        if(this.getMode().compareToIgnoreCase("modif")==0)
        {
            if(remise>100||remise<0) throw new Exception("Remise invalide");
        }
        this.remise = remise;
    }
    @Override
    public String getNomClasseMere() {
        return "vente.BonDeCommande";
    }
    @Override
    public String getLiaisonMere() {
        return "idbc";
    }

    public Ingredients getIngedients(String nT, Connection c) throws Exception {
        boolean estOuvert=false;
        try
        {
            if(c==null)
            {
                c=new UtilDB().GetConn();
                estOuvert=true;
            }
            Ingredients retour=(Ingredients) new Ingredients().getById(this.getProduit(),nT,c);
            return retour;
        }
        catch(Exception e)
        {
            throw e;
        }
        finally {
            if(estOuvert==true&&c!=null)c.close();
        }
    }

    public double getQteCarton(Connection c) throws Exception{
        Ingredients ing = this.getIngedients("AS_INGREDIENT_VENTE_LIB", c);
        return EquivalenceProduit.getQteCarton(ing, this.getQuantite(), c);
    }

    public double getQtePieceRestant(Connection c) throws Exception{
        Ingredients ing = this.getIngedients("AS_INGREDIENT_VENTE_LIB", c);
        return EquivalenceProduit.getQtePieceRestant(ing, this.getQuantite(), c);
    }

    public double getQteFacture() {
        return qteFacture;
    }

    public void setQteFacture(double qteFacture) {
        this.qteFacture = qteFacture;
    }
}
