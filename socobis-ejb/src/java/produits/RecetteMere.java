package produits;

import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.ClassMere;
import utilitaire.UtilDB;

import java.sql.Connection;
import java.sql.Date;

public class RecetteMere extends ClassMere {
    private String id;
    private String idProduit;
    private Date daty;
    private String nomRecette;
    private String version;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }


    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(String idProduit) {
        this.idProduit = idProduit;
    }

    public String getNomRecette() {
        return nomRecette;
    }

    public void setNomRecette(String nomRecette) {
        this.nomRecette = nomRecette;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }



    public RecetteMere() throws Exception {
        this.setNomTable("RECETTE_MERE");
        this.setNomClasseFille("produits.RecetteFille");
        this.setLiaisonFille("idmere");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("RCM","GETSEQRECETTE_MERE");
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

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        RecetteMere mere = (RecetteMere) super.createObject(u, c);
        mere.setId(this.getIdProduit());
        return mere;
    }

    public void validerRecettePrincipale(String u, String idRecetteMere) throws Exception {
        Connection c = null;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            RecetteMere recetteMere = new RecetteMere();
            recetteMere.setId(idRecetteMere);
            RecetteMere[] recetteMeres = (RecetteMere[]) CGenUtil.rechercher(recetteMere, null, null, " ");
            RecetteFille recetteFille = new RecetteFille();
            recetteFille.setIdmere(recetteMeres[0].getId());
            RecetteFille[] recetteFilles = (RecetteFille[]) CGenUtil.rechercher(recetteFille, null, null, " ");
            Recette recette = new Recette();
            recette.setIdproduits(recetteMeres[0].getIdProduit());
            Recette[] recettes = (Recette[]) CGenUtil.rechercher(recette, null, null, " ");
            String[] idRecette = null;
            if (recettes.length > 0) {
                idRecette = new String[recettes.length];
                for (int i = 0; i < recettes.length; i++) {
                    idRecette[i] = recettes[i].getId();
                }
                recette.suppressionMultiple(idRecette, u, c);
            }
            recetteMere = recetteMeres[0];
            for (RecetteFille recetteFille1 : recetteFilles) {
                Recette recette1 = new Recette();
                recette1.setIdproduits(recetteMere.getIdProduit());
                recette1.setIdingredients(recetteFille1.getIdIngredient());
                recette1.setQuantite(recetteFille1.getQte());
                recette1.setUnite(recetteFille1.getIdUnite());
                recette1.createObject(u, c);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            if (c != null) {
                c.rollback();
            }
            throw new Exception(ex.getMessage());
        } finally {
            if (c != null) {
                c.close();
            }
        }
    }
}

