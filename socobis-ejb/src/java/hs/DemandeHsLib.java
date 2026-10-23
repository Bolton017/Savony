package hs;

import bean.CGenUtil;
import chatbot.AiTabDesc;
import chatbot.ClassIA;
import paie.log.LogPersonnel;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;
@AiTabDesc("Demande d'heure sup ")
public class DemandeHsLib extends DemandeHs implements ClassIA {

    private String idPersonnelLib;
    private String bu;
    private String matricule;
    private String etatLib;
    private String semaine;
    private int mois;
    private int annne;
    private double total_heures;
    private double heures_30;
    private double heures_50;

    public DemandeHsLib() throws Exception
    {
        this.setNomTable("DEMANDEHS_CPL");
    }


    @Override
    public String getNomTableIA() {
        return "DEMANDEHS_CPL";
    }

    @Override
    public String getUrlListe() {
        return "/axelle/pages/module.jsp?but=paie/hs/demande-hs-liste.jsp";
    }

    @Override
    public String getUrlAnalyse() {
        return "/axelle/pages/module.jsp?but=paie/hs/demande-hs-liste.jsp";
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
        return this;
    }

    public String getIdPersonnelLib() {
        return idPersonnelLib;
    }

    public void setIdPersonnelLib(String idPersonnelLib) {
        this.idPersonnelLib = idPersonnelLib;
    }

    public String getBu() {
        return bu;
    }

    public void setBu(String bu) {
        this.bu = bu;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }

    public String getSemaine() {
        return semaine;
    }

    public void setSemaine(String semaine) {
        this.semaine = semaine;
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public int getAnnne() {
        return annne;
    }

    public void setAnnne(int annne) {
        this.annne = annne;
    }

    public double getTotal_heures() {
        return total_heures;
    }

    public void setTotal_heures(double total_heures) {
        this.total_heures = total_heures;
    }

    public double getHeures_30() {
        return heures_30;
    }

    public void setHeures_30(double heures_30) {
        this.heures_30 = heures_30;
    }

    public double getHeures_50() {
        return heures_50;
    }

    public void setHeures_50(double heures_50) {
        this.heures_50 = heures_50;
    }


    public DemandeHsLib[] genererDemande(String bu) throws Exception{
        DemandeHsLib[] demandeHs = null;
        Connection c = null;

        try {
            c = (new UtilDB()).GetConn();
            LogPersonnel emp = new LogPersonnel();
            emp.setNomTable("LOG_PERSONNEL_V2");
            String where = " and bu = '" + bu + "' ORDER BY TO_NUMBER(REGEXP_SUBSTR(matricule, '^[0-9]+')) ASC";
            LogPersonnel[] listEmp = (LogPersonnel[]) CGenUtil.rechercher(emp, (String[]) null, (String[]) null, where);
            if (listEmp != null && listEmp.length > 0) {
                demandeHs = new DemandeHsLib[listEmp.length];

                for(int i = 0; i < listEmp.length; ++i) {
                    DemandeHsLib temp = new  DemandeHsLib();
                    temp.setIdPersonnel(listEmp[i].getId());
                    temp.setIdPersonnelLib(listEmp[i].getNom() + " " + listEmp[i].getPrenom());
                    temp.setMatricule(listEmp[i].getMatricule());
                    temp.setDaty(Utilitaire.dateDuJourSql());
                    demandeHs[i] = temp;
                }
            }
        } catch (Exception e) {
            c.rollback();
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null) {
                c.close();
            }

        }

        return demandeHs;
    }
}
