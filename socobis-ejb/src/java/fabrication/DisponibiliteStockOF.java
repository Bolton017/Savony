package fabrication;

import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.ResultatEtSomme;
import produits.Ingredients;
import stock.EtatStock;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;

public class DisponibiliteStockOF extends ClassMAPTable {

    private String id;
    private String idingredients;
    private String libingredients;
    private String unite;
    private String typestock;
    private String categorieingredient;
    private String idMagasinLib;
    private double qteav;
    private double qtetotal;
    private double quantite;
    private double reste;
    private Date daty;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdingredients() {
        return idingredients;
    }

    public void setIdingredients(String idingredients) {
        this.idingredients = idingredients;
    }

    public String getLibingredients() {
        return libingredients;
    }

    public void setLibingredients(String libingredients) {
        this.libingredients = libingredients;
    }

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }

    public String getTypestock() {
        return typestock;
    }

    public void setTypestock(String typestock) {
        this.typestock = typestock;
    }

    public String getCategorieingredient() {
        return categorieingredient;
    }

    public void setCategorieingredient(String categorieingredient) {
        this.categorieingredient = categorieingredient;
    }

    public double getQteav() {
        return qteav;
    }

    public void setQteav(double qteav) {
        this.qteav = qteav;
    }

    public double getQtetotal() {
        return qtetotal;
    }

    public void setQtetotal(double qtetotal) {
        this.qtetotal = qtetotal;
    }

    public double getQuantite() {
        return quantite;
    }

    public void setQuantite(double quantite) {
        this.quantite = quantite;
    }

    public double getReste() {
        return reste;
    }

    public void setReste(double reste) {
        this.reste = reste;
    }

    public String getIdMagasinLib() {
        return idMagasinLib;
    }

    public void setIdMagasinLib(String idMagasinLib) {
        this.idMagasinLib = idMagasinLib;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public DisponibiliteStockOF() throws Exception {
        this.setNomTable("DISPONIBLITESTOCKOF_VIDE");
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public ResultatEtSomme rechercherPage(String[] colInt, String[] valInt, int numPage, String apresWhere,
                                          String[] nomColSomme, Connection c, int npp) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            String daty = Utilitaire.dateDuJour();
            if (valInt != null && valInt.length > 0 && valInt[0] != null && valInt[0].trim().length() > 0) {
                daty = valInt[0];
            }
            String req = requetteDisponibiliteStock(this.getId(), daty, this.getIdMagasinLib(),"as_recetteOf");
            this.setIdMagasinLib(null);
            return CGenUtil.rechercherPage(this, req, numPage, nomColSomme, apresWhere, c, npp);
        } finally {
            if (estOuvert && c != null) {
                c.close();
            }
        }
    }

    public static String requetteDisponibiliteStock(String id, String date, String lancePar, String nTRecette){
        String requette = "select\n" +
                "    a.idIngredients,\n" +
                "    a.libIngredients,\n" +
                "    a.unite,\n" +
                "    a.qteAv,\n" +
                "    a.qteTotal,\n" +
                "    a.quantite,\n" +
                "    a.typestock,\n" +
                "    a.categorieingredient,\n" +
                "    nvl(v.RESTE, 0) as reste,\n" +
                "'"+lancePar+"'"+
                "    AS IDMAGASINLIB\n" +
                "from ( "+Ingredients.getRequetteDecomposerBase(id, nTRecette) + " ) a \n" +
                "left join ( select g.* from (" + EtatStock.getReqEtatStock(date) + ") g where g.IDMAGASINLIB like '%"+lancePar+ "%' ) v on v.IDPRODUIT= a.idIngredients ";
        return  requette;
    }


}

