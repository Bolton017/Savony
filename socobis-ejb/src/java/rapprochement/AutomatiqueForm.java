package rapprochement;

import bean.CGenUtil;
import bean.ClassMAPTable;
import utilitaire.UtilDB;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.*;
import java.sql.Date;
import java.util.*;

public class AutomatiqueForm extends ClassMAPTable {
    private String id;
    private Date dateMin;
    private Date dateMax;
    private String idCaisseBanque;

    public AutomatiqueForm() {
        setNomTable("automatiqueForm");
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDateMin() {
        return dateMin;
    }

    public void setDateMin(Date dateMin) {
        this.dateMin = dateMin;
    }

    public Date getDateMax() {
        return dateMax;
    }

    public void setDateMax(Date dateMax) {
        this.dateMax = dateMax;
    }

    public String getIdCaisseBanque() {
        return idCaisseBanque;
    }

    public void setIdCaisseBanque(String idCaisseBanque) {
        this.idCaisseBanque = idCaisseBanque;
    }

    static boolean ontUnMotCommun(String s1, String s2) {
        Set<String> mots = new HashSet<>(Arrays.asList(
                s1.toLowerCase().split("\\s+")
        ));

        for (String mot : s2.toLowerCase().split("\\s+")) {
            if (mots.contains(mot)) {
                return true;
            }
        }
        return false;
    }

    public ResultatRapprochement[] rappocher(Connection c) throws Exception {

        boolean localConnection = false;

        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                localConnection = true;
            }


            SousEcritureNR search = new SousEcritureNR();
            search.setIdCaisse(getIdCaisseBanque());

            SousEcritureNR[] sousEcritureNRS =
                    (SousEcritureNR[]) CGenUtil.rechercher(
                            search,
                            null,
                            null,
                            c,
                            " AND DATY>= DATE '"+getDateMin()+"' AND DATY<= DATE '"+getDateMax()+"'"
                    );

            ReleverDetailCpl searchReleve = new ReleverDetailCpl();
            searchReleve.setIdCaisse(getIdCaisseBanque());

            ReleverDetailCpl[] releverLibs =
                    (ReleverDetailCpl[]) CGenUtil.rechercher(
                            searchReleve,
                            null,
                            null,
                            c,
                            " AND DATYVALEUR>= DATE '"+getDateMin()+"' AND DATYVALEUR<= DATE '"+getDateMax()+"'"
                    );

            Set<String> releverIds = new HashSet<>();
            List<ResultatRapprochement> resultats = new ArrayList<>();

            for (SousEcritureNR sousEcritureNR : sousEcritureNRS) {
                for (ReleverDetailCpl relever : releverLibs) {
                    if (releverIds.contains(relever.getId())) continue;
                    if (
                            (sousEcritureNR.getDaty().equals(relever.getDaty())  && sousEcritureNR.getCredit() == relever.getDebit() && sousEcritureNR.getDebit() == relever.getCredit())
                            ||
                            (sousEcritureNR.getDaty().before(relever.getDaty()) && ontUnMotCommun(sousEcritureNR.getLibellePiece(), relever.getDesignation()) && sousEcritureNR.getCredit() == relever.getDebit() && sousEcritureNR.getDebit() == relever.getCredit())
                    ) {

                        releverIds.add(relever.getId());

                        ResultatRapprochement r = new ResultatRapprochement();
                        r.setId(sousEcritureNR.getId() + "_" + relever.getId());
                        r.setIdSousEcriture(sousEcritureNR.getId());
                        r.setIdReleverDetail(relever.getId());
                        if(relever.getDebit()>0){
                            r.setDebit(relever.getDebit());
                        }else{
                            r.setDebit(relever.getCredit());
                        }
                        if(relever.getCredit()>0){
                            r.setCredit(relever.getCredit());
                        }else{
                            r.setCredit(relever.getDebit());
                        }
                        r.setDesignationReleveDetail(relever.getDesignation());
                        r.setDesignationSousEcriture(sousEcritureNR.getLibellePiece());
                        r.setDatyReleveDetail(relever.getDaty());
                        r.setDatySousEcriture(sousEcritureNR.getDaty());

                        resultats.add(r);
                    }
                }
            }

            return resultats.toArray(new ResultatRapprochement[]{});

        } finally {
            if (localConnection && c != null && !c.isClosed()) {
                c.close();
            }
        }
    }

}
