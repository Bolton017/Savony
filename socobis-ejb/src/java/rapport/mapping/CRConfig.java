package rapport.mapping;

import bean.ClassMAPTable;

public class CRConfig extends ClassMAPTable {

    private String id;

    private String heureEnvoi;

    private String jourEnvoi;

    private int dateEnvoi;

    private int finMois;

    private int journaliere;

    private int hebdomadaire;

    private int mensuel;

    public CRConfig(){
        this.setNomTable("CRCONFIG");
    }

    @Override
    public String getTuppleID() {
        return this.id;
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

    public String getHeureEnvoi() {
        return heureEnvoi;
    }

    public void setHeureEnvoi(String heureEnvoi) {
        this.heureEnvoi = heureEnvoi;
    }

    public String getJourEnvoi() {
        return jourEnvoi;
    }

    public void setJourEnvoi(String jourEnvoi) {
        this.jourEnvoi = jourEnvoi;
    }

    public int getDateEnvoi() {
        return dateEnvoi;
    }

    public void setDateEnvoi(int dateEnvoi) {
        this.dateEnvoi = dateEnvoi;
    }

    public int getJournaliere() {
        return journaliere;
    }

    public void setJournaliere(int journaliere) {
        this.journaliere = journaliere;
    }

    public int getHebdomadaire() {
        return hebdomadaire;
    }

    public void setHebdomadaire(int hebdomadaire) {
        this.hebdomadaire = hebdomadaire;
    }

    public int getMensuel() {
        return mensuel;
    }

    public void setMensuel(int mensuel) {
        this.mensuel = mensuel;
    }

    public int getFinMois() {
        return finMois;
    }

    public void setFinMois(int finMois) {
        this.finMois = finMois;
    }
}
