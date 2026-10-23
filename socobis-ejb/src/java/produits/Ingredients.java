/*
 * To change this license header, choose License Headers in Project Prhistoerties.
 * To change this template file, choose Tools | Templates
 * and histoen the template in the editor.
 */
package produits;

import annexe.EquivalenceCarton;
import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMAPTable;
import equivalenceproduit.EquivalenceProduit;
import historique.MapHistorique;

import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLOutput;

import historique.MapUtilisateur;
import inventaire.Inventaire;
import inventaire.InventaireFille;
import mg.cnaps.compta.ComptaCompte;
import utilitaire.ConstanteEtat;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteStation;
import vente.EquivalenceVente;

/**
 *
 * @author Joe
 */
public class Ingredients extends ClassMAPTable {
    private String id;
    private String libelle;
    private double pvgros;
    private double seuil;
    private String unite;
    private double quantiteParPack;
    private double pu; // Prix unitaire
    private int actif;
    private String photo;
    private double calorie;
    private int duree;
    private int compose;
    private String categorieIngredient;
    private String idFournisseur;
    private Date daty;
    private double qteLimite;
    private double pv; // Prix de vente
    private String libelleVente;
    String bienOuServ;
    double revient;
    String compte_vente;
    String compte_achat;
    String etatlib;
    double ancienPu;
    double ancienPV;
    double puVenteUsd;
    double puVenteEuro;
    double tva;
    String filepath;
    String refpost;
    String refqualification;
    String idmagasin;
    String parfums;
    private String atelier;
    private String compte_ristourne;
    String reference;
    String compte_stock;
    String compte_sortie_stock;
    String typeStock;
    double reste;
    String collection;
    String codebarre;

    public String getCompte_sortie_stock() {
        return compte_sortie_stock;
    }

    public void setCompte_sortie_stock(String compte_sortie_stock) {
        this.compte_sortie_stock = compte_sortie_stock;
    }
    public String getCompte_stock() {
        return compte_stock;
    }

