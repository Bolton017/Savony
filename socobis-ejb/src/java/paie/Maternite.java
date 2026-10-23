package paie;

import bean.ClassMAPTable;

import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;

public class Maternite extends ClassMAPTable {
    private String id,idPersonnel,remarque;
    private Date dateDepartTheorique,dateDepartReel,dateAccouchement,dateRetourTheorique,dateRetourAjuste,dateFinAllaitement, dpa;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdPersonnel() {
        return idPersonnel;
    }

    public void setIdPersonnel(String idPersonnel) {
        this.idPersonnel = idPersonnel;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public Date getDateDepartTheorique() {
        return dateDepartTheorique;
    }

    public void setDateDepartTheorique(Date dateDepartTheorique) {
        this.dateDepartTheorique = dateDepartTheorique;
    }

    public Date getDateDepartReel() {
        return dateDepartReel;
    }

    public void setDateDepartReel(Date dateDepartReel) {
        this.dateDepartReel = dateDepartReel;
    }

    public Date getDateAccouchement() {
        return dateAccouchement;
    }

    public void setDateAccouchement(Date dateAccouchement) {
        this.dateAccouchement = dateAccouchement;
    }

    public Date getDateRetourTheorique() {
        return dateRetourTheorique;
    }

    public void setDateRetourTheorique(Date dateRetourTheorique) {
        this.dateRetourTheorique = dateRetourTheorique;
    }

    public Date getDateRetourAjuste() {
        return dateRetourAjuste;
    }

    public void setDateRetourAjuste(Date dateRetourAjuste) {
        this.dateRetourAjuste = dateRetourAjuste;
    }

    public Date getDateFinAllaitement() {
        return dateFinAllaitement;
    }

    public void setDateFinAllaitement(Date dateFinAllaitement) {
        this.dateFinAllaitement = dateFinAllaitement;
    }

    public Date getDpa() {
        return dpa;
    }

    public void setDpa(Date dpa) {
        this.dpa = dpa;
    }

    public Maternite() {
        super.setNomTable("MATERNITE");
    }
    public void construirePK(Connection c) throws Exception {
        this.preparePk("MAT", "getSeqMaternite");
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


    public Date calculDateFinAllaitement(Date dateAccouchement) {
        LocalDate localDate = dateAccouchement.toLocalDate();
        LocalDate fin = localDate.plusMonths(15); // règle métier axelle
        return Date.valueOf(fin);
    }

    @Override
    public int updateObject(String u, Connection c) throws Exception {
        // Si dateAccouchement est modifié/renseigné, recalculer automatiquement la date de fin d'allaitement
        if (this.getDateAccouchement() != null) {
            this.setDateFinAllaitement(this.calculDateFinAllaitement(this.dateAccouchement));
        }

        return super.updateObject(u, c);
    }
}
