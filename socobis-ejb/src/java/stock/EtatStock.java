package stock;

import bean.CGenUtil;
import bean.ClassMAPTable;

import java.sql.Connection;
import java.sql.Date;

import bean.ResultatEtSomme;
import utilitaire.Utilitaire;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author Angela
 */
public class EtatStock extends ClassMAPTable {
    protected String id;
    protected String idProduitLib;
    protected String idTypeProduit;
    protected String idTypeProduitLib;
    protected String idMagasin;
    protected String idMagasinLib;
    protected Date dateDernierInventaire,dateDernierMouvement, daty;
    protected double quantite;
    protected double entree;
    protected double sortie;
    protected double reste,montantReste,montantSortie,montantEntree;
    protected double puVente;
    protected String idUnite;
    protected String idUniteLib;
    protected String idPoint;
    protected String idPointLib;
    protected  double pu;
    protected  String mvtsrc;
    protected String compteLocalisation;
    protected String compteLocalisationLib;
    protected String categorieIngredient , typeStock , idProduit;
    java.sql.Date invdaty;
    double invquantite;
    protected String codeProduit;
    protected String iddepartement,departementlib;

    public String getIddepartement() {
        return iddepartement;
    }

    public void setIddepartement(String iddepartement) {
        this.iddepartement = iddepartement;
    }

    public String getDepartementlib() {
        return departementlib;
    }

    public void setDepartementlib(String departementlib) {
        this.departementlib = departementlib;
    }

    public String getCodeProduit() {
        return codeProduit;
    }

    public void setCodeProduit(String codeProduit) {
        this.codeProduit = codeProduit;
    }

    public Date getInvdaty() {
        return invdaty;
    }

    public String getCompteLocalisationLib() {
        return compteLocalisationLib;
    }

    public void setCompteLocalisationLib(String compteLocalisationLib) {
        this.compteLocalisationLib = compteLocalisationLib;
    }

    public void setInvdaty(Date invdaty) {
        this.invdaty = invdaty;
    }

    public double getInvquantite() {
        return invquantite;
    }

    public void setInvquantite(double invquantite) {
        this.invquantite = invquantite;
    }

    public String getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(String idProduit) {
        this.idProduit = idProduit;
    }

    public String getTypeStock() {
        return typeStock;
    }

    public void setTypeStock(String typeStock) {
        this.typeStock = typeStock;
    }


    public String getCategorieIngredient() {
        return categorieIngredient;
    }

    public void setCategorieIngredient(String categorieIngredient) {
        this.categorieIngredient = categorieIngredient;
    }

    public String getCompteLocalisation() {
        return compteLocalisation;
    }

    public void setCompteLocalisation(String compteLocalisation) {
        this.compteLocalisation = compteLocalisation;
    }

    public String getMvtsrc() {
        return mvtsrc;
    }

    public void setMvtsrc(String mvtsrc) {
        this.mvtsrc = mvtsrc;
    }

    public Date getDateDernierMouvement() {
        return dateDernierMouvement;
    }

    public void setDateDernierMouvement(Date dateDernierMouvement) {
        this.dateDernierMouvement = dateDernierMouvement;
    }

