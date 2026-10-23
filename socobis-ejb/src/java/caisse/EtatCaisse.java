/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package caisse;

import bean.ClassMAPTable;
import java.sql.Date;
import java.time.LocalDate;

import utilitaire.Utilitaire;
import bean.ResultatEtSomme;
import bean.CGenUtil;
import java.sql.Connection;

/**
 *
 * @author 26134
 */
public class EtatCaisse extends ClassMAPTable{
    String id,idCaisse,idCaisselib,idPoint,idPointlib,idTypeCaisse,idTypeCaisselib;
    Date dateDernierReport,daty;
    double montantDernierReport,credit,debit,reste,solde,resteAr,taux;

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public double getTaux() {
        return taux;
    }

    public void setTaux(double taux) {
        this.taux = taux;
    }

    public double getResteAr() {
        return resteAr;
    }

    public void setResteAr(double resteAr) {
        this.resteAr = resteAr;
    }

    public EtatCaisse() {
        this.setNomTable("v_Etatcaisse");
    }

    public double getReste() {
        return reste;
    }

    public void setReste(double reste) {
        this.reste = reste;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdCaisse() {
        return idCaisse;
    }

    public void setIdCaisse(String idCaisse) {
        this.idCaisse = idCaisse;
    }

    public String getIdCaisselib() {
        return idCaisselib;
    }

    public void setIdCaisselib(String idCaisselib) {
        this.idCaisselib = idCaisselib;
    }

    public String getIdPoint() {
        return idPoint;
    }

    public void setIdPoint(String idPoint) {
        this.idPoint = idPoint;
    }

    public String getIdPointlib() {
        return idPointlib;
    }

    public void setIdPointlib(String idPointlib) {
        this.idPointlib = idPointlib;
    }

    public String getIdTypeCaisse() {
        return idTypeCaisse;
    }

    public void setIdTypeCaisse(String idTypeCaisse) {
        this.idTypeCaisse = idTypeCaisse;
    }

    public String getIdTypeCaisselib() {
        return idTypeCaisselib;
    }

    public void setIdTypeCaisselib(String idTypeCaisselib) {
        this.idTypeCaisselib = idTypeCaisselib;
    }

    public Date getDateDernierReport() {
        return dateDernierReport;
    }

    public void setDateDernierReport(Date dateDernierReport) {
        this.dateDernierReport = dateDernierReport;
    }

    public double getMontantDernierReport() {
        return montantDernierReport;
    }

    public void setMontantDernierReport(double montantDernierReport) {
        this.montantDernierReport = montantDernierReport;
    }

    public double getCredit() {
        return credit;
    }

    public void setCredit(double credit) {
        this.credit = credit;
    }

    public double getDebit() {
        return debit;
    }

    public void setDebit(double debit) {
        this.debit = debit;
    }

    public double getSolde() {
        return solde;
    }

    public void setSolde(double solde) {
        this.solde = solde;
    }

    public String getFieldDateName() {
        return "dateDernierReport";
    }
    @Override
    public String getTuppleID() {
        return this.id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public ResultatEtSomme rechercherPage(String[] colInt, String[]valInt, int numPage, String apresWhere, String[]nomColSomme, Connection c, int npp) throws Exception {
        String daty = Utilitaire.dateDuJour();
        if(valInt != null && valInt.length > 1) {
            daty = valInt[1].toString();
        }
        /*String req = "SELECT " +
                "ve.idproduit AS id, " +
                "ve.idproduitlib, " +
                "ve.categorieingredient, " +
                "ve.idtypeproduitlib, " +
                "ve.idmagasin, " +
                "ve.idmagasinlib, " +
                "TO_DATE('01-01-2001', 'DD-MM-YYYY') AS dateDernierMouvement, " +
                "SUM(ve.quantite) AS quantite, " +
                "SUM(ve.entree) AS entree, " +
                "SUM(ve.sortie) AS sortie, " +
                "SUM(ve.reste) AS reste, " +
                "ve.unite, " +
                "ve.idunitelib, " +
                "ve.puvente, " +
                "ve.IDPOINT, " +
                "ve.IDTYPEMAGASIN, " +
                "ve.SEUILMIN, " +
                "ve.SEUILMAX, " +
                "SUM(ve.MONTANTENTREE) AS MONTANTENTREE, " +
                "SUM(ve.MONTANTSORTIE) AS MONTANTSORTIE, " +
                "ve.PU, " +
                "SUM(ve.MONTANTRESTE) AS MONTANTRESTE " +
                "FROM V_ETATSTOCK_ENTREE ve " +
                "WHERE ve.PU > 0 AND ve.daty <= '" + daty + "' " +
                "GROUP BY ve.idproduit, ve.idproduitlib, ve.categorieingredient, " +
                "ve.idtypeproduitlib, ve.idmagasin, ve.idmagasinlib, ve.unite, " +
                "ve.idunitelib, ve.puvente, ve.IDPOINT, ve.IDTYPEMAGASIN, " +
                "ve.SEUILMIN, ve.SEUILMAX, ve.PU " +
                "ORDER BY ve.idproduit, ve.PU";*/
        String req=getReqEtatCaisse(daty);
        //System.out.println(generateQueryCore(Utilitaire.dateDuJourSql(),Utilitaire.dateDuJourSql()));
        ResultatEtSomme rs = CGenUtil.rechercherPage(this, req, numPage, nomColSomme, apresWhere, c, npp);
        return rs;
    }
    public String getReqEtatCaisse(String daty)
    {
        String req =
                "WITH max_inventaire AS (\n" +
                        "    -- Étape 1 : On extrait la date maximale valide et la quantité par COUPLE produit/magasin\n" +
                        "    SELECT rep.IDCAISSE,\n" +
                        "           MAX(rep.DATY) AS max_daty,\n" +
                        "           MAX(rep.MONTANT) KEEP (DENSE_RANK LAST ORDER BY rep.DATY) AS montant_max_daty\n" +
                        "    FROM REPORTCAISSEAVECHEURE rep\n" +
                        "    WHERE rep.ETAT >= 11 and rep.DATY<=TO_DATE('"+daty+"','DD-MM-YYYY')+1\n" +
                        "    GROUP BY rep.IDCAISSE),\n" +

                        "    tauxChangeMax AS (\n" +
                        "         SELECT\n" +
                        "             max(tau.TAUX) KEEP (DENSE_RANK LAST ORDER BY tau.DATY) as taux,\n" +
                        "             tau.IDDEVISE as tauxIdDevise,\n" +
                        "             max(tau.DATY) as tauxDaty\n" +
                        "         FROM TAUXDECHANGE tau\n" +
                        "         WHERE tau.DATY<=TO_DATE('"+daty+"','DD-MM-YYYY')+1\n" +
                        "         GROUP BY tau.IDDEVISE\n" +
                        "     ),\n" +

                        "     somme_precalc AS (\n" +
                        "         SELECT c.ID as idcaisse,\n" +
                        "                c.VAL as idCaisselib,\n" +

                        "                NVL(SUM(CASE\n" +
                        "                    WHEN mff.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025', 'DD-MM-YYYY'))\n" +
                        "                    THEN mff.CREDIT\n" +
                        "                    ELSE 0\n" +
                        "                END), 0) AS credit,\n" +

                        "                NVL(SUM(CASE\n" +
                        "                    WHEN mff.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025', 'DD-MM-YYYY'))\n" +
                        "                    THEN mff.DEBIT\n" +
                        "                    ELSE 0\n" +
                        "                END), 0) AS debit,\n" +

                        "                max(inv.max_daty) AS dateDernierReport,\n" +
                        "                nvl(max(inv.montant_max_daty), 0) as montantDernierReport,\n" +
                        "                c.IDPOINT,\n" +
                        "                p.VAL as idPointlib,\n" +
                        "                c.IDTYPECAISSE,\n" +
                        "                typ.VAL as idTypeCaisselib,\n" +
                        "                c.IDDEVISE,\n" +
                        "                max(tau.taux) as taux\n" +

                        "         FROM Caisse c\n" +

                        "         left join MOUVEMENTCAISSEAVECHEURE mff\n" +
                        "              on mff.IDCAISSE=c.ID\n" +
                        "             and mff.ETAT>=11\n" +
                        "             and mff.DATY<=TO_DATE('"+daty+"','DD-MM-YYYY')+1\n" +

                        "         left JOIN max_inventaire inv\n" +
                        "              ON inv.IDCAISSE=c.ID\n" +

                        "         left JOIN tauxChangeMax TAU\n" +
                        "              ON TAU.tauxIdDevise=C.IDDEVISE\n" +

                        "         left join point p\n" +
                        "              on p.ID=c.IDPOINT\n" +

                        "         left join TYPECAISSE typ\n" +
                        "              on typ.ID=c.IDTYPECAISSE\n" +

                        "         GROUP BY\n" +
                        "              c.id,\n" +
                        "              c.IDPOINT,\n" +
                        "              p.VAL,\n" +
                        "              c.IDTYPECAISSE,\n" +
                        "              typ.VAL,\n" +
                        "              c.VAL,\n" +
                        "              c.IDDEVISE)\n" +

                        "-- Sélection finale\n" +

                        "SELECT idcaisse,\n" +
                        "       idCaisselib||' ('||nvl(IDDEVISE,'AR')||')' as idCaisselib,\n" +
                        "       cast(credit as number(30,2)) as credit,\n" +
                        "       cast(debit as number(30,2)) as debit,\n" +

                        "       cast(montantDernierReport+credit-debit as number(30,2)) as reste,\n" +

                        "       cast(nvl(taux,1) as number(30,2)) as taux,\n" +

                        "       cast((montantDernierReport+credit-debit)*nvl(taux,1) as number(30,2)) as resteAr,\n" +

                        "       TO_DATE('"+daty+"','DD-MM-YYYY') as daty,\n" +

                        "       idcaisse as id,\n" +
                        "       datedernierreport,\n" +
                        "       cast(montantdernierreport as number(30,2)) as montantdernierreport,\n" +
                        "       idpoint,\n" +
                        "       idpointlib,\n" +
                        "       idtypecaisse,\n" +
                        "       idtypecaisselib,\n" +

                        "       (IDCAISSELIB || ' | ' || IDPOINTLIB || ' | ' || IDTYPECAISSELIB || ' | ' || DATEDERNIERREPORT) AS MOTSCLESSS\n" +

                        "FROM somme_precalc";

        System.out.println("===== getReqEtatCaisse Oracle =====");
        System.out.println(req);
        System.out.println("===================================");

        return req;
    }
//    public String getReqEtatCaisse(String daty)
//    {
//        String req="WITH max_inventaire AS (\n" +
//                "    -- Étape 1 : On extrait la date maximale valide et la quantité par COUPLE produit/magasin\n" +
//                "    SELECT rep.IDCAISSE,\n" +
//                "           MAX(rep.DATY)                                             AS max_daty,\n" +
//                "           MAX(rep.MONTANT) KEEP (DENSE_RANK LAST ORDER BY rep.DATY) AS montant_max_daty\n" +
//                "    FROM REPORTCAISSEAVECHEURE rep\n" +
//                "    WHERE rep.ETAT >= 11 and rep.DATY<=TO_DATE('"+daty+"','DD-MM-YYYY')+1\n" +
//                "    GROUP BY rep.IDCAISSE),\n" +
//                "    tauxChangeMax AS (\n" +
//                "         SELECT\n" +
//                "             max(tau.TAUX) KEEP (DENSE_RANK LAST ORDER BY tau.DATY) as taux,\n" +
//                "             tau.IDDEVISE as tauxIdDevise,\n" +
//                "             max(tau.DATY) as tauxDaty\n" +
//                "         FROM TAUXDECHANGE tau where tau.DATY<=TO_DATE('"+daty+"','DD-MM-YYYY')+1 group by IDDEVISE\n" +
//                "     ),\n" +
//                "     somme_precalc AS (\n" +
//                "         SELECT c.ID as idcaisse, c.VAL as idCaisselib,\n" +
//                "                NVL(SUM(CASE\n" +
//                "                            WHEN mff.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025', 'DD-MM-YYYY')) THEN mff.CREDIT\n" +
//                "                            ELSE 0 END), 0)       AS credit,\n" +
//                "\n" +
//                "                NVL(SUM(CASE\n" +
//                "                            WHEN mff.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025', 'DD-MM-YYYY')) THEN mff.DEBIT\n" +
//                "                            ELSE 0 END), 0)       AS debit,\n" +
//                "                max(inv.max_daty)                 AS dateDernierReport,\n" +
//                "                nvl(max(inv.montant_max_daty), 0) as montantDernierReport,\n" +
//                "                c.IDPOINT,p.VAL as idPointlib,c.IDTYPECAISSE,typ.VAL as idTypeCaisselib,c.IDDEVISE,\n" +
//                "                max(tau.taux) as taux\n" +
//                "         FROM Caisse c\n" +
//                "         left join MOUVEMENTCAISSEAVECHEURE mff on mff.IDCAISSE=c.ID and mff.ETAT>=11 and mff.DATY<=TO_DATE('"+daty+"','DD-MM-YYYY')+1\n" +
//                "         left JOIN max_inventaire inv ON inv.IDCAISSE=c.ID\n" +
//                "         left JOIN tauxChangeMax TAU ON TAU.tauxIdDevise=C.IDDEVISE\n" +
//                "         left join point p on p.ID=c.IDPOINT\n" +
//                "         left join TYPECAISSE typ on typ.ID=c.IDTYPECAISSE\n" +
//                "         WHERE c.ACTIF = 1\n" +
//                "         GROUP BY c.id,c.IDPOINT,p.VAL,c.IDTYPECAISSE,typ.VAL,c.VAL,c.IDDEVISE)\n" +
//                "-- Sélection finale\n" +
//                "SELECT idcaisse,idCaisselib||' ('||nvl(IDDEVISE,'AR')||')' as idCaisselib, cast(credit as number(30,2)) as credit, cast(debit as number(30,2)) as debit,\n" +
//                "       cast(montantDernierReport+credit-debit as number(30,2)) as reste, cast(nvl(taux,1) as number(30,2)) as taux,\n" +
//                "       cast((montantDernierReport+credit-debit)*nvl(taux,1) as number(30,2)) as resteAr,\n" +
//                "       TO_DATE('"+daty+"','DD-MM-YYYY') as daty, idcaisse as id,\n" +
//                "       datedernierreport, cast(montantdernierreport as number(30,2)) as montantdernierreport, idpoint, idpointlib, idtypecaisse, idtypecaisselib,\n" +
//                "       (IDCAISSELIB || ' | ' || IDPOINTLIB || ' | ' || IDTYPECAISSELIB || ' | ' || DATEDERNIERREPORT) AS MOTSCLESSS\n" +
//                "FROM somme_precalc";
//        return req;
//    }

    public String generateQueryCore(Date dateMin, Date dateMax ) {
        LocalDate localDate = LocalDate.now();
        Date dateDuJours = Date.valueOf(localDate);
        dateDuJours = Utilitaire.ajoutJourDate(dateDuJours, -1) ;
        String query ;
        //System.out.println(dateMin+"  date du jour ="+dateDuJours);
        if(dateDuJours.equals(dateMin)){
            query = "SELECT * FROM V_ETATCAISSE_devise_AR";
        }else{
            query="SELECT  r.ID\n" +
                    "     ,r.IDCAISSE\n" +
                    "     ,c.val                                                                    AS idcaisseLib\n" +
                    "     ,c.idtypecaisse\n" +
                    "     ,tc.desce                                                                 AS idtypecaisselib\n" +
                    "     ,c.idpoint\n" +
                    "     ,p.desce                                                                  AS idpointlib\n" +
                    "     ,r.DATY dateDernierReport\n" +
                    "     ,CAST(NVL(((r.MONTANT+nvl(mvtAv.CREDIT-mvtAv.DEBIT,0))*NVL(taux.taux,1)),0)                                          AS number(30,2)) montantDernierReport\n" +
                    "     ,CAST(NVL(mvt.debit,0)                                                    AS number(30,2)) debit\n" +
                    "     ,CAST(NVL(mvt.credit,0)                                                   AS number(30,2)) credit\n" +
                    "     ,CAST((NVL(mvt.credit,0) + NVL((r.MONTANT+nvl(mvtAv.CREDIT-mvtAv.DEBIT,0))*NVL(taux.taux,1),0) - NVL(mvt.debit,0)) AS number(30,2)) reste\n" +
                    "     ,'AR'                                                                     AS devise\n" +
                    "FROM REPORTCAISSE_devise r,\n" +
                    "     (\n" +
                    "         SELECT  r.IDCAISSE\n" +
                    "              ,MAX(r.DATY) maxDateReport\n" +
                    "         FROM REPORTCAISSE_devise r\n" +
                    "         WHERE r.ETAT = 11\n" +
                    "           AND r.DATY <='"+ Utilitaire.datetostring(dateMin) + "'\n" +
                    "         GROUP BY  r.IDCAISSE\n" +
                    "     ) rm, (\n" +
                    "         SELECT  m.IDCAISSE\n" +
                    "              ,SUM(nvl((m.DEBIT*t.taux),0)) DEBIT\n" +
                    "              ,SUM(nvl((m.CREDIT*t.taux),0)) CREDIT\n" +
                    "         FROM MOUVEMENTCAISSE_VISE m,\n" +
                    "              (\n" +
                    "                  SELECT  r.IDCAISSE\n" +
                    "                       ,MAX(r.DATY) maxDateReport\n" +
                    "                  FROM REPORTCAISSE r\n" +
                    "                  WHERE r.ETAT = 11\n" +
                    "                    AND r.DATY <= '"+ Utilitaire.datetostring(dateMin) + "'\n" +
                    "                  GROUP BY  r.IDCAISSE\n" +
                    "              ) rm, (\n" +
                    "                  SELECT  ta.*\n" +
                    "                  FROM TAUXDECHANGE ta,\n" +
                    "                       (\n" +
                    "                           SELECT  MAX(daty) AS daty\n" +
                    "                                ,iddevise\n" +
                    "                           FROM TAUXDECHANGE t\n" +
                    "                           WHERE daty <= '"+ Utilitaire.datetostring(dateMin) + "'\n" +
                    "                           GROUP BY  iddevise\n" +
                    "                       ) tmax\n" +
                    "                  WHERE ta.daty = tmax.daty\n" +
                    "                    AND ta.iddevise = tmax.iddevise ) t\n" +
                    "         WHERE m.IDDEVISE = t.iddevise(+)\n" +
                    "           AND m.IDCAISSE = rm.idcaisse(+)\n" +
                    "           AND m.DATY >= '"+ Utilitaire.datetostring(dateMin) + "'\n" +
                    "           AND m.DATY <= '"+ Utilitaire.datetostring(dateMax) + "'\n" +
                    "         GROUP BY  m.IDCAISSE ) mvt\n" +
                    "        ,(\n" +
                    "    SELECT  m.IDCAISSE\n" +
                    "         ,SUM(nvl((m.DEBIT*t.taux),0)) DEBIT\n" +
                    "         ,SUM(nvl((m.CREDIT*t.taux),0)) CREDIT\n" +
                    "    FROM MOUVEMENTCAISSE_VISE m,\n" +
                    "         (\n" +
                    "             SELECT  r.IDCAISSE\n" +
                    "                  ,MAX(r.DATY) maxDateReport\n" +
                    "             FROM REPORTCAISSE r\n" +
                    "             WHERE r.ETAT = 11\n" +
                    "               AND r.DATY <= '"+ Utilitaire.datetostring(dateMin) + "'\n" +
                    "             GROUP BY  r.IDCAISSE\n" +
                    "         ) rm, (\n" +
                    "             SELECT  ta.*\n" +
                    "             FROM TAUXDECHANGE ta,\n" +
                    "                  (\n" +
                    "                      SELECT  MAX(daty) AS daty\n" +
                    "                           ,iddevise\n" +
                    "                      FROM TAUXDECHANGE t\n" +
                    "                      WHERE daty <= '"+ Utilitaire.datetostring(dateMin) + "'\n" +
                    "                      GROUP BY  iddevise\n" +
                    "                  ) tmax\n" +
                    "             WHERE ta.daty = tmax.daty\n" +
                    "               AND ta.iddevise = tmax.iddevise ) t\n" +
                    "    WHERE m.IDDEVISE = t.iddevise(+)\n" +
                    "      AND m.IDCAISSE = rm.idcaisse(+)\n" +
                    "      AND m.DATY >= maxDateReport\n" +
                    "      AND m.DATY < '" +Utilitaire.datetostring(dateMin)  +"'\n" +
                    "    GROUP BY  m.IDCAISSE ) mvtAv\n" +
                    "   ,(\n" +
                    "         SELECT  ta.*\n" +
                    "         FROM TAUXDECHANGE ta,\n" +
                    "              (\n" +
                    "                  SELECT  MAX(daty) AS daty\n" +
                    "                       ,iddevise\n" +
                    "                  FROM TAUXDECHANGE t\n" +
                    "                  WHERE daty <= '" +Utilitaire.datetostring(dateMin)  +"'\n" +
                    "                  GROUP BY  iddevise\n" +
                    "              ) tmax\n" +
                    "         WHERE ta.daty = tmax.daty\n" +
                    "           AND ta.iddevise = tmax.iddevise ) taux, (select * from CAISSE where id not in ('CAIS001')) c, typecaisse tc, point p\n" +
                    "WHERE r.DATY = rm.maxDateReport\n" +
                    "  AND r.IDDEVISE = taux.iddevise(+)\n" +
                    "  AND r.ETAT = 11\n" +
                    "  AND r.IDCAISSE = rm.IDCAISSE\n" +
                    "  AND r.IDCAISSE = c.ID(+)\n" +
                    "  AND r.IDCAISSE = mvt.idcaisse(+)\n" +
                    "  AND r.IDCAISSE = mvtAv.idcaisse(+)\n" +
                    "  AND c.IDTYPECAISSE = tc.ID(+)\n" +
                    "  AND c.IDPOINT = p.ID\n";
        }
        System.out.println(query);
        return query;
    }


    public EtatCaisse[] getEtatCaisseByDate(String daty) throws Exception{
        if(daty==null) daty = Utilitaire.dateDuJour();
        String[] colInt = {"daty"};
        String[] valInt = {daty, daty};

        ResultatEtSomme res = rechercherPage(colInt, valInt, 1, "", null,  null, 1);
        return (EtatCaisse[]) res.getResultat();
    }

}
