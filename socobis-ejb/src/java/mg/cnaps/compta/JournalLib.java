package mg.cnaps.compta;

import bean.CGenUtil;
import utilitaire.UtilDB;

import java.sql.Connection;

public class JournalLib extends Journal {
    private int mois, annee;
    private ComptaSousEcritureLibJournal [] detail;
    int total = 0;

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public ComptaSousEcritureLibJournal [] formaterData(ComptaSousEcritureLibJournal [] arg) throws Exception{
        String idecriture = "";
        int tot = 0;
        for (int i = 0; i < arg.length; i++) {
            if(arg[i].getIdMere().compareToIgnoreCase(idecriture)==0){
                ComptaSousEcritureLibJournal temp = new ComptaSousEcritureLibJournal();
                temp.setDaty(arg[i].getDaty());
                temp.setCompte(arg[i].getCompte());
                temp.setCredit(arg[i].getCredit());
                temp.setDebit(arg[i].getDebit());
                arg[i] = temp;
            }else{
                idecriture = arg[i].getIdMere();
                tot++;

            }
        }
        setTotal(tot);
        return arg;
    }

    public ComptaSousEcritureLibJournal [] getDetailJournal() throws Exception{
        ComptaSousEcritureLibJournal [] res = null;
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            String awhere = " AND idjournal= '"+this.getId()+"' AND mois="+this.getMois()+" AND annee="+this.getAnnee()+" ORDER BY IDMERE";
            res = (ComptaSousEcritureLibJournal[]) CGenUtil.rechercher(new ComptaSousEcritureLibJournal(), null, null, c, awhere);
        }catch (Exception e){
            throw e;
        }finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
        return res;
    }

    public JournalLib(String id, int mois, int annee) throws Exception {
        this.setId(id);
        this.setMois(mois);
        this.setAnnee(annee);
        this.setDetail(getDetailJournal());
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public ComptaSousEcritureLibJournal[] getDetail() {
        return detail;
    }

    public void setDetail(ComptaSousEcritureLibJournal[] detail) {
        this.detail = detail;
    }
}
