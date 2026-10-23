package budget;

public class SituationBudgetDepenses extends Budget{
    private String service,moislib;
    private double budget,montantfacture,paiement,resteapayer,ecartfacturebudget,ecartbudgetpaiement;

    public SituationBudgetDepenses(){
        this.setNomTable("situation_budget_depenses");
    }

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    public String getMoislib() {
        return moislib;
    }

    public void setMoislib(String moislib) {
        this.moislib = moislib;
    }

    public double getBudget() {
        return budget;
    }

    public void setBudget(double budget) {
        this.budget = budget;
    }

    public double getMontantfacture() {
        return montantfacture;
    }

    public void setMontantfacture(double montantfacture) {
        this.montantfacture = montantfacture;
    }

    public double getPaiement() {
        return paiement;
    }

    public void setPaiement(double paiement) {
        this.paiement = paiement;
    }

    public double getResteapayer() {
        return resteapayer;
    }

    public void setResteapayer(double resteapayer) {
        this.resteapayer = resteapayer;
    }

    public double getEcartfacturebudget() {
        return ecartfacturebudget;
    }

    public void setEcartfacturebudget(double ecartfacturebudget) {
        this.ecartfacturebudget = ecartfacturebudget;
    }

    public double getEcartbudgetpaiement() {
        return ecartbudgetpaiement;
    }

    public void setEcartbudgetpaiement(double ecartbudgetpaiement) {
        this.ecartbudgetpaiement = ecartbudgetpaiement;
    }
}