    public double getMontantReste() {
        return montantReste;
    }
    public ResultatEtSomme rechercherPage(String[] colInt, String[]valInt, int numPage, String apresWhere, String[]nomColSomme, Connection c, int npp) throws Exception {
        String daty=Utilitaire.dateDuJour();
        if(valInt!=null&&valInt.length>1) {daty=valInt[1].toString();}

        /*String req= "SELECT\n" +
                "\tp.ID AS ID,\n" +
                "\tp.LIBELLE AS idproduitLib,\n" +
                "\tms.compteLocalisation,\n" +
                "\tp.CATEGORIEINGREDIENT,\n" +
                "\ttp.DESCE AS idtypeproduitlib,\n" +
                "\tms.IDMAGASIN,\n" +
                "\tmag.DESCE AS idmagasinlib,\n" +
                "\tTO_DATE('01-01-2001', 'DD-MM-YYYY') AS dateDernierMouvement,\n" +
                "\tms.quantite AS QUANTITE,\n" +
                "\tms.entree AS ENTREE,\n" +
                "\tms.sortie AS SORTIE,\n" +
                "\tms.quantite AS reste,\n" +
                "\tp.UNITE,\n" +
                "\tu.DESCE AS idunitelib,\n" +
                "\tCAST(NVL(p.PV, 0) AS NUMBER(30, 2)) AS PUVENTE,\n" +
                "\tmag.IDPOINT,\n" +
                "\tmag.IDTYPEMAGASIN,\n" +
                "\tp.SEUILMIN,\n" +
                "\tp.SEUILMAX,\n" +
                "\tms.montantEntree,\n" +
                "\tms.montantSortie,\n" +
                "\tp.pu,\n" +
                "\tms.montant as montantReste\n" +
                "FROM AS_INGREDIENTS p\n" +
                "LEFT JOIN (SELECT\n" +
                "    mf.IDPRODUIT,\n" +
                "    mf.compteLocalisation,\n" +
                "    SUM(NVL(mf.ENTREE,0)) AS ENTREE,\n" +
                "    SUM(NVL(mf.SORTIE,0)) AS SORTIE,\n" +
                "    SUM(NVL(mf.ENTREE,0)) - SUM(NVL(mf.SORTIE,0)) AS quantite,\n" +
                "    cast(sum(mf.montantEntree) as number(30,2))  AS montantEntree,\n" +
                "    cast(sum(mf.montantSortie) as number(30,2))  AS montantSortie,\n" +
                "    CAST(NVL(ai.PU, 0) * (SUM(NVL(mf.ENTREE,0)) - SUM(NVL(mf.SORTIE,0))) AS NUMBER(30,2)) AS montant,\n" +
                "    m.IDMAGASIN\n" +
                "FROM\n" +
                "    mvtStockFilleMontant mf\n" +
                "JOIN MVTSTOCK m ON m.id = mf.IDMVTSTOCK\n" +
                "JOIN AS_INGREDIENTS ai ON ai.ID = mf.IDPRODUIT\n" +
                "WHERE\n" +
                "    m.ETAT >= 11\n" +
                "    AND mf.IDPRODUIT IS NOT NULL\n" +
                "    AND m.daty<=TO_DATE('"+daty+"', 'DD/MM/YYYY') \n" +
                "GROUP BY\n" +
                "    mf.IDPRODUIT,\n" +
                "    mf.compteLocalisation,\n" +
                "    ai.PU,m.IDMAGASIN) ms ON ms.IDPRODUIT = p.ID\n" +
                "LEFT JOIN CATEGORIEINGREDIENT tp ON p.CATEGORIEINGREDIENT = tp.ID\n" +
                "LEFT JOIN MAGASINPOINT mag ON ms.IDMAGASIN = mag.ID\n" +
                "LEFT JOIN AS_UNITE u ON p.UNITE = u.ID\n" +
                "where NVL(ms.ENTREE, 0)>0 or NVL(ms.SORTIE, 0)>0";*/
        String req=getReqEtatStock(daty);
        ResultatEtSomme rs= CGenUtil.rechercherPage(this,req,numPage,nomColSomme,apresWhere,c,npp);
        return rs;
    }
    public static String getReqEtatStock(String daty)
    {
        String req="SELECT\n" +
                "   '-' as id,ai.typeStock,\n" +
                "   ai.id AS IDPRODUIT,\n" +
                "   ai.LIBELLE AS idproduitlib,\n" +
                "   ai.CATEGORIEINGREDIENT,\n" +
                "   c.VAL AS idtypeproduitlib,\n" +
                "   m.id as IDMAGASIN,\n" +
                "   m.VAL AS idmagasinlib,\n" +
                "   ve.QUANTITE,\n" +
                "   CAST(ve.ENTREE AS NUMBER(30,2)) AS ENTREE,\n" +
                "   CAST(ve.SORTIE AS NUMBER(30,2)) AS SORTIE,\n" +
                "   CAST(ve.RESTE AS NUMBER(30,2)) AS RESTE,\n" +
                "   CAST(nvl(ve.ENTREE*ve.pu,0) AS NUMBER(30,2)) AS MONTANTENTREE,\n" +
                "   CAST(nvl(ve.sortie*ve.pu,0) AS NUMBER(30,2)) AS MONTANTSORTIE,\n" +
                "   CAST(nvl((ve.ENTREE*ve.pu)-(ve.sortie*ve.pu),0) AS NUMBER(30,2)) AS MONTANTRESTE,\n" +
                "   ai.UNITE,\n" +
                "   u.VAL AS idunitelib,\n" +
                "   case\n" +
                "       when ve.reste!=0 then CAST(nvl((((ve.ENTREE*ve.pu)-(ve.sortie*ve.pu))/nvl(ve.reste,1)),0) AS NUMBER(30,2))\n" +
                "        else cast(ai.pu as number(30,2))\n" +
                "            end as pu,\n" +
                "   ve.DATY\n" +
                "FROM (\n" +
                "   SELECT\n" +
                "       \"IDPRODUIT\",\n" +
                "       sum(mf.ENTREE) as \"ENTREE\",\n" +
                "       sum (mf.SORTIE) \"SORTIE\",\n" +
                "       '' as \"IDVENTEDETAIL\",\n" +
                "       '' as \"IDTRANSFERTDETAIL\",\n" +
                "       avg (mf.PU) as \"PU\",\n" +
                "       '' as \"MVTSRC\",\n" +
                "       '' as \"DATY\",\n" +
                "       (sum(mf.ENTREE)-sum (mf.SORTIE)) as \"RESTE\",\n" +
                "       0 as \"QUANTITE\",\n" +
                "       m.IDMAGASIN \"IDMAGASIN\"\n" +
                "   FROM MVTSTOCKFILLE mf\n" +
                "        left join mvtStock m on m.id=mf.IDMVTSTOCK\n" +
                "   where m.ETAT>=11 and m.daty <= TO_DATE('"+daty+"', 'DD-MM-YYYY')\n" +
                "   group by mf.IDPRODUIT,m.IDMAGASIN\n" +
                ") ve\n" +
                "LEFT JOIN AS_INGREDIENTS ai ON ai.id = ve.IDPRODUIT\n" +
                "LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id\n" +
                "LEFT JOIN MAGASINPOINT m ON ve.IDMAGASIN = m.id\n" +
                "LEFT JOIN AS_UNITE u ON ai.UNITE = u.id\n" +
                "WHERE  ve.PU > 0 and ve.reste>0";
        String reqReutilise="WITH max_inventaire AS (\n" +
            "    -- Étape 1 : On extrait la date maximale valide et la quantité par COUPLE produit/magasin\n" +
            "    SELECT\n" +
            "        invff.idproduit,\n" +
            "        imeref.idmagasin,\n" +
            "        MAX(imeref.DATY) AS max_daty,\n" +
            "        MAX(invff.QUANTITE) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS qte_max_daty,\n" +
            "        MAX(invff.pu) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS pu_max_daty\n" +
            "    FROM INVENTAIREFILLE invff\n" +
            "    LEFT JOIN inventaireDateHeure imeref ON imeref.ID = invff.IDINVENTAIRE\n" +
            "    WHERE imeref.ETAT >= 11 and imeref.DATY< to_date('"+daty+"','DD-MM-YYYY') + 1\n" +
            "    GROUP BY invff.idproduit, imeref.idmagasin\n" +
            "),\n" +
            "somme_precalc AS (\n" +
            "    -- Étape 3 : Calcul des sommes globales agrégées par COUPLE produit/magasin\n" +
            "    SELECT\n" +
            "        mff.idproduit as idproduit,\n" +
            "        meref.idmagasin as idmagasin,\n" +
            "        NVL(SUM(CASE WHEN meref.DATY >NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.ENTREE ELSE 0 END), 0) AS entree,\n" +
            "\n" +
            "        NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.SORTIE ELSE 0 END), 0) AS sortie,\n" +
            "        ai.LIBELLE AS idproduitlib,\n" +
            "        ai.CATEGORIEINGREDIENT as CATEGORIEINGREDIENT,\n" +
            "        ai.UNITE as unite,\n" +
            "        ai.TYPESTOCK as typestock,\n" +
            "        u.VAL AS idunitelib,\n" +
            "        c.VAL AS idtypeproduitlib,\n" +
            "        avg(mff.PU) as pu,\n" +
            "        null as IDFOURNISSEUR,\n" +
            "        null as IDFOURNISSEURLIB,\n" +
            "        m.VAL AS idmagasinlib,\n" +
            "        max(inv.max_daty) AS invdaty,\n" +
            "        nvl(max(inv.qte_max_daty),0)as invquantite,\n" +
            "        mff.compteLocalisation,\n" +
            "        loc.LIBELLE as COMPTELOCALISATIONLIB,\n" +
            "        NVL(SUM(CASE WHEN meref.DATY >NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.ENTREE*mff.pu ELSE 0 END), 0) AS montantEntree,\n" +
            "        NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.SORTIE*mff.pu ELSE 0 END), 0) AS montantSortie,\n" +
            "        nvl(avg(inv.pu_max_daty*inv.qte_max_daty),0) as montantInv,\n" +
            "        ai.PARFUMS as codeproduit\n" +
            "    FROM MVTSTOCKFILLE mff\n" +
            "    LEFT JOIN mvtStockDateHeure meref ON meref.ID = mff.IDMVTSTOCK\n" +
            "    LEFT JOIN max_inventaire inv ON inv.idproduit = mff.idproduit AND inv.idmagasin = meref.idmagasin\n" +
            "    LEFT JOIN AS_INGREDIENTS ai ON ai.id = mff.IDPRODUIT\n" +
            "    LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id\n" +
            "    LEFT JOIN MAGASINPOINT m ON meref.IDMAGASIN = m.id\n" +
            "    LEFT JOIN AS_UNITE u ON ai.UNITE = u.id\n" +
            "    LEFT JOIN LOCALISATION loc ON loc.id=mff.COMPTELOCALISATION\n" +
            "    WHERE --meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) and\n" +
            "      meref.ETAT >= 11 and meref.DATY< to_date('"+daty+"','DD-MM-YYYY') + 1\n" +
            "      AND meref.IDTYPEMVSTOCK != 'TPMVST000023'\n" +
            "    GROUP BY mff.idproduit, meref.idmagasin,ai.LIBELLE,ai.CATEGORIEINGREDIENT,ai.UNITE,ai.TYPESTOCK,u.VAL,c.VAL,m.VAL,mff.compteLocalisation, loc.LIBELLE,ai.PARFUMS\n" +
            ")\n" +
            "-- Sélection finale\n" +
            "SELECT\n" +
            "    null as ID, null as DATY,  cast(invquantite as number(30,2)) as invquantite,cast(entree as number(30,2)) as entree, cast(sortie as number(30,2)) as sortie,CAST((invquantite)+(ENTREE)-(sortie) AS NUMBER(30,2)) as reste,\n" +
            "    CAST(invquantite+ENTREE-sortie AS NUMBER(30,2)) AS quantite,\n" +
            "    CAST((montantInv+montantEntree-montantSortie)AS NUMBER(30,2))AS montantreste,\n" +
            "    cast((montantInv+montantEntree-montantSortie)/(invquantite+ENTREE-sortie)  as number(30,2)) as pu,\n" +
            "    idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK, idunitelib, idtypeproduitlib,\n" +
            "     IDFOURNISSEUR, IDFOURNISSEURLIB, IDPRODUIT, IDMAGASIN, idmagasinlib,invdaty,compteLocalisation,COMPTELOCALISATIONLIB,codeproduit\n" +
            "FROM somme_precalc\n" +
            "WHERE invquantite+ENTREE-sortie != 0";

        //System.out.println(reqReutilise);
        String requete = "SELECT\n" +
            "    '' as id,\n" +
            "    '' as DATY,\n" +
            "    cast(sum(invquantite) as number(30,3)) as invquantite,\n" +
            "    cast(sum(entree) as number(30,3)) as entree,\n" +
            "    cast(sum(sortie) as number(30,3)) as sortie,\n" +
            "    cast(sum(reste) as number(30,3)) as reste,\n" +
            "    cast(sum(quantite) as number(30,3)) as quantite,\n" +
            "    cast(sum(reste)* avg(pu) as number(30,2)) as montantReste,\n" +
            "    idproduitlib,\n" +
            "    CATEGORIEINGREDIENT,\n" +
            "    UNITE,\n" +
            "    TYPESTOCK,\n" +
            "    idunitelib,\n" +
            "    idtypeproduitlib,\n" +
            "    avg(PU) AS PU,\n" +
            "    '' as IDFOURNISSEUR,\n" +
            "    '' as IDFOURNISSEURLIB,\n" +
            "    IDPRODUIT,\n" +
            "    IDMAGASIN,\n" +
            "    idmagasinlib,\n" +
            "    min(invdaty) as invdaty,\n" +
            "    compteLocalisation,\n" +
            "    COMPTELOCALISATIONLIB,\n" +
            "    codeproduit,\n" +
                "    IDDEPARTEMENT,\n" +
                "    departementlib "+
            "FROM (\n" +
            "    SELECT * FROM ("+EtatStockParEntree.getRequeteEtatStockEntree(daty)+")\n" +
            "    union all select * from (\n" +
            "    WITH max_inventaire AS (\n" +
            "        SELECT\n" +
            "            invff.IDPRODUIT,imeref.IDMAGASIN,\n" +
            "            MAX(imeref.DATY) AS max_daty\n" +
            "            ,MAX(invff.QUANTITE) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS qte_max_daty,\n" +
            "            MAX(invff.pu) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS pu_max_daty\n" +
            "        FROM INVENTAIREFILLE invff\n" +
            "        LEFT JOIN inventaireDateHeure imeref ON imeref.ID = invff.IDINVENTAIRE\n" +
            "        WHERE imeref.ETAT >= 11 and invff.MVTSRC is null\n" +
            "        GROUP BY invff.IDPRODUIT, imeref.IDMAGASIN\n" +
            "    ),\n" +
            "         somme_precalc AS (\n" +
            "             -- Etape 3 : Calcul des sommes globales agregees par COUPLE produit/magasin\n" +
            "             SELECT\n" +
            "                 mff.idproduit as idproduit,\n" +
            "                 meref.idmagasin as idmagasin,\n" +
            "                 NVL(SUM(CASE WHEN meref.DATY >NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.ENTREE ELSE 0 END), 0) AS entree,\n" +
            "\n" +
            "                 NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.SORTIE ELSE 0 END), 0) AS sortie,\n" +
            "                 ai.LIBELLE AS idproduitlib,\n" +
            "            ai.CATEGORIEINGREDIENT as CATEGORIEINGREDIENT,\n" +
            "            ai.UNITE as unite,\n" +
            "            ai.TYPESTOCK as typestock,\n" +
            "            u.VAL AS idunitelib,\n" +
            "            c.VAL AS idtypeproduitlib,\n" +
            "                 avg(mff.PU) as pu,\n" +
            "                 null as IDFOURNISSEUR,\n" +
            "                 null as IDFOURNISSEURLIB,\n" +
            "                 m.VAL AS idmagasinlib,\n" +
            "                 max(inv.max_daty) AS invdaty,\n" +
            "                 nvl(max(inv.qte_max_daty),0)as invquantite,\n" +
            "                 NVL(SUM(CASE WHEN meref.DATY >NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.ENTREE*mff.pu ELSE 0 END), 0) AS montantEntree,\n" +
            "                 NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.SORTIE*mff.pu ELSE 0 END), 0) AS montantSortie,\n" +
            "                 nvl(avg(inv.pu_max_daty*inv.qte_max_daty),0) as montantInv, nvl(max(ai.SEUIL),0) as seuil,nvl(max(ai.SEUILMAX),nvl(max(ai.SEUILMIN),0)+1000) as seuilmax,nvl(max(ai.SEUILMIN),0) as seuilMin,\n" +
            "                 loc.LIBELLE as COMPTELOCALISATIONLIB,\n" +
            "                 mff.compteLocalisation,\n" +
            "                 ai.PARFUMS as codeproduit,\n" +
                " ai.IDDEPARTEMENT,\n" +
                "                    ai.departementlib "+
            "             FROM MVTSTOCKFILLE mff\n" +
            "                      LEFT JOIN mvtStockDateHeure meref ON meref.ID = mff.IDMVTSTOCK\n" +
            "        LEFT JOIN max_inventaire inv ON inv.idproduit = mff.idproduit AND inv.idmagasin = meref.idmagasin\n" +
            "        LEFT JOIN AS_INGREDIENT_DEP ai ON ai.id = mff.IDPRODUIT\n" +
            "        LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id\n" +
            "        LEFT JOIN MAGASINPOINT m ON meref.IDMAGASIN = m.id\n" +
            "        LEFT JOIN AS_UNITE u ON ai.UNITE = u.id\n" +
            "        LEFT JOIN LOCALISATION loc ON loc.id=mff.COMPTELOCALISATION\n" +
            "        WHERE --meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) and\n" +
            "          meref.ETAT >= 11\n" +
            "          AND meref.IDTYPEMVSTOCK != 'TPMVST000023' and mff.MVTSRC is null\n" +
            "          and not exists(select 1 from V_ETATSTOCK_ENTREE  ve where ve.id = mff.id)\n" +
            "        GROUP BY mff.idproduit, meref.idmagasin,ai.LIBELLE,ai.CATEGORIEINGREDIENT,ai.UNITE,ai.TYPESTOCK,u.VAL,c.VAL,m.VAL,mff.compteLocalisation,ai.PARFUMS,loc.LIBELLE,ai.IDDEPARTEMENT,ai.departementlib\n" +
            "         )\n" +
            "    SELECT\n" +
            "        null as ID, null as DATY,  cast(invquantite as number(30,3)) as invquantite,cast(entree as number(30,3)) as entree, cast(sortie as number(30,3)) as sortie,CAST((invquantite)+(ENTREE)-(sortie) AS NUMBER(30,3)) as reste,\n" +
            "        CAST(invquantite+ENTREE-sortie AS NUMBER(30,3)) AS quantite,\n" +
            "        CAST((montantInv+montantEntree-montantSortie)AS NUMBER(30,2))AS montantreste,\n" +
            "        idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK, idunitelib, idtypeproduitlib,\n" +
            "        cast((montantInv+montantEntree-montantSortie)/(invquantite+ENTREE-sortie)  as number(30,2)) as pu,\n" +
            "        IDFOURNISSEUR, IDFOURNISSEURLIB, IDPRODUIT, IDMAGASIN, idmagasinlib,invdaty,\n" +
            "        COMPTELOCALISATIONLIB,compteLocalisation,codeproduit,IDDEPARTEMENT,\n" +
                "                                         departementlib\n" +
            "    FROM somme_precalc\n" +
            "    WHERE (invquantite+ENTREE-sortie) != 0)\n" +
            ") GROUP BY\n" +
            "idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK,\n" +
            "idunitelib, idtypeproduitlib, IDPRODUIT,\n" +
            "IDMAGASIN, idmagasinlib, compteLocalisation, COMPTELOCALISATIONLIB, codeproduit, IDDEPARTEMENT,departementlib";
//        System.out.println("requete " + requete);
        String reqFinale = "WITH max_inventaire AS (\n" +
            "    -- Étape 1 : On extrait la date maximale valide et la quantité par COUPLE produit/magasin\n" +
            "    SELECT\n" +
            "        invff.IDPRODUIT,imeref.IDMAGASIN,\n" +
            "        MAX(imeref.DATY) AS max_daty,\n" +
            "        MAX(invff.QUANTITE) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS qte_max_daty,\n" +
            "        MAX(invff.pu) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS pu_max_daty\n" +
            "    FROM INVENTAIREFILLE invff\n" +
            "         LEFT JOIN inventaireDateHeure imeref ON imeref.ID = invff.IDINVENTAIRE\n" +
            "    WHERE imeref.ETAT >= 11 and imeref.DATY< to_date('"+daty+"','DD-MM-YYYY') + 1\n" +
            "    GROUP BY invff.IDPRODUIT, imeref.IDMAGASIN\n" +
            "),\n" +
            "     somme_precalc AS (\n" +
            "         -- Étape 3 : Calcul des sommes globales agrégées par COUPLE produit/magasin\n" +
            "         SELECT\n" +
            "             mff.idproduit as idproduit,\n" +
            "             meref.idmagasin as idmagasin,\n" +
            "             NVL(SUM(CASE WHEN meref.DATY >NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.ENTREE ELSE 0 END), 0) AS entree,\n" +
            "\n" +
            "             NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.SORTIE ELSE 0 END), 0) AS sortie,\n" +
            "             ai.LIBELLE AS idproduitlib,\n" +
            "             ai.CATEGORIEINGREDIENT as CATEGORIEINGREDIENT,\n" +
            "             ai.UNITE as unite,\n" +
            "             ai.TYPESTOCK as typestock,\n" +
            "             u.VAL AS idunitelib,\n" +
            "             c.VAL AS idtypeproduitlib,\n" +
            "             avg(mff.PU) as pu,\n" +
            "             null as IDFOURNISSEUR,\n" +
            "             null as IDFOURNISSEURLIB,\n" +
            "             m.VAL AS idmagasinlib,\n" +
            "             max(inv.max_daty) AS invdaty,\n" +
            "             nvl(max(inv.qte_max_daty),0)as invquantite,\n" +
            "             NVL(SUM(CASE WHEN meref.DATY >NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.ENTREE*mff.pu ELSE 0 END), 0) AS montantEntree,\n" +
            "             NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.SORTIE*mff.pu ELSE 0 END), 0) AS montantSortie,\n" +
            "             nvl(avg(inv.pu_max_daty*inv.qte_max_daty),0) as montantInv,\n" +
            "             nvl(max(ai.SEUIL),0) as seuil,\n" +
            "             nvl(max(ai.SEUILMAX),\n" +
            "             nvl(max(ai.SEUILMIN),0)+1000) as seuilmax,\n" +
            "             nvl(max(ai.SEUILMIN),0) as seuilMin,\n" +
            "             ai.PARFUMS as codeproduit,\n" +
            "             m.IDDEPARTEMENT,\n" +
            "             d.val as departementlib\n" +
            "         FROM MVTSTOCKFILLE mff\n" +
            "                  LEFT JOIN MVTSTOCK meref ON meref.ID = mff.IDMVTSTOCK\n" +
            "                  LEFT JOIN max_inventaire inv ON inv.idproduit = mff.idproduit AND inv.idmagasin = meref.idmagasin\n" +
            "                  LEFT JOIN AS_INGREDIENTS ai ON ai.id = mff.IDPRODUIT\n" +
            "                  LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id\n" +
            "                  LEFT JOIN MAGASINPOINT m ON meref.IDMAGASIN = m.id\n" +
            "                  LEFT JOIN AS_UNITE u ON ai.UNITE = u.id\n" +
            "                   LEFT JOIN DEPARTEMENT d ON d.ID = m.IDDEPARTEMENT\n" +
            "         WHERE --meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) and\n" +
            "             meref.IDTYPEMVSTOCK != 'TPMVST000023' and\n" +
            "             meref.ETAT >= 11 and meref.DATY< to_date('"+daty+"','DD-MM-YYYY') + 1\n" +
            "         GROUP BY mff.idproduit, meref.idmagasin,ai.LIBELLE,ai.CATEGORIEINGREDIENT,ai.UNITE,ai.TYPESTOCK,u.VAL,c.VAL,m.VAL,\n" +
            "         ai.PARFUMS,m.IDDEPARTEMENT,d.val\n" +
            "     )\n" +
            "-- Sélection finale\n" +
            "SELECT\n" +
            "    null as ID, null as DATY,  cast(invquantite as number(30,2)) as invquantite,cast(entree as number(30,2)) as entree, cast(sortie as number(30,2)) as sortie,CAST((invquantite)+(ENTREE)-(sortie) AS NUMBER(30,2)) as reste,\n" +
            "    CAST(invquantite+ENTREE-sortie AS NUMBER(30,2)) AS quantite,\n" +
            "    CAST((montantInv+montantEntree-montantSortie)AS NUMBER(30,2))AS montantreste,\n" +
            "    cast((montantInv+montantEntree-montantSortie)/(invquantite+ENTREE-sortie)  as number(30,2)) as pu,\n" +
            "    idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK, idunitelib, idtypeproduitlib,\n" +
            "    IDFOURNISSEUR, IDFOURNISSEURLIB, IDPRODUIT, IDMAGASIN, idmagasinlib,invdaty,codeproduit,IDDEPARTEMENT,departementlib\n" +
            "FROM somme_precalc\n" +
            "WHERE invquantite+ENTREE-sortie != 0";
        String requeteFinale = "SELECT\n" +
            "    null AS ID,\n" +
            "    null AS DATY,\n" +
            "    CAST(SUM(invquantite) AS NUMBER(30,3)) AS invquantite,\n" +
            "    CAST(SUM(entree) AS NUMBER(30,3)) AS entree,\n" +
            "    CAST(SUM(sortie) AS NUMBER(30,3)) AS sortie,\n" +
            "    CAST(SUM(reste) AS NUMBER(30,3)) AS reste,\n" +
            "    CAST(SUM(quantite) AS NUMBER(30,3)) AS quantite,\n" +
            "    CAST(SUM(montantreste) AS NUMBER(30,2)) AS montantreste,\n" +
            "    CAST(SUM(montantreste) / SUM(reste) AS NUMBER(30,2)) AS pu,\n" +
            "    idproduitlib,\n" +
            "    CATEGORIEINGREDIENT,\n" +
            "    UNITE,\n" +
            "    TYPESTOCK,\n" +
            "    idunitelib,\n" +
            "    idtypeproduitlib,\n" +
            "    null AS IDFOURNISSEUR,\n" +
            "    null AS IDFOURNISSEURLIB,\n" +
            "    IDPRODUIT,\n" +
            "    IDMAGASIN,\n" +
            "    idmagasinlib,\n" +
            "    MAX(invdaty) AS invdaty,\n" +
            "    codeproduit,\n" +
            "    IDDEPARTEMENT,\n" +
            "    departementlib\n" +
            "FROM ("+EtatStockLocalisation.getRequeteEtatStockLocalisation(daty)+")\n" +
            "GROUP BY\n" +
            "    IDPRODUIT, IDMAGASIN,\n" +
            "    idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK,\n" +
            "    idunitelib, idtypeproduitlib,\n" +
            "    idmagasinlib, codeproduit, IDDEPARTEMENT, departementlib\n" +
            "HAVING SUM(reste) != 0";
        return requeteFinale;
    }
        public void setMontantReste(double montantReste) {
        this.montantReste = montantReste;
    }

