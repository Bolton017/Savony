package mg.cnaps.compta;

import utilitaire.Utilitaire;

public class BalanceDetails extends ComptaSousEcriture {

    // constructor
    public BalanceDetails() throws Exception 
    { }

    private String libelleCompte;
    private double cumulCredit;
    private double cumulDebit;
    private boolean estTotal;
    private int compte2;
    private int compte3;
    private int annee;
    private int mois;
    private double soldeCredit;
    private double soldeDebit;

    public boolean estValide() {
        if(this.getCumulCredit()!=0 ) return true;
        if(this.getCumulDebit()!=0 ) return true;
        if(this.getCredit()!=0) return true;
        if(this.getDebit()!=0) return true;
        return false;
    }
    
    private String formattage(double value) throws Exception {
        return value != 0 ? Utilitaire.formaterAr(Utilitaire.arrondir(value, 2), 2) : "";
    }

    public String makeLigne() throws Exception {
        StringBuilder retour = new StringBuilder();
        retour.append("<tr>");
    
        retour.append(makeCell(getCompte()));
        retour.append(makeCell(getLibelleCompte()));
        retour.append(makeCell(formattage(getCumulDebit())));
        retour.append(makeCell(formattage(getCumulCredit())));
        retour.append(makeCell(formattage(getDebit())));
        retour.append(makeCell(formattage(getCredit())));
        retour.append(makeCell(formattage(getSoldeDebit())));
        retour.append(makeCell(formattage(getSoldeCredit())));
    
        retour.append("</tr>");
        return retour.toString();
    }

    public String makeLigneComparative(BalanceDetails taloha) throws Exception {
        StringBuilder retour = new StringBuilder();
        retour.append("<tr>");

        retour.append(makeCell(getCompte()));
        retour.append(makeCell(getLibelleCompte()));
        retour.append(makeCell(formattage(getCumulDebit())));
        retour.append(makeCell(formattage(taloha.getCumulDebit())));
        retour.append(makeCell(formattage(getCumulDebit()-taloha.getCumulDebit())));
        retour.append(makeCell(formattage(getCumulCredit())));
        retour.append(makeCell(formattage(taloha.getCumulCredit())));
        retour.append(makeCell(formattage(getCumulCredit()-taloha.getCumulCredit())));
        retour.append(makeCell(formattage(getDebit())));
        retour.append(makeCell(formattage(taloha.getDebit())));
        retour.append(makeCell(formattage(getDebit()-taloha.getDebit())));
        retour.append(makeCell(formattage(getCredit())));
        retour.append(makeCell(formattage(taloha.getCredit())));
        retour.append(makeCell(formattage(getCredit()-taloha.getCredit())));
        retour.append(makeCell(formattage(getSoldeDebit())));
        retour.append(makeCell(formattage(taloha.getSoldeDebit())));
        retour.append(makeCell(formattage(getSoldeDebit()-taloha.getSoldeDebit())));
        retour.append(makeCell(formattage(getSoldeCredit())));
        retour.append(makeCell(formattage(taloha.getSoldeCredit())));
        retour.append(makeCell(formattage(getSoldeCredit()-taloha.getSoldeCredit())));



        retour.append("</tr>");
        return retour.toString();
    }
    
    private String makeCell(Object value) {
        String content = (value != null) ? value.toString() : "";
        if (isEstTotal()) {
            content = "<b>" + content + "</b>";
        }
        return "<td>" + content + "</td>";
    }

    public double getSoldeDebit() 
        throws Exception
    {
        if (this.soldeDebit <= 0) {
            double diff = (this.getCumulDebit() + this.getDebit()) - (this.getCumulCredit() + this.getCredit());
            if (diff < 0) {
                this.setSoldeCredit(diff * (-1));
                return 0;
            }

            return diff;
        }

        return this.soldeDebit;
    }

    public double getSoldeCredit() 
        throws Exception
    {
        if (this.soldeCredit <= 0) {
            double diff = (this.getCumulCredit() + this.getCredit()) - (this.getCumulDebit() + this.getDebit());
            if (diff < 0) {
                this.setSoldeDebit(diff * (-1));
                return 0;
            }

            return diff;
        }

        return this.soldeCredit;
    }

    public void setSoldeCredit(double soldeCredit) {
        this.soldeCredit = soldeCredit;
    }

    public void setSoldeDebit(double soldeDebit) {
        this.soldeDebit = soldeDebit;
    }

    public double getCumulCredit() {
        return cumulCredit;
    }

    public void setCumulCredit(double cumulCredit) {
        this.cumulCredit = cumulCredit;
    }

    public double getCumulDebit() {
        return cumulDebit;
    }

    public void setCumulDebit(double cumulDebit) {
        this.cumulDebit = cumulDebit;
    }

    public boolean isEstTotal() {
        return estTotal;
    }

    public void setEstTotal(boolean estTotal) {
        this.estTotal = estTotal;
    }

    public int getCompte2() {
        return compte2;
    }

    public void setCompte2(int compte2) {
        this.compte2 = compte2;
    }

    public int getCompte3() {
        return compte3;
    }

    public void setCompte3(int compte3) {
        this.compte3 = compte3;
    }

    public String getLibelleCompte() {
        return libelleCompte;
    }

    public void setLibelleCompte(String libelleCompte) {
        this.libelleCompte = libelleCompte;
    }
    
    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public BalanceDetails(double credit,double debit,String libelleCompte, double cumulCredit, double cumulDebit, int compte2, int compte3) throws Exception {
        setCredit(credit);
        setDebit(debit);
        setLibelleCompte(libelleCompte);
        setCumulCredit(cumulCredit);
        setCumulDebit(cumulDebit);
        setEstTotal(true);
        setCompte2(compte2);
        setCompte3(compte3);
    }
    public void updateDetails(double credit,double debit, double cumulCredit, double cumulDebit) throws Exception {
        setCredit(getCredit()+credit);
        setDebit(getDebit()+debit);
        setCumulCredit(getCumulCredit()+cumulCredit);
        setCumulDebit(getCumulDebit()+cumulDebit);
    }
}