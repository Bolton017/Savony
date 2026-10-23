package mg.cnaps.compta;
import com.google.gson.Gson;
import utilitaire.Utilitaire;

import bean.AdminGen;
import bean.CGenUtil;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Balance {
 
    private BalanceDetails[] balanceDetails;
    private BalanceDetails total;
    private int moisDebut;
    private int moisFin;
    private int exercice;
    private String debutCompte;
    private String finCompte;
    private String typeCompte;

    public BalanceDetails[] getBalanceDetails(String date1, String date2, String typeCompte, String compteDebut, String compteFin, String exercice) {
        BalanceDetails[] res = new BalanceDetails[0];
        Connection c = null;
        boolean isAnalytique = false;
        if(date1.length()==1) date1= "0"+date1;
        date1 = exercice+"-"+date1+"-01";
        date2 = Utilitaire.getLastDayOfDate("01/"+date2+"/"+exercice);
        try {
            if(c==null) {
                c = new UtilDB().GetConn();
            }

            BalanceDetails bd = new BalanceDetails();
            String[] idCompte = null;
            if(compteDebut == null && compteFin == null || (compteDebut.compareToIgnoreCase("")==0 && compteFin.compareToIgnoreCase("")==0)) {
                idCompte = new String[2];
                idCompte[0] = "0";
                idCompte[1] = "99";
            }else if(compteDebut != null && compteFin == null || (compteDebut.compareToIgnoreCase("")!=0 && compteFin.compareToIgnoreCase("")==0)) {
                idCompte = new String[2];
                idCompte[0] = compteDebut;
                idCompte[1] = "99";
            } else if(compteDebut == null && compteFin != null || (compteDebut.compareToIgnoreCase("")==0 && compteFin.compareToIgnoreCase("")!=0)) {
                idCompte = new String[2];
                idCompte[0] = "0";
                idCompte[1] = compteFin;
            } else {
                idCompte = new String[2];
                idCompte[0] = compteDebut;
                idCompte[1] = compteFin;
            }
            bd.setNomTable("v_balance_details");
            if(typeCompte != null && typeCompte.compareToIgnoreCase("3")==0) {
                bd.setNomTable("v_balance_details_analytique");
                isAnalytique = true;
            }
            res = (mg.cnaps.compta.BalanceDetails[])CGenUtil.rechercher(bd,generateQueryBalanceGeneral(date1,date2,idCompte,isAnalytique));
            Gson gson = new Gson();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return res;
    }

    public BalanceDetails[] getBalanceDetailsAuxiliaire(String date1, String date2, String typeCompte, String compteDebut, String compteFin, String exercice) {
        BalanceDetails[] res = new BalanceDetails[0];
        Connection c = null;
        boolean isAnalytique = false;
        if(date1.length()==1) date1= "0"+date1;
        date1 = exercice+"-"+date1+"-01";
        date2 = Utilitaire.getLastDayOfDate("01/"+date2+"/"+exercice);
        try {
            if(c==null) {
                c = new UtilDB().GetConn();
            }

            BalanceDetails bd = new BalanceDetails();
            String[] idCompte = null;
            if(compteDebut == null && compteFin == null || (compteDebut.compareToIgnoreCase("")==0 && compteFin.compareToIgnoreCase("")==0)) {
                idCompte = new String[2];
                idCompte[0] = "0";
                idCompte[1] = "99";
            }else if(compteDebut != null && compteFin == null || (compteDebut.compareToIgnoreCase("")!=0 && compteFin.compareToIgnoreCase("")==0)) {
                idCompte = new String[2];
                idCompte[0] = compteDebut;
                idCompte[1] = "99";
            } else if(compteDebut == null && compteFin != null || (compteDebut.compareToIgnoreCase("")==0 && compteFin.compareToIgnoreCase("")!=0)) {
                idCompte = new String[2];
                idCompte[0] = "0";
                idCompte[1] = compteFin;
            } else {
                idCompte = new String[2];
                idCompte[0] = compteDebut;
                idCompte[1] = compteFin;
            }

            bd.setNomTable("v_balance_details_aux");
//            if(typeCompte != null && typeCompte.compareToIgnoreCase("3")==0) {
//                bd.setNomTable("v_balance_details_analytique");
//                isAnalytique = true;
//            }


            String requete = generateQueryBalanceAux(date1,date2,idCompte,isAnalytique);
            res = (mg.cnaps.compta.BalanceDetails[])CGenUtil.rechercher(bd,requete);
            Gson gson = new Gson();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return res;
    }

    public String generateQueryBalance(String date1, String date2, String[] compte, boolean isAnalytique) {
        String query = "WITH latest_entry AS (\n" +
                "SELECT compte, debit, credit, datecomptable as max_daty\n" +
                "FROM (\n" +
                "         SELECT\n" +
                "             cs.compte,\n" +
                "             cs.debit,\n" +
                "             cs.credit,\n" +
                "             ce.datecomptable,\n" +
                "             ROW_NUMBER() OVER (PARTITION BY cs.compte ORDER BY ce.datecomptable DESC) AS rn\n" +
                "         FROM compta_sous_ecriture cs\n" +
                "                  JOIN compta_ecriture ce ON ce.id = cs.idmere\n" +
                "         WHERE ce.journal = '" + ConstanteCompta.journalReport + "'\n" +
                "           AND ce.etat >= 11\n" +
                "           AND ce.datecomptable < DATE '" + date1 + "'\n" +
                "     ) sub\n" +
                "WHERE rn = 1" +
                "),\n" +
                "     im AS (\n" +
                "         SELECT\n" +
                "             c.compte,\n" +
                "             NVL(le.max_daty, DATE '2001-01-01') AS maxDaty,\n" +
                "             NVL(le.debit, 0) AS debit,\n" +
                "             NVL(le.credit, 0) AS credit\n" +
                "         FROM compta_compte c\n" +
                "                  LEFT JOIN latest_entry le ON le.compte = c.compte\n" +
                "     ),\n" +
                "     ce_filtered AS (\n" +
                "         SELECT ce.id, datecomptable, cse.debit, cse.credit\n" +
                "         FROM compta_ecriture ce\n" +
                "         join compta_sous_ecriture cse on cse.idmere = ce.id\n" +
                "         WHERE ce.etat >= 11\n" +
                "           AND datecomptable < DATE '" + date1 + "'\n" +
                "     ),\n" +
                "     em AS (\n" +
                "         SELECT\n" +
                "             CAST(cse.compte AS VARCHAR2(100)) AS compte,\n" +
                "             SUM(cse.debit) AS debit,\n" +
                "             SUM(cse.credit) AS credit\n" +
                "         FROM\n" +
                "             compta_sous_ecriture cse\n" +
                "                 JOIN compta_ecriture ce ON ce.id = cse.idmere\n" +
                "         WHERE\n" +
                "             ce.datecomptable >= DATE '" + date1 + "' and ce.datecomptable <= DATE '" + date2 + "'\n" +
                "           AND ce.etat >= 11\n" +
                "           AND ce.journal != '" + ConstanteCompta.journalReport + "'\n" +
                "         GROUP BY\n" +
                "             cse.compte\n" +
                "     )\n" +
                "SELECT\n" +
                "    c.compte,\n" +
                "    c.libelle as libelleCompte,\n" +
                "    sum(ce.credit) as currentCred,\n" +
                "    avg(im.credit) as imCred,\n" +
                "    NVL(SUM(ce.debit), 0) + NVL(avg(im.debit), 0) AS cumulDebit,\n" +
                "    NVL(SUM(ce.credit), 0) + NVL(avg(im.credit), 0) AS cumulCredit,\n" +
                "    NVL(avg(em.debit), 0) as debit,\n" +
                "    NVL(avg(em.credit), 0) as credit,\n" +
                "    TO_NUMBER(SUBSTR(c.compte, 1, 3)) AS compte3, \n" +
                "    TO_NUMBER(SUBSTR(c.compte, 1, 2)) AS compte2 \n" +
                "FROM compta_compte c \n" +
                "         LEFT JOIN em on em.compte = c.compte\n" +
                "         LEFT JOIN im ON im.compte = c.compte\n" +
                "         LEFT JOIN compta_sous_ecriture cse ON cse.compte = c.compte\n" +
                "         LEFT JOIN ce_filtered ce ON ce.id = cse.idmere AND ce.datecomptable > im.maxDaty\n" +
                " WHERE (c.compte like '401%' or c.compte like '411%') AND c.compte >= '" + compte[0] + "' and c.compte <= '" + compte[1] + "'\n";
        if (isAnalytique) query += " and c.typecompte = '" + ConstanteCompta.type_compte_analytique + "'\n";
        query += " GROUP BY c.compte, c.libelle \n" +
                "order by c.compte asc";

        return query;
    }


    public String generateQueryBalanceGeneral(String date1, String date2, String[] compte, boolean isAnalytique) {

        boolean includeAnalytiqueBranch = isAnalytique;
        String query = "WITH ecritures_unifiees AS (\n" +
                "    SELECT\n" +
                "        cse.compte AS cle,\n" +
                "        cse.debit,\n" +
                "        cse.credit,\n" +
                "        cse.idmere,\n" +
                "        ce.datecomptable,\n" +
                "        ce.etat,\n" +
                "        ce.journal\n" +
                "    FROM compta_sous_ecriture cse\n" +
                "    JOIN compta_ecriture ce ON ce.id = cse.idmere\n";

        if (includeAnalytiqueBranch) {
            query += "\n    UNION ALL\n\n" +
                    "    SELECT\n" +
                    "        cse.analytique AS cle,\n" +
                    "        cse.debit,\n" +
                    "        cse.credit,\n" +
                    "        cse.idmere,\n" +
                    "        ce.datecomptable,\n" +
                    "        ce.etat,\n" +
                    "        ce.journal\n" +
                    "    FROM compta_sous_ecriture cse\n" +
                    "    JOIN compta_ecriture ce ON ce.id = cse.idmere\n" +
                    "    WHERE cse.analytique IS NOT NULL\n";
        }

        
        query += "),\n" +
                "latest_entry AS (\n" +
                "    SELECT\n" +
                "        eu.cle,\n" +
                "        SUM(eu.debit)  AS debit,\n" +
                "        SUM(eu.credit) AS credit,\n" +
                "        MAX(eu.datecomptable) AS max_daty\n" +
                "    FROM ecritures_unifiees eu\n" +
                "    WHERE eu.journal = '" + ConstanteCompta.journalReport + "'\n" +
                "      AND eu.etat >= 11\n" +
                "      AND eu.datecomptable < DATE '" + date1 + "'\n" +
                "    GROUP BY eu.cle\n" +
                "),\n" +
                "im AS (\n" +
                "    SELECT\n" +
                "        c.compte,\n" +
                "        NVL(le.max_daty, DATE '2001-01-01') AS maxDaty,\n" +
                "        NVL(le.debit, 0)  AS debit,\n" +
                "        NVL(le.credit, 0) AS credit\n" +
                "    FROM compta_compte c\n" +
                "    LEFT JOIN latest_entry le ON le.cle = c.compte\n" +
                "),\n" +
                "ce_filtered AS (\n" +
                "    SELECT\n" +
                "        eu.idmere,\n" +
                "        eu.cle,\n" +
                "        eu.datecomptable,\n" +
                "        eu.debit,\n" +
                "        eu.credit\n" +
                "    FROM ecritures_unifiees eu\n" +
                "    WHERE eu.etat >= 11\n" +
                "      AND eu.datecomptable < DATE '" + date1 + "'\n" +
                "),\n" +
                "em AS (\n" +
                "    SELECT\n" +
                "        CAST(eu.cle AS VARCHAR2(100)) AS compte,\n" +
                "        SUM(eu.debit)  AS debit,\n" +
                "        SUM(eu.credit) AS credit\n" +
                "    FROM ecritures_unifiees eu\n" +
                "    WHERE eu.datecomptable >= DATE '" + date1 + "'\n" +
                "      AND eu.datecomptable <= DATE '" + date2 + "'\n" +
                "      AND eu.etat >= 11\n" +
                "      AND eu.journal != '" + ConstanteCompta.journalReport + "'\n" +
                "    GROUP BY eu.cle\n" +
                "),\n" +
                "agg AS (\n" +
                "    SELECT\n" +
                "        SUBSTR(c.compte, 1, 6) AS compte,\n" +
                "        NVL(cp.libelle, 'Autres') AS libelleCompte,\n" +
                "        SUM(ce.credit) AS currentCred,\n" +
                "        SUM(im.credit) AS imCred,\n" +
                "        NVL(SUM(ce.debit), 0)  + NVL(SUM(im.debit), 0)  AS cumulDebit,\n" +
                "        NVL(SUM(ce.credit), 0) + NVL(SUM(im.credit), 0) AS cumulCredit,\n" +
                "        NVL(SUM(em.debit), 0)  AS debit,\n" +
                "        NVL(SUM(em.credit), 0) AS credit,\n" +
                "        TO_NUMBER(SUBSTR(c.compte, 1, 3)) AS compte3,\n" +
                "        TO_NUMBER(SUBSTR(c.compte, 1, 2)) AS compte2\n" +
                "    FROM compta_compte c\n" +
                "    LEFT JOIN em ON em.compte = c.compte\n" +
                "    LEFT JOIN im ON im.compte = c.compte\n" +
                "    LEFT JOIN ce_filtered ce\n" +
                "        ON ce.cle = c.compte\n" +
                "       AND ce.datecomptable > im.maxDaty\n" +
                "    LEFT JOIN compta_compte cp\n" +
                "        ON cp.compte = SUBSTR(c.compte, 1, 6)\n" +
                "    WHERE c.compte >= '" + compte[0] + "'\n" +
                "      AND c.compte <= '" + compte[1] + "'\n";

        if (isAnalytique) query += "      AND c.typecompte = '" + ConstanteCompta.type_compte_analytique + "'\n";

        query += "    GROUP BY\n" +
                "        SUBSTR(c.compte, 1, 6),\n" +
                "        NVL(cp.libelle, 'Autres'),\n" +
                "        TO_NUMBER(SUBSTR(c.compte, 1, 3)),\n" +
                "        TO_NUMBER(SUBSTR(c.compte, 1, 2))\n" +
                ")\n" +
                // -- Un seul et unique arrondi, ici, à l'affichage --
                "SELECT\n" +
                "    compte,\n" +
                "    libelleCompte,\n" +
                "    TO_CHAR(ROUND(currentCred, 2),  'FM9999999999999990.00', 'NLS_NUMERIC_CHARACTERS=''. ''') AS currentCred,\n" +
                "    TO_CHAR(ROUND(imCred, 2),       'FM9999999999999990.00', 'NLS_NUMERIC_CHARACTERS=''. ''') AS imCred,\n" +
                "    TO_CHAR(ROUND(cumulDebit, 2),   'FM9999999999999990.00', 'NLS_NUMERIC_CHARACTERS=''. ''') AS cumulDebit,\n" +
                "    TO_CHAR(ROUND(cumulCredit, 2),  'FM9999999999999990.00', 'NLS_NUMERIC_CHARACTERS=''. ''') AS cumulCredit,\n" +
                "    TO_CHAR(ROUND(debit, 2),        'FM9999999999999990.00', 'NLS_NUMERIC_CHARACTERS=''. ''') AS debit,\n" +
                "    TO_CHAR(ROUND(credit, 2),       'FM9999999999999990.00', 'NLS_NUMERIC_CHARACTERS=''. ''') AS credit,\n" +
                "    compte3,\n" +
                "    compte2\n" +
                "FROM agg\n" +
                "ORDER BY compte ASC";
        return query;
    }
    
/* 
    public String generateQueryBalanceGeneral(String date1, String date2, String[] compte, boolean isAnalytique,boolean isAUx,boolean isGeneral) {
        String query = "WITH ecritures_unifiees AS (\n" +
        "    SELECT\n" +
        "        cse.compte AS cle,\n" +
        "        cse.debit,\n" +
        "        cse.credit,\n" +
        "        cse.idmere,\n" +
        "        ce.datecomptable,\n" +
        "        ce.etat,\n" +
        "        ce.journal\n" +
        "    FROM compta_sous_ecriture cse\n" +
        "    JOIN compta_ecriture ce ON ce.id = cse.idmere\n" +
        "\n" +
        "    UNION ALL\n" +
        "\n" +
        "    SELECT\n" +
        "        cse.analytique AS cle,\n" +
        "        cse.debit,\n" +
        "        cse.credit,\n" +
        "        cse.idmere,\n" +
        "        ce.datecomptable,\n" +
        "        ce.etat,\n" +
        "        ce.journal\n" +
        "    FROM compta_sous_ecriture cse\n" +
        "    JOIN compta_ecriture ce ON ce.id = cse.idmere\n" +
        "    WHERE cse.analytique IS NOT NULL\n" +
        "),\n" +
        "report_sum AS (\n" +
        "    SELECT\n" +
        "        eu.cle,\n" +
        "        SUM(eu.debit) AS total_debit,\n" +
        "        SUM(eu.credit) AS total_credit,\n" +
        "        MAX(eu.datecomptable) AS max_daty\n" +
        "    FROM ecritures_unifiees eu\n" +
        "    WHERE eu.journal = '" + ConstanteCompta.journalReport + "'\n" +
        "      AND eu.etat >= 11\n" +
        "      AND eu.datecomptable < DATE '" + date1 + "'\n" +
        "    GROUP BY eu.cle\n" +
        "),\n" +
        "im AS (\n" +
        "    SELECT\n" +
        "        c.compte,\n" +
        "        NVL(rs.max_daty, DATE '2001-01-01') AS maxDaty,\n" +
        "        CASE WHEN NVL(rs.total_debit,0) - NVL(rs.total_credit,0) > 0\n" +
        "             THEN NVL(rs.total_debit,0) - NVL(rs.total_credit,0)\n" +
        "             ELSE 0 END AS debit,\n" +
        "        CASE WHEN NVL(rs.total_debit,0) - NVL(rs.total_credit,0) < 0\n" +
        "             THEN NVL(rs.total_credit,0) - NVL(rs.total_debit,0)\n" +
        "             ELSE 0 END AS credit\n" +
        "    FROM compta_compte c\n" +
        "    LEFT JOIN report_sum rs ON rs.cle = c.compte\n" +
        "    WHERE c.compte >= '" + compte[0] + "'\n" +
        "      AND c.compte <= '" + compte[1] + "'\n";
        if (isAnalytique) query += "      AND c.typecompte = '" + ConstanteCompta.type_compte_analytique + "'\n";
        query +=
        "),\n" +
        "ce_filtered AS (\n" +
        "    SELECT\n" +
        "        eu.idmere,\n" +
        "        eu.cle,\n" +
        "        eu.datecomptable,\n" +
        "        eu.debit,\n" +
        "        eu.credit\n" +
        "    FROM ecritures_unifiees eu\n" +
        "    WHERE eu.etat >= 11\n" +
        "      AND eu.datecomptable < DATE '" + date1 + "'\n" +
        "),\n" +
        "im_agg AS (\n" +
        "    SELECT SUBSTR(im.compte, 1, 6) AS compte6,\n" +
        "           SUM(im.debit) AS debit,\n" +
        "           SUM(im.credit) AS credit\n" +
        "    FROM im\n" +
        "    GROUP BY SUBSTR(im.compte, 1, 6)\n" +
        "),\n" +
        "ce_agg AS (\n" +
        "    SELECT SUBSTR(im.compte, 1, 6) AS compte6,\n" +
        "           SUM(ce.debit) AS debit,\n" +
        "           SUM(ce.credit) AS credit\n" +
        "    FROM im\n" +
        "    LEFT JOIN ce_filtered ce\n" +
        "        ON ce.cle = im.compte\n" +
        "       AND ce.datecomptable > im.maxDaty\n" +
        "    GROUP BY SUBSTR(im.compte, 1, 6)\n" +
        "),\n" +
        "em AS (\n" +
        "    SELECT\n" +
        "        CAST(SUBSTR(eu.cle, 1, 6) AS VARCHAR2(100)) AS compte,\n" +
        "        SUM(eu.debit) AS debit,\n" +
        "        SUM(eu.credit) AS credit\n" +
        "    FROM ecritures_unifiees eu\n" +
        "    WHERE eu.datecomptable >= DATE '" + date1 + "'\n" +
        "      AND eu.datecomptable <= DATE '" + date2 + "'\n" +
        "      AND eu.etat >= 11\n" +
        "      AND eu.journal != '" + ConstanteCompta.journalReport + "'\n" +
        "    GROUP BY SUBSTR(eu.cle, 1, 6)\n" +
        ")\n" +
        "SELECT\n" +
        "    c6.compte6 AS compte,\n" +
        "    NVL(cp.libelle, 'Autres') AS libelleCompte,\n" +
        "    NVL(ce_agg.credit, 0) AS currentCred,\n" +
        "    NVL(im_agg.credit, 0) AS imCred,\n" +
        "    NVL(ce_agg.debit, 0) + NVL(im_agg.debit, 0) AS cumulDebit,\n" +
        "    NVL(ce_agg.credit, 0) + NVL(im_agg.credit, 0) AS cumulCredit,\n" +
        "    NVL(em.debit, 0) AS debit,\n" +
        "    NVL(em.credit, 0) AS credit,\n" +
        "    TO_NUMBER(SUBSTR(c6.compte6, 1, 3)) AS compte3,\n" +
        "    TO_NUMBER(SUBSTR(c6.compte6, 1, 2)) AS compte2\n" +
        "FROM (SELECT DISTINCT SUBSTR(compte, 1, 6) AS compte6 FROM im) c6\n" +
        "LEFT JOIN im_agg ON im_agg.compte6 = c6.compte6\n" +
        "LEFT JOIN ce_agg ON ce_agg.compte6 = c6.compte6\n" +
        "LEFT JOIN em ON em.compte = c6.compte6\n" +
        "LEFT JOIN compta_compte cp ON cp.compte = c6.compte6\n" +
        "ORDER BY c6.compte6 ASC";

       System.out.println(query);
        return query;
    }*/

    public String generateQueryBalanceAux(String date1, String date2, String[] compte, boolean isAnalytique) {
    String query = "WITH latest_entry AS (\n" +
            "    SELECT compte, debit, credit, datecomptable AS max_daty\n" +
            "    FROM (\n" +
            "        SELECT\n" +
            "            t.compteauxiliaire AS compte,\n" +
            "            cs.debit,\n" +
            "            cs.credit,\n" +
            "            ce.datecomptable,\n" +
            "            ROW_NUMBER() OVER (PARTITION BY t.compteauxiliaire ORDER BY ce.datecomptable DESC) AS rn\n" +
            "        FROM compta_sous_ecriture cs\n" +
            "        JOIN compta_ecriture ce ON ce.id = cs.idmere\n" +
            "        JOIN tiers t ON t.id = cs.compte_aux\n" +
            "        WHERE ce.journal = '" + ConstanteCompta.journalReport + "'\n" +
            "          AND ce.etat >= 11\n" +
            "          AND ce.datecomptable < DATE '" + date1 + "'\n" +
            "    ) sub\n" +
            "    WHERE rn = 1\n" +
            "),\n" +
            "im AS (\n" +
            "    SELECT\n" +
            "        c.compte,\n" +
            "        NVL(le.max_daty, DATE '2001-01-01') AS maxDaty,\n" +
            "        NVL(le.debit, 0) AS debit,\n" +
            "        NVL(le.credit, 0) AS credit\n" +
            "    FROM compte_aux c\n" +
            "    LEFT JOIN latest_entry le ON le.compte = c.compte\n" +
            "),\n" +
            "ce_filtered AS (\n" +
            "    SELECT\n" +
            "        ce.id,\n" +
            "        t.compteauxiliaire AS compte,\n" +
            "        ce.datecomptable,\n" +
            "        cse.debit,\n" +
            "        cse.credit\n" +
            "    FROM compta_ecriture ce\n" +
            "    JOIN compta_sous_ecriture cse ON cse.idmere = ce.id\n" +
            "    JOIN tiers t ON t.id = cse.compte_aux\n" +
            "    WHERE ce.etat >= 11\n" +
            "      AND ce.datecomptable < DATE '" + date1 + "'\n" +
            "),\n" +
            "em AS (\n" +
            "    SELECT\n" +
            "        t.compteauxiliaire AS compte,\n" +
            "        SUM(cse.debit) AS debit,\n" +
            "        SUM(cse.credit) AS credit\n" +
            "    FROM compta_sous_ecriture cse\n" +
            "    JOIN compta_ecriture ce ON ce.id = cse.idmere\n" +
            "    JOIN tiers t ON t.id = cse.compte_aux\n" +
            "    WHERE ce.datecomptable >= DATE '" + date1 + "'\n" +
            "      AND ce.datecomptable <= DATE '" + date2 + "'\n" +
            "      AND ce.etat >= 11\n" +
            "      AND ce.journal != '" + ConstanteCompta.journalReport + "'\n" +
            "    GROUP BY t.compteauxiliaire\n" +
            ")\n" +
            "SELECT\n" +
            "    c.compte,\n" +
            "    c.libelle AS libelleCompte,\n" +
            "    SUM(ce.credit) AS currentCred,\n" +
            "    AVG(im.credit) AS imCred,\n" +
            "    NVL(SUM(ce.debit),0) + NVL(AVG(im.debit),0) AS cumulDebit,\n" +
            "    NVL(SUM(ce.credit),0) + NVL(AVG(im.credit),0) AS cumulCredit,\n" +
            "    NVL(AVG(em.debit),0) AS debit,\n" +
            "    NVL(AVG(em.credit),0) AS credit,\n" +
            "    CASE WHEN REGEXP_LIKE(SUBSTR(c.compte,1,3), '^[0-9]+$') " +
            "         THEN TO_NUMBER(SUBSTR(c.compte,1,3)) END AS compte3,\n" +
            "    CASE WHEN REGEXP_LIKE(SUBSTR(c.compte,1,2), '^[0-9]+$') " +
            "         THEN TO_NUMBER(SUBSTR(c.compte,1,2)) END AS compte2\n" +
            "FROM compte_aux c\n" +
            "LEFT JOIN em ON em.compte = c.compte\n" +
            "LEFT JOIN im ON im.compte = c.compte\n" +
            "LEFT JOIN ce_filtered ce ON ce.compte = c.compte AND ce.datecomptable > im.maxDaty\n" +
            "WHERE c.compte >= '" + compte[0] + "'\n" +
            "  AND c.compte <= '" + compte[1] + "'\n";

    if (isAnalytique) {
        query += "  AND c.typecompte = '" + ConstanteCompta.type_compte_analytique + "'\n";
    }

    query += "GROUP BY c.compte, c.libelle\n" +
            "ORDER BY c.compte ASC";
        return query;
    }

    public Balance(String exercice, String typeCompte, String moisDebut, String moisFin, String compteDebut, String compteFin) throws Exception {
        setExercice(exercice);
        setTypeCompte(typeCompte);
        setMoisDebut(moisDebut);
        setMoisFin(moisFin);
        setDebutCompte(compteDebut);
        setFinCompte(compteFin);
        this.setBalanceDetails(getBalanceDetails(moisDebut, moisFin, typeCompte, compteDebut, compteFin, exercice));
        calculerTotal();
        calculerSousTotal();
    }

    public Balance(String exercice, String typeCompte, String moisDebut, String moisFin, String compteDebut, String compteFin, Boolean aux) throws Exception {
        setExercice(exercice);
        setTypeCompte(typeCompte);
        setMoisDebut(moisDebut);
        setMoisFin(moisFin);
        setDebutCompte(compteDebut);
        setFinCompte(compteFin);
        if(aux) {
            this.setBalanceDetails(getBalanceDetailsAuxiliaire(moisDebut, moisFin, typeCompte, compteDebut, compteFin, exercice));
        }
        calculerTotal();
//        calculerSousTotal();
    }

    //
    public void calculerTotal() throws Exception {
        setTotal(new BalanceDetails());
        getTotal().setCumulDebit(AdminGen.calculSommeDouble(this.getBalanceDetails(), "cumulDebit"));
        getTotal().setCumulCredit(AdminGen.calculSommeDouble(this.getBalanceDetails(), "cumulCredit"));
        getTotal().setCredit(AdminGen.calculSommeDouble(this.getBalanceDetails(), "credit"));
        getTotal().setDebit(AdminGen.calculSommeDouble(this.getBalanceDetails(), "debit"));
        calculerTotalSD();
        calculerTotalSC();
    }
    public void calculerTotalSD() throws Exception {
        double sd = 0;
        for (BalanceDetails bd : balanceDetails) {
            sd += bd.getSoldeDebit();
        }
        sd = Utilitaire.arrondir(sd, 2);
        getTotal().setSoldeDebit(sd);
    }
    public void calculerTotalSC() throws Exception {
        double sc = 0;
        for (BalanceDetails bd : balanceDetails) {
            sc += bd.getSoldeCredit();
        }
        sc = Utilitaire.arrondir(sc, 2);
        getTotal().setSoldeCredit(sc);
    }

    public void calculerSousTotal() throws Exception {
//        parcourir anle balacedetails atao anaty list
//        rehefa miparcour ka miova le compte3 : tys mitovy le compte 3 sy 3-1 dia stockena ilay teo aloha
//        a chaque tour de boucle micreer variable roa :
//            total2 dia total1 atomboka 0
//        isaky ny misy iray tsy mitovy ilay 3 dia stockena ilay precedent
//        raha vao samihafa le precedent sy izy dia mamorona balancedetails vaovao dia ny valeur totalanle valeur dia le compte compte3 na compte2
        List<BalanceDetails> list = new ArrayList<>();
       if (getBalanceDetails() == null || getBalanceDetails().length <= 1) {
            return;
        }
        BalanceDetails bd = getBalanceDetails()[0];

        BalanceDetails bd3 = new BalanceDetails(bd.getCredit(),bd.getDebit(),"SOUS TOTAUX "+bd.getCompte3(),bd.getCumulCredit(),bd.getCumulDebit(),bd.getCompte2(),bd.getCompte3());
        BalanceDetails bd2 = new BalanceDetails(bd.getCredit(),bd.getDebit(),"SOUS TOTAUX "+bd.getCompte2(),bd.getCumulCredit(),bd.getCumulDebit(),bd.getCompte2(),bd.getCompte3());
        int index = 0;
        for (int i = 1;i < getBalanceDetails().length; i++) {
            BalanceDetails details = getBalanceDetails()[i];
            list.add(details);
            index++;
            if (details.getCompte3()==bd3.getCompte3()) {
                bd3.updateDetails(details.getCredit(),details.getDebit(),details.getCumulCredit(),details.getCumulDebit());
            }
            else {
                list.add(index-1,bd3);
                index++;
                bd = details;
                bd3 = new BalanceDetails(bd.getCredit(),bd.getDebit(),"SOUS TOTAUX "+bd.getCompte3(),bd.getCumulCredit(),bd.getCumulDebit(),bd.getCompte2(),bd.getCompte3());
            }
            if (details.getCompte2()==bd2.getCompte2()) {
                bd2.updateDetails(details.getCredit(),details.getDebit(),details.getCumulCredit(),details.getCumulDebit());
            }
            else {
                list.add(index-1,bd2);
                index++;
                bd = details;
                bd2 = new BalanceDetails(bd.getCredit(),bd.getDebit(),"SOUS TOTAUX "+bd.getCompte2(),bd.getCumulCredit(),bd.getCumulDebit(),bd.getCompte2(),bd.getCompte3());
            }
        }
        setBalanceDetails(list.toArray(new BalanceDetails[0]));
    }

    public BalanceDetails[] getBalanceDetails() {
        return balanceDetails;
    }
    
    public void setBalanceDetails(BalanceDetails[] balanceDetails) {
        this.balanceDetails = balanceDetails;
    }

    public BalanceDetails getTotal() {
        return total;
    }
    
    public void setTotal(BalanceDetails total) {
        this.total = total;
    }

    public String getDateDebut() {
        return "01/" + Utilitaire.completerInt(2, getMoisDebut()) + "/" + getExercice();
    }
    public String getDateFin() {
        return Utilitaire.formatterDaty(Utilitaire.getLastDayOfDate("01/" + Utilitaire.completerInt(2, getMoisFin()) + "/" + getExercice()));
    }


    public int getMoisDebut() {
        return moisDebut;
    }

    public void setMoisDebut(int moisDebut) {
        this.moisDebut = moisDebut;
    }
    public void setMoisDebut(String moisDebut) throws Exception {
        int deb = Integer.parseInt(moisDebut);
        setMoisDebut(deb);
    }
    public void setMoisFin(String moisFin) throws Exception {
        int fin = Integer.parseInt(moisFin);
        setMoisFin(fin);
    }

    public int getMoisFin() {
        return moisFin;
    }

    public void setMoisFin(int moisFin){
        this.moisFin = moisFin;
    }

    public int getExercice() {
        return exercice;
    }

    public void setExercice(int exercice) {
        this.exercice = exercice;
    }
    public void setExercice(String exercice) throws Exception {
        int ex = Integer.parseInt(exercice);
        setExercice(ex);
    }

    public String getDebutCompte() {
        return debutCompte;
    }

    public void setDebutCompte(String debutCompte) {
        this.debutCompte = debutCompte;
    }

    public String getFinCompte() {
        return finCompte;
    }

    public void setFinCompte(String finCompte) {
        this.finCompte = finCompte;
    }

    public String getTypeCompte() {
        return typeCompte;
    }

    public void setTypeCompte(String typeCompte) {
        this.typeCompte = typeCompte;
    }
}
