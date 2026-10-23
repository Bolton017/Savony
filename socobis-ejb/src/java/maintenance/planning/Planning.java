package maintenance.planning;

import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;
import maintenance.configuration.UniteFrequence;
import maintenance.configuration.UniteMaintenance;
import maintenance.ressources.IngredientMaintenance;
import maintenance.utils.CalendarUtil;
import utilitaire.UtilDB;

import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;

public class Planning extends ClassEtat {
    String id;
    String refObjet;
    int estPeriodique;
    String idTypeMaintenance;
    String idMachine;
    double frequence;
    String unite;
    Date datedebut;
    Date datefin;
    String duree;
    String heure;
    String idSource;

    public String getIdSource() {
        return idSource;
    }

    public void setIdSource(String idSource) {
        this.idSource = idSource;
    }

    public Planning() {
        this.setNomTable("Planning");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PLN", "getSeqPlanning");
        this.setId(makePK(c));
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

    public String getRefObjet() {
        return refObjet;
    }

    public void setRefObjet(String refObjet) {
        this.refObjet = refObjet;
    }

    public int getEstPeriodique() {
        return estPeriodique;
    }

    public void setEstPeriodique(int estPeriodique) {
        this.estPeriodique = estPeriodique;
    }

    public String getIdTypeMaintenance() {
        return idTypeMaintenance;
    }

    public void setIdTypeMaintenance(String idTypeMaintenance) {
        this.idTypeMaintenance = idTypeMaintenance;
    }

    public String getIdMachine() {
        return idMachine;
    }

    public void setIdMachine(String idMachine) {
        this.idMachine = idMachine;
    }

    public double getFrequence() {
        return frequence;
    }

    public void setFrequence(double frequence) {
        this.frequence = frequence;
    }

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
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

    public String getDuree() {
        return duree;
    }

    public void setDuree(String duree) throws Exception {
        if (!CalendarUtil.isValidTime(duree)) {
            this.duree = duree;
        }
        else {
            this.duree = String.valueOf(CalendarUtil.HMSToSecond(duree));
        }
    }

    public String getHeure() {
        return heure;
    }

    public void setHeure(String heure) throws Exception {
        if (!CalendarUtil.isValidTime(heure)) {
            throw new Exception("L' heure doit etre de format HH:MM:SS");
        }
        this.heure = heure;
    }

    public UniteMaintenance findEchelle(Connection c) throws Exception {
        UniteMaintenance u = (UniteMaintenance) new UniteMaintenance().getById(this.getUnite(),"",c);
        return u;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        Planning firstPlanning = (Planning) super.createObject(u, c);
        if (this.getEstPeriodique()==1){
            UniteMaintenance uniteFrequence = this.findEchelle(c);
            int freq = (int) this.getFrequence();
            System.out.println(freq);
            LocalDate dtDebut = this.getDatedebut().toLocalDate();
            while(freq>1){
                dtDebut = dtDebut.plusDays((long) (uniteFrequence.getEchelle()));
                Planning p = new Planning();
                p.setIdSource(firstPlanning.getId());
                p.setDatedebut(Date.valueOf(dtDebut));
                p.setDatefin(Date.valueOf(dtDebut));
                p.setHeure(this.getHeure());
                p.setDuree(this.getDuree());
                p.setEstPeriodique(0);
                p.setUnite(this.getUnite());
                p.setFrequence(this.getFrequence());
                p.setIdTypeMaintenance(this.getIdTypeMaintenance());
                p.setIdMachine(this.getIdMachine());
                p.setRefObjet(this.getRefObjet());
                p.createObject(u,c);
                freq -= 1;
            }
            firstPlanning.setDatefin(Date.valueOf(dtDebut));
            firstPlanning.updateToTableWithHisto(u,c);
        }
        return firstPlanning;
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            if (this.getIdSource()==null){
                Planning p = new Planning();
                p.setIdSource(this.getId());
                Planning [] plannings = (Planning[]) CGenUtil.rechercher(p,null,null,c,"");
                for (Planning plan : plannings){
                    plan.validerObject(u,c);
                }
            }
            super.validerObject(u, c);
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
        return this;
    }
    public DemandeTravauxCpl getDemandeTravaux() throws Exception {
        DemandeTravauxCpl d = (DemandeTravauxCpl) new DemandeTravauxCpl().getById(this.getIdSource(),"",null);
        return d;
    }

}
