package paie.edition;

import bean.ClassEtat;

import java.sql.Connection;
import java.sql.Date;

public class PeriodePaie extends ClassEtat {

    private String id;
    private String mois,moisLib;
    private Date datedebut;
    private Date datefin;
    private String idcategoriepaie;
    private int etat;
    private int annee;
    private String categorieLib;

    public PeriodePaie() {
        this.setNomTable("PERIODEPAIE");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PRPA", "getseqperiodepaie");
        this.setId(makePK(c));
    }

    public int getAnnee() {
        return this.annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getMois() {
        return mois;
    }

    public void setMois(String mois) {
        this.mois = mois;
    }

    public Date getDatedebut() {
        return datedebut;
    }

    public void setDatedebut(Date datedebut) {
        this.datedebut = datedebut;
    }

    public Date getDatefin() {
        return datefin;
    }

    public void setDatefin(Date datefin) {
        this.datefin = datefin;
    }

    @Override
    public int getEtat() {
        return etat;
    }

    @Override
    public void setEtat(int etat) {
        this.etat = etat;
    }
    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getMoisLib() {
        return moisLib;
    }

    public void setMoisLib(String moisLib) {
        this.moisLib = moisLib;
    }

    public String getIdcategoriepaie() {
        return idcategoriepaie;
    }

    public void setIdcategoriepaie(String idcategoriepaie) {
        this.idcategoriepaie = idcategoriepaie;
    }

    public String getCategorieLib() {
        return categorieLib;
    }

    public void setCategorieLib(String categorieLib) {
        this.categorieLib = categorieLib;
    }
}