    public double getMontantSortie() {
        return montantSortie;
    }

    public void setMontantSortie(double montantSortie) {
        this.montantSortie = montantSortie;
    }

    public double getMontantEntree() {
        return montantEntree;
    }

    public void setMontantEntree(double montantEntree) {
        this.montantEntree = montantEntree;
    }

    public EtatStock() {
        this.setNomTable("v_etatstock_ing");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdProduitLib() {
        return idProduitLib;
    }

    public void setIdProduitLib(String idProduitLib) {
        this.idProduitLib = idProduitLib;
    }

    public String getIdTypeProduit() {
        return idTypeProduit;
    }

    public void setIdTypeProduit(String idTypeProduit) {
        this.idTypeProduit = idTypeProduit;
    }

    public String getIdTypeProduitLib() {
        return idTypeProduitLib;
    }

    public void setIdTypeProduitLib(String idTypeProduitLib) {
        this.idTypeProduitLib = idTypeProduitLib;
    }

    public String getIdMagasin() {
        return idMagasin;
    }

    public void setIdMagasin(String idMagasin) {
        this.idMagasin = idMagasin;
    }

    public String getIdMagasinLib() {
        return idMagasinLib;
    }

    public void setIdMagasinLib(String idMagasinLib) {
        this.idMagasinLib = idMagasinLib;
    }

    public Date getDateDernierInventaire() {
        return dateDernierInventaire;
    }

    public void setDateDernierInventaire(Date dateDernierInventaire) {
        this.dateDernierInventaire = dateDernierInventaire;
    }

    public double getQuantite() {
        return quantite;
    }

    public void setQuantite(double quantite) {
        this.quantite = quantite;
    }

    public double getEntree() {
        return entree;
    }

    public void setEntree(double entree) {
        this.entree = entree;
    }

    public double getSortie() {
        return sortie;
    }

    public void setSortie(double sortie) {
        this.sortie = sortie;
    }

    public double getReste() {
        return reste;
    }

    public void setReste(double reste) {
        this.reste = reste;
    }

    public String getIdUnite() {
        return idUnite;
    }

    public void setIdUnite(String idUnite) {
        this.idUnite = idUnite;
    }

    public String getIdUniteLib() {
        return idUniteLib;
    }

    public void setIdUniteLib(String idUniteLib) {
        this.idUniteLib = idUniteLib;
    }

    public String getIdPointLib() {
        return idPointLib;
    }

    public void setIdPointLib(String idPointLib) {
        this.idPointLib = idPointLib;
    }

    public String getIdPoint() {
        return idPoint;
    }

    public void setIdPoint(String idPoint) {
        this.idPoint = idPoint;
    }

    public String getFieldDateName() {
        return "dateDernierInventaire";
    }

       public double getPuVente() {
              return puVente;
       }

       public void setPuVente(double puVente) {
              this.puVente = puVente;
       }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) {
        this.pu = pu;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String generateQueryCore(Date dateMin, Date dateMax) {
        String query =  " SELECT  " +
                    "	inv.IDPRODUIT AS ID, " +
                    "	p.libelle AS idproduitLib, " +
                    "	p.CATEGORIEINGREDIENT, " +
                    "	tp.desce AS idtypeproduitlib, " +
                    "	inv.idmagasin, " +
                    "	mag.desce AS idmagasinlib, " +
                    "	inv.DATY dateDernierinventaire, " +
                    "	NVL(inv.QUANTITE,0) QUANTITE, " +
                    "	NVL(mvt.ENTREE,0) ENTREE,  " +
                    "	NVL(mvt.SORTIE,0) SORTIE,  " +
                    "	NVL(mvt.ENTREE,0)+NVL(inv.QUANTITE,0)-NVL(mvt.SORTIE,0) reste, " +
                    "	p.UNITE, " +
                    "	u.desce AS idunitelib, " +
                    "   CAST(NVL(p.PV ,0) AS NUMBER(30,2)) PUVENTE, " +
                    "	mag.IDPOINT, " +
                    "	mag.IDTYPEMAGASIN "+
                    "FROM  " +
                    "	INVENTAIRE_FILLE_CPL inv, " +
                    "	( " +
                    "       SELECT  " +
                    "			inv.IDPRODUIT , " +
                    "                   inv.IDMAGASIN, "+
                    "			MAX(inv.DATY) maxDateInventaire " +
                    "		FROM  " +
                    "			INVENTAIRE_FILLE_CPL inv  " +
                    "		WHERE  " +
                    "			inv.ETAT = 11  " +
                    "			AND inv.DATY <= '"+Utilitaire.datetostring(dateMin)+"' " +
                    "		GROUP BY inv.IDPRODUIT,inv.IDMAGASIN " +
                    "	) invm, " +
                    "	( " +
                    "		SELECT  " +
                    "			m.IDPRODUIT , " +
                    "                   dinv.IDMAGASIN, "+
                    "			SUM(nvl(m.ENTREE,0)) ENTREE ,  " +
                    "			SUM(nvl(m.SORTIE ,0)) SORTIE  " +
                    "		FROM  " +
                    "			MVTSTOCKFILLELIB m , " +
                    "			( " +
                    "			SELECT  " +
                    "				inv.IDPRODUIT , " +
                    "                           inv.IDMAGASIN,"+
                    "				MAX(inv.DATY) maxDateInventaire " +
                    "			FROM  " +
                    "				INVENTAIRE_FILLE_CPL inv  " +
                    "			WHERE  " +
                    "				inv.ETAT = 11  " +
                    "				AND inv.DATY <= '"+Utilitaire.datetostring(dateMin)+"' " +
                    "			GROUP BY inv.IDPRODUIT,inv.IDMAGASIN " +
                    "			) dinv " +
                    "		WHERE  " +
                    "			m.IDPRODUIT = dinv.IDPRODUIT(+) " +
                    "                   AND m.IDMAGASIN = dinv.IDMAGASIN(+)"+
                    "			AND m.DATY > dinv.maxDateInventaire " +
                    "			AND m.DATY <= '"+Utilitaire.datetostring(dateMax)+"' " +
                    "		GROUP BY m.IDPRODUIT,dinv.IDMAGASIN " +
                    "	) mvt, " +
                    "	as_ingredients p, " +
                    "	CATEGORIEINGREDIENT tp, " +
                    "	magasin mag, " +
                    "	unite u " +
                    "WHERE  " +
                    "	inv.DATY = invm.maxDateInventaire " +
                    "	AND inv.IDMAGASIN = invm.IDMAGASIN " +
                    "	AND inv.IDPRODUIT = invm.IDPRODUIT " +
                    "	AND inv.IDPRODUIT = mvt.IDPRODUIT(+) " +
                    "	AND inv.IDMAGASIN = mvt.IDMAGASIN(+) " +
                    "	AND inv.IDPRODUIT = p.ID(+) " +
                    "	AND p.CATEGORIEINGREDIENT = tp.ID " +
                    "	AND inv.idmagasin = mag.ID " +
                    "	AND p.UNITE = u.ID(+) "+
                    "	AND ( mvt.sortie > 0  OR mvt.ENTREE > 0 ) "+
                    "   AND inv.ETAT >= 11 ";
        return query;
    }

    public double getTotalVente() {
        return getQuantite() * getPuVente();
    }

    @Override
    public String getTuppleID() {
        return this.id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    
    @Override
    public String getValColLibelle() {
        return this.getIdProduitLib()+";"+this.getPuVente();
    }
       
}
