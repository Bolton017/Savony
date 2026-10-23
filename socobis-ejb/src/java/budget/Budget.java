package budget;

import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;
import change.TauxDeChange;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;

public class Budget extends ClassEtat {

    private String id,designation,idorigine,iddevise,compte;
    private double debit,credit,taux;
    private Date daty;
    private int mois, annee;
    private String service;

    public Budget() {
        this.setNomTable("prevision");
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        if (this.getIddevise() != null && !this.getIddevise().equalsIgnoreCase("AR") && this.getTaux() <= 1) {
            double dernierTaux = TauxDeChange.getLastTaux(c, Utilitaire.formatterDaty(this.getDaty()), this.getIddevise());
            if (dernierTaux > 0) {
                this.setTaux(dernierTaux);
            }
        }
        return super.createObject(u, c);
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getIdorigine() {
        return idorigine;
    }

    public void setIdorigine(String idorigine) {
        this.idorigine = idorigine;
    }

    public String getIddevise() {
        return iddevise;
    }

    public void setIddevise(String iddevise) {
        this.iddevise = iddevise;
    }

    public String getCompte() {
        return compte;
    }

    public void setCompte(String compte) {
        this.compte = compte;
    }

    public double getDebit() {
        return debit;
    }

    public void setDebit(double debit) {
        this.debit = debit;
    }

    public double getCredit() {
        return credit;
    }

    public void setCredit(double credit) {
        this.credit = credit;
    }

    public double getTaux() {
        return taux;
    }

    public void setTaux(double taux) {
        this.taux = taux;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
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

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    @Override
    public String getTuppleID() {
        return this.getId();
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("BUDG", "getseqprevision");
        super.construirePK(c);
    }

    public Budget getBudget(String nomtable, Connection c) throws Exception {
        Budget budget = new Budget();
        if(nomtable!=null&&nomtable.compareToIgnoreCase("")!=0) budget.setNomTable(nomtable);
        System.err.println("ITOOOOOO"+this.getId());
        budget.setId(this.getId());
        Budget[] budgets = (Budget[]) CGenUtil.rechercher(budget, null, null, c, "");
        return budgets[0];
    }

    public void dupliquerMultiple(String [] id,int annee, int mois, int recurence, String user, Connection c) throws Exception {
        int indice = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                indice = 1;
            }
            if (id == null) {
                throw new Exception("Selectionner au moin une budget");
            }
            for (int i=0;i<id.length;i++) {
                Budget tmp = new Budget();
                tmp.setId(id[i]);
                tmp = tmp.getBudget("prevision", c);
                for (int j = 0; j < recurence; j++) {
                    if (mois > 12) {
                        mois = 1;
                        annee += 1;
                    }
                    tmp.setAnnee(annee);
                    tmp.setMois(mois);
                    Budget prev = (Budget) tmp.dupliquer(user, c);
                    prev.setNomTable("prevision");
                    prev.createObject(user, c);
                    mois++;
                }
            }

            if (indice == 1) {
                c.commit();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            if (c != null) {
                c.rollback();
            }
            throw new Exception(ex.getMessage());
        } finally {
            if (indice == 1) {
                c.close();
            }
        }
    }
}
