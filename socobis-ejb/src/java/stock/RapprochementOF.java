package stock;

import chatbot.AiColDesc;
import chatbot.AiTabDesc;
import chatbot.ClassIA;
import vente.BonDeCommande;

@AiTabDesc("La structure de ma table de rapprochement de Fabrication théorique et pratique. Si l'utilisateur parle d'ecart ou rapprochemet c'est la bonne table, la colonne 'sortie' c'est la qte pratique, la colonne nombrepargroupe n'existe pas,la colonne IDPRODUIT l'id d'un produit spécifique,  ")
public class RapprochementOF extends MvtStockFilleTheorique implements ClassIA {

    @AiColDesc("ecart montant theorique et pratique, n'oublie pas l'ABS si c'est une difference qu'on recherche ou un ecart")
    double ecartmontant;
    @AiColDesc("ecart quantite theorique et pratique, n'oublie pas l'ABS si c'est une difference qu'on recherche ou un ecart")
    double ecartqte;
    @AiColDesc("ecart prix unitaire theorique et pratique, n'oublie pas l'ABS si c'est une difference qu'on recherche ou un ecart")
    double ecartpu;
    @Override
    public String getNomTableIA() {
        return "v_rapprochement_of";
    }
    @Override
    public String getUrlListe() {
        return "/savonnerie/pages/module.jsp?but=fabrication/fabrication-liste.jsp&currentMenu=MENUDYN0304009";
    }
    @Override
    public String getUrlAnalyse() {
        return "/savonnerie/pages/module.jsp?but=fabrication/fabrication-liste.jsp&currentMenu=MENUDYN0304009";
    }
    @Override
    public String getUrlSaisie() {
        return "";
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


    public RapprochementOF() throws Exception {
        super();
        this.setNomTable("v_rapprochemennt_of");
    }

    @Override
    public double getEcartmontant() {
        return ecartmontant;
    }

    public void setEcartmontant(double ecartmontant) {
        this.ecartmontant = ecartmontant;
    }

    @Override
    public double getEcartqte() {
        return ecartqte;
    }

    public void setEcartqte(double ecartqte) {
        this.ecartqte = ecartqte;
    }

    @Override
    public double getEcartpu() {
        return ecartpu;
    }

    public void setEcartpu(double ecartpu) {
        this.ecartpu = ecartpu;
    }
}
