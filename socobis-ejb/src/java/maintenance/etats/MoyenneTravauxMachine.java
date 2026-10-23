package maintenance.etats;

import bean.ClassMAPTable;

public class MoyenneTravauxMachine extends ClassMAPTable {

    private String idMachine;
    private String nomMachine;
    private double moyenneDureeEstimatif;
    private double moyenneDuree;
    private double moyenneEcart;

    private double ecartJours;


    public MoyenneTravauxMachine(){
        this.setNomTable("MoyenneTravauxMachine");
    }

    @Override
    public String getTuppleID() {
        return idMachine;
    }

    @Override
    public String getAttributIDName() {
        return "idMachine";
    }

    public String getIdMachine() {
        return idMachine;
    }

    public void setIdMachine(String idMachine) {
        this.idMachine = idMachine;
    }

    public String getNomMachine() {
        return nomMachine;
    }

    public void setNomMachine(String nomMachine) {
        this.nomMachine = nomMachine;
    }

    public double getMoyenneDureeEstimatif() {
        return moyenneDureeEstimatif;
    }

    public void setMoyenneDureeEstimatif(double moyenneDureeEstimatif) {
        this.moyenneDureeEstimatif = moyenneDureeEstimatif;
    }

    public double getMoyenneDuree() {
        return moyenneDuree;
    }

    public void setMoyenneDuree(double moyenneDuree) {
        this.moyenneDuree = moyenneDuree;
    }

    public double getMoyenneEcart() {
        return moyenneEcart;
    }

    public void setMoyenneEcart(double moyenneEcart) {
        this.moyenneEcart = moyenneEcart;
    }

    public double getEcartJours() {
        return ecartJours;
    }

    public void setEcartJours(double ecartJours) {
        this.ecartJours = ecartJours;
    }
}
