package tableaudebord;

import affichage.Champ;
import affichage.PageRecherche;
import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.ResultatEtSomme;

import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;

import utilitaire.Utilitaire;

public class PageRechercheTableauBord extends PageRecherche {

    private Date dateMin;
    private Date dateMax;
    private boolean isSimpleSearch = false;

    public PageRechercheTableauBord(ClassMAPTable o, HttpServletRequest req, String[] vrt, String[] listInterval, int nbRange, String[] tabAff, int nbAff) throws Exception {
        super(o, req, vrt, listInterval, nbRange, tabAff, nbAff);
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

    public boolean isSimpleSearch() {
        return isSimpleSearch;
    }

    public void setSimpleSearch(boolean simpleSearch) {
        isSimpleSearch = simpleSearch;
    }

    public void setDateMin(String dateMin) {
        this.dateMin = Utilitaire.stringDate(dateMin);
    }

    public void setDateMax(String dateMax) {
        this.dateMax = Utilitaire.stringDate(dateMax);
    }

    public boolean processDateParameter(String dateMin, String dateMax) throws Exception {
        LocalDate today = LocalDate.now();
        Date dateToday = Date.valueOf(today);

        try {
            Date dMin = Utilitaire.stringDate(dateMin);
            Date dMax = Utilitaire.stringDate(dateMax);

            if (dMin == null && dMax == null) {
                isSimpleSearch = true;
                this.dateMin = dateToday;
                this.dateMax = dateToday;
            } else if (dMin == null) {
                isSimpleSearch = false;
                this.dateMin = dateToday;
                this.dateMax = dMax;
            } else if (dMax == null) {
                isSimpleSearch = false;
                this.dateMin = dMin;
                this.dateMax = dateToday;
            } else {
                isSimpleSearch = dMin.equals(dateToday) && dMax.equals(dateToday);
                this.dateMin = dMin;
                this.dateMax = dMax;
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }

        return isSimpleSearch;
    }

    @Override
    public void makeCritere() throws Exception {
        TableauBordBc critere = (TableauBordBc) this.getCritere();
        Vector<String> colIntv = new Vector<>();
        Vector<String> valIntv = new Vector<>();
        Champ[] champs = this.getFormu().getCrtFormu();
        this.getCritere().setMode("select");

        for (Champ champ : champs) {
            Field f = CGenUtil.getField(getBase(), champ.getNom());

            if (champ.getEstIntervalle() == 1 && "daty".equalsIgnoreCase(champ.getNom())) {
                String dateMini = getParamSansNull(champ.getNom() + "1");
                String dateMaxi = getParamSansNull(champ.getNom() + "2");
                processDateParameter(dateMini, dateMaxi);
                continue;
            }

            if (champ.getEstIntervalle() == 1) {
                colIntv.add(champ.getNom());
                valIntv.add(getValeurOuDefaut(champ.getNom() + "1"));
                valIntv.add(getValeurOuDefaut(champ.getNom() + "2"));
            } else if (f.getType().getName().equals("java.lang.String")) {
                String valeur = getParamSansNull(champ.getNom());
                if (valeur != null && !valeur.isEmpty()) {
                    CGenUtil.setValChamp(getCritere(), f, valeur);
                }
            } else {
                this.setAWhere(this.getAWhere() + " and " + f.getName() + " like '" + Utilitaire.getValeurNonNull(getParamSansNull(champ.getNom())) + "'");
            }
        }

        this.setColInt(colIntv.toArray(new String[0]));
        this.setValInt(valIntv.toArray(new String[0]));

        // Gestion du tri
        if (getReq().getParameter("triCol") != null) {
            this.getFormu().getChamp("colonne").setValeur(getReq().getParameter("newcol"));
            String ordre = getReq().getParameter("ordre");
            String direction = (ordre == null || ordre.equals("desc")) ? "asc" : "desc";
            this.getFormu().getChamp("ordre").setValeur(direction);
            this.setOrdre(" order by " + getReq().getParameter("newcol") + " " + direction);
        }

        if (this.getFormu().getChamp("colonne").getValeur() != null &&
                !this.getFormu().getChamp("colonne").getValeur().isEmpty()) {
            this.setOrdre(" order by " + this.getFormu().getChamp("colonne").getValeur() + " " +
                    this.getFormu().getChamp("ordre").getValeur());
        }

        this.setAWhere(this.getAWhere() + this.getOrdre());
    }

    private String getValeurOuDefaut(String nomChamp) {
        String val = getParamSansNull(nomChamp);
        if ((val == null || val.isEmpty()) &&
                this.getFormu().getChamp(nomChamp) != null &&
                this.getFormu().getChamp(nomChamp).getDefaut() != null) {
            return this.getFormu().getChamp(nomChamp).getDefaut();
        }
        return val;
    }

    public String generateTableauBordBcQuery() throws Exception {
        TableauBordBc critere = (TableauBordBc) this.getCritere();
        return "select qc.*, rownum as r from (" + critere.generateQueryCore(dateMin, dateMax) + ") qc where " +
                CGenUtil.makeWhere(this.getCritere()) + " " +
                CGenUtil.makeWhereIntervalle(this.getColInt(), this.getValInt()) ;
//                this.getAWhere();
    }

    protected ResultatEtSomme getTableauBordBcData(Connection c) throws Exception {
        return CGenUtil.rechercherPage(getCritere(), generateTableauBordBcQuery(), getNumPage(), getColSomme(), c, getNpp());
    }

    @Override
    public void preparerDataList(Connection c) throws Exception {
        TableauBordBc critere = (TableauBordBc) this.getCritere();
        critere.setNomTable(getBase().getNomTable());
        makeCritere();
        if (getPremier()) {
            this.setRs(new ResultatEtSomme());
            this.getRs().initialise(getColSomme());
        } else {
//            if (isSimpleSearch) {
//                String recap = getReq().getParameter("recap");
//                recap = "checked";
//                this.getFormu().setRecapcheck(recap);
//                ResultatEtSomme results = getUtilisateur().getDataPage(
//                        getCritere(), getColInt(), getValInt(), getNumPage(), getAWhere(), getColSomme(), c, getNpp());
//                setRs(results);
//            } else {
                setRs(getTableauBordBcData(c));
//            }
        }
        setListe((ClassMAPTable[]) getRs().getResultat());
    }
}