    public void setCompte_stock(String compte_stock) {
        this.compte_stock = compte_stock;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public String getCompte_ristourne() {
        return compte_ristourne;
    }

    public void setCompte_ristourne(String compte_ristourne) {
        this.compte_ristourne = compte_ristourne;
    }

    public double getPvgros() {
        return pvgros;
    }

    public void setPvgros(double pvgros) {
        this.pvgros = pvgros;
    }

    public String getAtelier() {
        return atelier;
    }

    public void setAtelier(String atelier) {
        this.atelier = atelier;
    }

    public String getParfums() {
        return parfums;
    }

    public void setParfums(String parfums) {
        this.parfums = parfums;
    }

    public String getIdmagasin() {
        return idmagasin;
    }

    public void setIdmagasin(String idmagasin) {
        this.idmagasin = idmagasin;
    }
    private String idFamille;

    public String getRefqualification() {
        return refqualification;
    }

    public void setRefqualification(String refqualification) {
        this.refqualification = refqualification;
    }

    public String getRefpost() {
        return refpost;
    }

    public void setRefpost(String refpost) {
        this.refpost = refpost;
    }

    public double getReste() {
        return reste;
    }

    public void setReste(double reste) throws Exception {
        if (this.getMode().equals("modif") && reste < 0) {
            throw new Exception("Reste ne peut pas etre negatif");
        }
        this.reste = reste;
    }
    public static EquivalenceVente getEquivalenceVente(String ingredient, String unite, Connection c) throws Exception {
        EquivalenceVente equivalence = new EquivalenceVente();
        equivalence.setIdproduit2(ingredient);
        EquivalenceVente[] equivalenceVentes = (EquivalenceVente[]) CGenUtil.rechercher(equivalence, null, null, c, "");
        if (equivalenceVentes.length > 0) {
            return equivalenceVentes[0];
        }
        return null;
    }


    public static EquivalenceCarton getEquivalenceCarton(String ingredient,Connection c) throws Exception {
        EquivalenceCarton equivalence = new EquivalenceCarton();
        EquivalenceCarton[] equivalenceVentes = (EquivalenceCarton[]) CGenUtil.rechercher(equivalence, null, null, c, " AND IDCARTON='"+ingredient+"'");
        if (equivalenceVentes.length > 0) {
            return equivalenceVentes[0];
        }
        return null;
    }


    
    public String getCodebarre() {
        return codebarre;
    }

    public void setCodebarre(String codebarre) {
        this.codebarre = codebarre;
    }

    public String getCollection() {
        return collection;
    }

    public void setCollection(String collection) {
        this.collection = collection;
    }

    public String getTypeStock() {
        return typeStock;
    }

    public void setTypeStock(String typeStock) {
        this.typeStock = typeStock;
    }

    public String getFilepath() {
        return filepath;
    }

    public void setFilepath(String filepath) {
        this.filepath = filepath;
    }

    public double getTva() {
        return tva;
    }

    public void setTva(double tva) throws Exception{
        if (this.getMode().equals("modif") && tva < 0) throw new Exception("TVA invalide");
            this.tva = tva;
    }

    public double getAncienPu() {
        return ancienPu;
    }

    public void setAncienPu(double ancienPu) {
        this.ancienPu = ancienPu;
    }

    public double getAncienPV() {
        return ancienPV;
    }

    public void setAncienPV(double ancienPV) {
        this.ancienPV = ancienPV;
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public String getCompte_vente() {
        return compte_vente;
    }

    public void setCompte_vente(String compte_vente) {
        this.compte_vente = compte_vente;
    }

    public String getCompte_achat() {
        return compte_achat;
    }

    public void setCompte_achat(String compte_achat) {
        this.compte_achat = compte_achat;
    }

    public double getRevient() {
        if(this.revient == 0)return this.getPu();
        return revient;
    }

    public void setRevient(double revient) {
        this.revient = revient;
    }

    public String getBienOuServ() {
        return bienOuServ;
    }

    public void setBienOuServ(String bienOuServ) {
        this.bienOuServ = bienOuServ;
    }

    public Ingredients(String id) {
        this.setNomTable("as_ingredients");
        this.setId(id);
    }



    public Ingredients() {
        this.setNomTable("AS_INGREDIENTS");
    }


    public void construirePK(Connection c) throws Exception {
        this.preparePk("IG", "getSeqIngredients");
        this.setId(makePK(c));
    }

    public String getTuppleID() {
        return id;
    }

    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public double getSeuil() {
        return seuil;
    }

    public void setSeuil(double seuil) {
        this.seuil = seuil;
    }

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) throws Exception {
        if (this.getMode().equals("modif") && (unite == null || unite.trim().isEmpty())) {
            throw new Exception("Unite obligatoire");
        }
        this.unite = unite;
    }

    public double getQuantiteParPack() {
        return quantiteParPack;
    }

    public void setQuantiteParPack(double quantiteParPack) {
        this.quantiteParPack = quantiteParPack;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) throws Exception {
        if(this.getMode().compareToIgnoreCase("modif")==0&&pu<=0) throw new Exception("Prix unitaire non valide");
        this.pu = pu;
    }

    public int getActif() {
        return actif;
    }

    public void setActif(int actif) {
        this.actif = actif;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public double getCalorie() {
        return calorie;
    }

    public void setCalorie(double calorie) {
        this.calorie = calorie;
    }

    public int getDuree() {
        return duree;
    }

    public void setDuree(int duree) {
        this.duree = duree;
    }

    public int getCompose() {
        return compose;
    }

    public void setCompose(int compose) {
        this.compose = compose;
    }

    public String getCategorieIngredient() {
        return categorieIngredient;
    }

    public void setCategorieIngredient(String categorieIngredient) {
        this.categorieIngredient = categorieIngredient;
    }

    public String getIdFournisseur() {
        return idFournisseur;
    }

    public void setIdFournisseur(String idFournisseur) {
        this.idFournisseur = idFournisseur;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public double getQteLimite() {
        return qteLimite;
    }

    public void setQteLimite(double qteLimite) {
        this.qteLimite = qteLimite;
    }

    public double getPv() {
        return pv;
    }

    public void setPv(double pv) {
        if(this.getMode().compareToIgnoreCase("modif")==0&&(this.getPv()>0||this.getTuppleID()!=null||this.getTuppleID().compareToIgnoreCase("")!=0))this.setAncienPV(this.getPv());
        this.pv = pv;
    }

    public String getLibelleVente() {
        return libelleVente;
    }

    public void setLibelleVente(String libelleVente) {
        this.libelleVente = libelleVente;
    }
    public int updateToTableWithHisto(String refUser, Connection c) throws Exception {
        Ingredients ing=new Ingredients();
        ing=(Ingredients) new Ingredients().getById(this.getId(),null,c);
        System.out.println("Pv AVY ANY ANATY BASE "+ing.getPv()+" pv modifie "+this.getPv());
        if(ing.getPu()!=this.getPu())
        {
            HistoriquePrixIng hp=new HistoriquePrixIng();
            hp.setPu(ing.getPu());
            hp.setIdIngredients(this.getId());
            hp.setDaty(Utilitaire.dateDuJourSql());
            hp.insertToTableWithHisto(refUser,c);
        }
        if(ing.getPv()!=this.getPv())
        {
            HistoriquePrixIng hp=new HistoriquePrixIng();
            hp.setNomTable("HISTORIQUEPVING");
            hp.setPu(ing.getPv());
            hp.setIdIngredients(this.getId());
            hp.setDaty(Utilitaire.dateDuJourSql());
            hp.insertToTableWithHisto(refUser,c);
        }
        return super.updateToTableWithHisto(refUser,c);
    }
    public String[] getMotCles() {
        return new String[]{"id","libelle","unite"};
    }

    /**
     * Fonction utilisée pour decomposer plusieurs ligne au cas ou
     * @param nTRecette
     * @param c
     * @return
     * @throws Exception
     */
    public Recette[] decomposerBase(String nTRecette,Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            /*String req = "select ing.pu as qteav,cast(0 as number(10,2)) as qtetotal ,ing.unite as idproduits, ing.LIBELLE as idingredients,sum(rec.quantite*cast (nvl(to_number(SUBSTR((SUBSTR(SYS_CONNECT_BY_PATH(quantite, '/'),0, (INSTR(SYS_CONNECT_BY_PATH(quantite, '/'), '/',-1)-1))),"
                    +
                    "(INSTR(SUBSTR(SYS_CONNECT_BY_PATH(quantite, '/'),0, (INSTR(SYS_CONNECT_BY_PATH(quantite, '/'), '/',-1)-1)), '/', -1))+1)),1) as number(10,2))) as quantite"
                    +
                    " from "+nTRecette +" rec,AS_INGREDIENTS_LIB ing  where rec.compose=0 and rec.IDINGREDIENTS=ing.id"
                    +
                    "  start with idproduits ='" + this.getId() + "'" +
                    "  connect by prior idingredients = idproduits and prior rec.compose = 1" +
                    "  group by ing.unite, ing.libelle,ing.pu";*/

            String req= getRequetteDecomposerBase(this.getId(), nTRecette);

            Recette rec = new Recette();
            rec.setNomTable("recettemontant");
            System.out.println(req);
            return (Recette[]) CGenUtil.rechercher(rec, req, c);

        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (estOuvert == true && c != null)
                c.close();
        }
    }

    public static String getRequetteDecomposerBase(String id, String nTRecette){
        String req="SELECT\n" +
                "    ing.pu AS qteAv,\n" +
                "    CAST(0 AS NUMBER(30,10)) AS qteTotal,\n" +
                "    ing.unite AS unite,\n" +
                "    ing.libelle AS libIngredients,ing.IDCATEGORIEINGREDIENT as categorieingredient,ing.id as idIngredients, ing.typestock,\n" +
                "    cast(SUM(\n" +
                "        (\n" +
                "            SELECT\n" +
                "                EXP(SUM(LN(ROUND(TO_NUMBER(REGEXP_SUBSTR(path, '[^/]+', 1, LEVEL)),10))))\n" +
                "            FROM\n" +
                "                dual\n" +
                "            CONNECT BY\n" +
                "                REGEXP_SUBSTR(path, '[^/]+', 1, LEVEL) IS NOT NULL\n" +
                "                AND PRIOR dbms_random.value IS NOT NULL\n" +
                "        )\n" +
                "    ) as number(30,10)) AS quantite\n" +
                "FROM (\n" +
                "    SELECT\n" +
                "        rec.*,\n" +
                "        SYS_CONNECT_BY_PATH(quantite, '/') AS path\n" +
                "    FROM\n" +
                "        "+nTRecette +" rec\n" +
                "    START WITH\n" +
                "        idproduits = '"+id+"'\n" +
                "    CONNECT BY\n" +
                "        PRIOR idingredients = idproduits\n" +
                "        AND PRIOR rec.compose = 1\n" +
                ") rec\n" +
                "JOIN AS_INGREDIENTS_LIB ing\n" +
                "    ON rec.idingredients = ing.id\n" +
                "WHERE rec.compose = 0\n" +
                "GROUP BY\n" +
                "    ing.unite,\n" +
                "    ing.libelle,\n" +
                "    ing.pu,ing.id,ing.typestock,ing.IDCATEGORIEINGREDIENT";
        return  req;
    }


    /**
     * Fonction utilisée pour decomposer plusieurs ligne par niveay
     * @param nTRecette
     * @param c
     * @return
     * @throws Exception
     */
    public Recette[] decomposerParNiveau(String nTRecette,Connection c,String apresW) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            String req="SELECT\n" +
                    "     ing.pu AS qteAv,\n" +
                    "     CAST(0 AS NUMBER(30,10)) AS qteTotal,\n" +
                    "     ing.unite AS unite,\n" +
                    "     ing.libelle AS libIngredients,ing.id as idIngredients,ing.refpost,ing.refqualification, ing.typestock, ing.IDUNITE,rec.source,ing.COMPOSE,\n" +
                    "     cast((\n" +
                    "         (\n" +
                    "             SELECT\n" +
                    "                 EXP(SUM(LN(ROUND(TO_NUMBER(REGEXP_SUBSTR(path, '[^/]+', 1, LEVEL)),10))))\n" +
                    "             FROM\n" +
                    "                 dual\n" +
                    "             CONNECT BY\n" +
                    "                 REGEXP_SUBSTR(path, '[^/]+', 1, LEVEL) IS NOT NULL\n" +
                    "                 AND PRIOR dbms_random.value IS NOT NULL\n" +
                    "         )\n" +
                    "     ) as number(30,10)) AS quantite, niveau\n" +
                    " FROM (\n" +
                    "     SELECT\n" +
                    "         rec.*,'-' as source,\n" +
                    "         SYS_CONNECT_BY_PATH(quantite, '/') AS path,LEVEL as niveau\n" +
                    "     FROM\n" +
                    "        "+nTRecette +" rec\n" +
                    "     START WITH\n" +
                    "         idproduits = '"+this.getId()+"'\n" +
                    "     CONNECT BY\n" +
                    "         PRIOR idingredients = idproduits\n" +
                    "         AND PRIOR rec.compose = 1\n" +
                    " ) rec\n" +
                    " JOIN AS_INGREDIENTS_LIB ing\n" +
                    "     ON rec.idingredients = ing.id\n" +
                    " where ing.compose>0 "+apresW+ "\n" +
                    " order by niveau asc";
            Recette rec = new Recette();
            rec.setNomTable("recettemontant");
            return (Recette[]) CGenUtil.rechercher(rec, req, c);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (estOuvert == true && c != null)
                c.close();
        }
    }
    public double calculerRevient(Connection c) throws Exception
    {
        Recette [] liste=this.decomposerBase(c);
        this.setRevient(AdminGen.calculSommeDouble(liste,"revient"));
        return this.getRevient();
    }
    public Recette[] decomposerBase(Connection c) throws Exception {
        return decomposerBase("as_recettecompose",c);
    }
    public RecetteLib[] getRecette(String table, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            RecetteLib crt = new RecetteLib();
            if (table != null && table.compareToIgnoreCase("") != 0)
                crt.setNomTable(table);
            crt.setIdproduits (this.getId());
            return (RecetteLib[]) CGenUtil.rechercher(crt, null, null, c,
                    "");
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            throw e;
        } finally {
            if (c != null && estOuvert == true)
                c.close();
        }
    }
    public RecetteLib[] getRecetteavecPu(String table, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            RecetteLib crt = new RecetteLib();
            if (table != null && table.compareToIgnoreCase("") != 0)
                crt.setNomTable(table);
            crt.setIdproduits (this.getId());
            RecetteLib[] lr= (RecetteLib[]) CGenUtil.rechercher(crt, null, null, c, "");
            for(RecetteLib l:lr)
            {
                l.calculerRevient(c);
            }
            return lr;
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            throw e;
        } finally {
            if (c != null && estOuvert == true)
                c.close();
        }
    }
    public RecetteLib[] getRecetteIngredient(String table, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            RecetteLib crt = new RecetteLib();
            if (table != null && table.compareToIgnoreCase("") != 0) {
                crt.setNomTable(table);
            }
            crt.setIdingredients(this.getId());
            return (RecetteLib[]) CGenUtil.rechercher(crt, null, null, c, "");
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    public RecetteLib[] getRecetteIngredient(String table,String categorieIngredient, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            RecetteLib crt = new RecetteLib();
            if (table != null && table.compareToIgnoreCase("") != 0) {
                crt.setNomTable(table);
            }
            crt.setIdproduits(this.getId());
            crt.setCategorieingredient(categorieIngredient);
            return (RecetteLib[]) CGenUtil.rechercher(crt, null, null, c, "");
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    /*

    public Ingredients[] decomposer(Connection c) throws Exception {
        Ingredients[] retour = null;
        int verif = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                verif = 1;
            }
            if (this.getCompose() == 0) {
                return retour;
            } else {
                Recette recette = new Recette();
                recette.setIdingredients(this.getId());
                Recette[] listef = (Recette[]) CGenUtil.rechercher(recette, null, null, "");
                String[] tab = new String[listef.length];
                for (int i = 0; i < listef.length; i++) {
                    tab[i] = listef[i].getIdproduits();
                }
                retour = (Ingredients[]) CGenUtil.rechercher(new Ingredients(), " select * from ingredients where id in(" + Utilitaire.tabToString(tab, "'", ",") + ")", c);

                return retour;
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && verif == 1) {
                c.close();
            }
        }
    }

    public RecetteLib[] getRecette(String table, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            RecetteLib crt = new RecetteLib();
            if (table != null && table.compareToIgnoreCase("") != 0) {
                crt.setNomTable(table);
            }
            return (RecetteLib[]) CGenUtil.rechercher(new RecetteLib(), null, null, c, " and idproduits = '" + this.getId() + "'");
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    public RecetteLib[] getRecetteIngredient(String table, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            RecetteLib crt = new RecetteLib();
            if (table != null && table.compareToIgnoreCase("") != 0) {
                crt.setNomTable(table);
            }
            return (RecetteLib[]) CGenUtil.rechercher(new RecetteLib(), null, null, c, " and IDINGREDIENTS = '" + this.getId() + "'");
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }*/

    public Ingredients getIngredient(Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            Ingredients[] lsing = (Ingredients[]) CGenUtil.rechercher(new Ingredients(), null, null, c, " and id = '" + this.getId() + "'");
            if (lsing == null || lsing.length == 0) {
                throw new Exception(String.format("ingredient %s introuvable",this.getId()));
            }
            return lsing[0];
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    public String genererCompte(Connection c) throws Exception {
        boolean estOuvert = false;
        String valiny = "";
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            Ingredients[] liste = (Ingredients[]) CGenUtil.rechercher(new Ingredients(), "select * from as_ingredients where photo=(select max(photo) from as_ingredients where categorieingredient='" + this.getCategorieIngredient() + "')", c);
            if (liste.length > 0) {
                int compte = 0;//Utilitaire.stringToInt(liste[0].getPhoto()) + 1;
                valiny = "" + compte;
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert) {
                c.close();
            }
        }
        return valiny;
    }



    public double getLastPu(Connection c)throws Exception{
        double retour=0.0;

        return retour;
    }
    public void produitDisponible(String idProduit, String isDispo, String refUser) throws Exception {
        Connection c = null;
        try {
            c = new UtilDB().GetConn();
            c.setAutoCommit(false); 
            String point=ConstanteStation.point_par_defaut;
            Indisponibilite indisp = new Indisponibilite(idProduit, point);
            Indisponibilite[] indispo = (Indisponibilite[]) CGenUtil.rechercher(indisp, null, null, c, " and idproduit like '" + idProduit + "' and idpoint like '" + point + "'");
            if (isDispo.compareToIgnoreCase("false") == 0) {
                //manao insert anaty indisponibilite
                if (indispo.length == 0) {
                    indisp.insertToTableWithHisto("" + refUser, c);
                }
            } else {
                // delete
                if (indispo.length != 0) {
                    indispo[0].deleteToTableWithHisto("" + refUser, c);
                }

            }
            c.commit();
        } catch (Exception e) {
            e.printStackTrace();
            if (c != null) {
                c.rollback();
            }
            throw new Exception(e.getMessage());
        } finally {
            if (c != null) {
                c.close();
            }
        }
    }

    public HistoriquePrixIng[] getHistoriquePu(Connection c, String typepu,String nT) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            HistoriquePrixIng histo = new HistoriquePrixIng();
            if(nT!=null&& nT.compareToIgnoreCase("")!=0) histo.setNomTable(nT);
            else if (typepu.compareToIgnoreCase("pv")==0) {
                histo.setNomTable("HISTORIQUEPVING");
            }

            histo.setIdIngredients(this.getId());
            HistoriquePrixIng[] histos = (HistoriquePrixIng[]) CGenUtil.rechercher(histo, null, null, c, " ");
            if (histos.length > 0) {
                return histos;
            }
            return null;
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }

    }
    public ClassMAPTable dupliquer(String u, Connection c)throws Exception{
        Ingredients nouvelle = (Ingredients) this.dupliquer(u, c);
        nouvelle.setLibelle(nouvelle.getLibelle()+" - Copie");
        nouvelle.setLibelleVente(nouvelle.getLibelleVente()+" - Copie");
        nouvelle.updateToTableWithHisto(u,c);
        Recette criteres = new Recette();
        criteres.setIdproduits(this.getId());
        Recette[] recettes = (Recette[]) CGenUtil.rechercher(criteres, null, null, c, " ");
        for(int i=0;i<recettes.length;i++){
            Recette recette = (Recette) recettes[i].dupliquer(u,c);
            recette.setIdproduits(nouvelle.getId());
            recette.updateToTableWithHisto(u,c);
        }
        return nouvelle;
    }

    public double getPuVenteUsd() {
        return puVenteUsd;
    }

    public void setPuVenteUsd(double puVenteUsd) throws Exception{
//        if(this.getMode().compareToIgnoreCase("modif")==0&&puVenteUsd<=0) throw new Exception("PU vente usd non valide");
        this.puVenteUsd = puVenteUsd;
    }

    public double getPuVenteEuro() {
        return puVenteEuro;
    }

    public void setPuVenteEuro(double puVenteEuro) throws Exception{
//        if(this.getMode().compareToIgnoreCase("modif")==0&&puVenteEuro<0) throw new Exception("PU Vente euro non valide");
        this.puVenteEuro = puVenteEuro;
    }

    public Inventaire genererInventaireParCategorie(String idInv, Connection c) throws Exception {
        boolean shouldCloseConnection = false;
        if (c == null) {
            c = new UtilDB().GetConn();
            shouldCloseConnection = true;
        }

        try {
            Inventaire inv = new Inventaire();
            inv.setId(idInv);

            Inventaire[] inventaires = (Inventaire[]) CGenUtil.rechercher(inv, null, null, c, "");
            if (inventaires.length == 0)
                throw new Exception("Inventaire non trouv&eacute;");

            inv = inventaires[0];

            IngredientsLib ing = new IngredientsLib();
            ing.setNomTable("AS_INGREDIENTS_LIB");
            ing.setIdcategorieingredient(inv.getIdCategorie());

            IngredientsLib[] ingredients = (IngredientsLib[]) CGenUtil.rechercher(ing, null, null, c, "");
            InventaireFille[] filles = new InventaireFille[ingredients.length];

            for (int i = 0; i < ingredients.length; i++) {
                filles[i] = new InventaireFille();
                filles[i].setIdProduit(ingredients[i].getId());
                filles[i].setExplication(ingredients[i].getLibelle()+" - "+ingredients[i].getUnite());
                filles[i].setIdInventaire(idInv);
                filles[i].setPu(ingredients[i].getPu());
            }

            inv.setFille(filles);
            return inv;
        } finally {
            if (shouldCloseConnection && c != null) {
                try {
                    c.close();
                } catch (Exception e) {
                    // Log ou ignorer si nécessaire
                }
            }
        }
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        String premierLettre = "";
        if(!ComptaCompte.isExiste(this.getCompte_achat(),c)){
            ComptaCompte compte = new ComptaCompte();
            compte.setCompte(this.getCompte_achat());
            compte.setIdjournal(ConstanteStation.journalAchat);
            compte.setLibelle(this.getLibelle());
            if (this.getCompte_vente() != null && !this.getCompte_vente().isEmpty()) {
                premierLettre = this.getCompte_vente().subSequence(0, 1).toString();
            }
            compte.setTypeCompte(premierLettre);
            compte.setClassy(premierLettre);
            compte.createObject(u,c);
        }

        if(!ComptaCompte.isExiste(this.getCompte_vente(),c)){
            ComptaCompte compte = new ComptaCompte();
            compte.setCompte(this.getCompte_vente());
            compte.setIdjournal(ConstanteStation.JOURNALVENTE);
            compte.setLibelle(this.getLibelle());
            if (this.getCompte_vente() != null && !this.getCompte_vente().isEmpty()) {
                premierLettre = this.getCompte_vente().subSequence(0, 1).toString();
            }
            compte.setTypeCompte(premierLettre);
            compte.setClassy(premierLettre);
            compte.createObject(u,c);
        }

        return super.createObject(u, c);
    }

    public TarifIngredientsLib[] getHistoriqueTarif(Connection c,String nT) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            TarifIngredientsLib histo = new TarifIngredientsLib();
            if (nT != null && nT.compareToIgnoreCase("") != 0) histo.setNomTable(nT);

            histo.setIdIngredient(this.getId());
            TarifIngredientsLib[] histos = (TarifIngredientsLib[]) CGenUtil.rechercher(histo, null, null, c, " ");
            if (histos.length > 0) {
                return histos;
            }
            return null;
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    public String getIdFamille() {
        return this.idFamille;
    }

    public void setIdFamille(String idFamille) {
        this.idFamille = idFamille;
    }

    public EquivalenceProduit findEquivalenceEnCarton(Connection c) throws Exception {
        String awhere = " AND IDPRODUITEQ = '"+this.getId()+"'";
        EquivalenceProduit[] equivalenceProduits = (EquivalenceProduit[]) CGenUtil.rechercher(new EquivalenceProduit(), null, null, c, awhere);
        if ( equivalenceProduits.length > 0) {
            return  equivalenceProduits[0];
        }
        throw new Exception("Aucune equivalence trouvée pour ce produit " +this.getId());
    }

    public EquivalenceProduit findEquivalenceEnPiece(Connection c) throws Exception {
        String awhere = " AND IDPRODUITBASE = '"+this.getId()+"'";
        EquivalenceProduit[] equivalenceProduits = (EquivalenceProduit[]) CGenUtil.rechercher(new EquivalenceProduit(), null, null, c, awhere);
        if (equivalenceProduits.length > 0) {
            return  equivalenceProduits[0];
        }
        throw new Exception("Aucune equivalence trouvée pour ce produit "+this.getId());
    }

    public boolean isService() {
        return this.getTypeStock() == null;
    }

    public Ingredients getIngredient(Ingredients[] ingredients) throws Exception {
        Ingredients ing = (Ingredients) AdminGen.findUnique(ingredients,new String[]{"id"},new String[]{this.getId()});
        if (ing == null) {
            throw new Exception("Ingredients avec id : " + this.getId() + " introuvable");
        }
        return ing;
    }
}
