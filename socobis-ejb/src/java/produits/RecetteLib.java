package produits;

import bean.CGenUtil;
import bean.TypeObjet;
import utilitaire.UtilDB;

import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.Field;
import java.sql.Connection;
import java.util.HashMap;

public class RecetteLib extends Recette {
    private String libelleingredient, idunite, valunite, libelleproduit, categorieingredient, mere;
    private double qteacheter, quantiteparpack, restepositive;
    private double qtelimite;
    private String compte_vente, compte_achat;

    public String getCompte_achat() {
        return compte_achat;
    }

    public void setCompte_achat(String compte_achat) {
        this.compte_achat = compte_achat;
    }

    public String getCompte_vente() {
        return compte_vente;
    }

    public void setCompte_vente(String compte_vente) {
        this.compte_vente = compte_vente;
    }

    public double getQtelimite(){
        return qtelimite;
    }

    public void setQtelimite(double qtelimite){
        this.qtelimite=qtelimite;
    }

    public String getMere() {
        return mere;
    }

    public void setMere(String mere) {
        this.mere = mere;
    }

    public String getCategorieingredient() {
        return categorieingredient;
    }

    public void setCategorieingredient(String categorieingredient) {
        this.categorieingredient = categorieingredient;
    }

    public String getValunite() {
        return valunite;
    }

    public void setValunite(String valunite) {
        this.valunite = valunite;
    }

    public RecetteLib() {
        this.setNomTable("AS_RECETTE_LIBCOMPLET");
    }

    public String getLibelleingredient() {
        return libelleingredient;
    }

    public void setLibelleingredient(String libelleingredient) {
        this.libelleingredient = libelleingredient;
    }

    public String getIdunite() {
        return idunite;
    }

    public void setIdunite(String idunite) {
        this.idunite = idunite;
    }

    public String getLibelleproduit() {
        return libelleproduit;
    }

    public void setLibelleproduit(String libelleproduit) {
        this.libelleproduit = libelleproduit;
    }

    public double getQuantiteparpack() {
        return quantiteparpack;
    }

    public void setQuantiteparpack(double quantiteparpack) {
        this.quantiteparpack = quantiteparpack;
    }

    public double getQteacheter() {
        return qteacheter;
    }

    public void setQteacheter(double qteacheter) {
        this.qteacheter = qteacheter;
    }

    public double getRestepositive() {
        return this.restepositive;
    }

    public void setRestepositive(double restepositive) {
        this.restepositive = restepositive;
    }

    public RecetteLib[] getRecette(String idproduit, Connection c) throws Exception {
        return (RecetteLib[]) CGenUtil.rechercher(new RecetteLib(), null, null, c,
                " and idproduits = '" + idproduit + "'");

    }

    public String makeWhereBesoin(String query, HttpServletRequest request) throws Exception {
        String sql = query;
        try {
            Field[] field = this.getFieldList();
            for (int i = 0; i < field.length; i++) {
                String colonne = "" + field[i].getName();

                if (request.getParameter(colonne) != null && !request.getParameter(colonne).isEmpty()
                        && colonne.compareToIgnoreCase("id") != 0) {

                    sql += " and upper(" + colonne + ")";
                    if (field[i].getType() == String.class) {
                        sql += " like upper('%" + request.getParameter(colonne) + "%')";
                    } else {
                        sql += " =" + request.getParameter(colonne);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
        return sql;
    }

    public TypeObjet[] getUnite(Connection c) throws Exception {
        TypeObjet unite = new TypeObjet();
        unite.setNomTable("AS_UNITE");
        return (TypeObjet[]) CGenUtil.rechercher(unite, null, null, c, "");
    }

    public HashMap getRecetteUniter(String idproduit) throws Exception {
        HashMap obj = new HashMap();
        UtilDB util = new UtilDB();
        Connection c = null;
        try {
            try {
                c = util.GetConn();
                RecetteLib[] liste = getRecette(idproduit, c);
                TypeObjet[] lsUniter = getUnite(c);
                obj.put("recette", liste);
                obj.put("unite", lsUniter);
            } catch (Exception e) {
                e.printStackTrace();
                throw e;
            }
            return obj;
        } finally {
            if (c != null) {
                c.close();
            }
        }
    }
}
