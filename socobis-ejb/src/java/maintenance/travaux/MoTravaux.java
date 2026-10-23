package maintenance.travaux;

import bean.CGenUtil;
import bean.ClassMAPTable;
import paie.employe.PaieInfoPersonnel;
import utilitaire.Utilitaire;
import utils.CalendarUtil;

import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class MoTravaux extends ClassMAPTable {
    String id;
    String idPersonnel,idTravaux;
    double dureeEstimatif;
    double tauxHoraire;

    public MoTravaux() {
        this.setNomTable("MOTRAVAUX");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("MOT", "getSeqmotravaux");
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

    public String getIdPersonnel() {
        return idPersonnel;
    }

    public void setIdPersonnel(String idPersonnel) {
        this.idPersonnel = idPersonnel;
    }

    public String getIdTravaux() {
        return idTravaux;
    }

    public void setIdTravaux(String idTravaux) {
        this.idTravaux = idTravaux;
    }

    public double getDureeEstimatif() {
        return dureeEstimatif;
    }

    public void setDureeEstimatif(double dureeEstimatif) throws Exception {
        if (!CalendarUtil.isValidTime(String.valueOf(dureeEstimatif))) {
            this.dureeEstimatif = dureeEstimatif;
        }
        else {
            this.dureeEstimatif = CalendarUtil.HMSToSecond(String.valueOf(dureeEstimatif));
        }
    }
    public double getTauxHoraire() {
        return tauxHoraire;
    }

    public void setTauxHoraire(double tauxHoraire) {
        this.tauxHoraire = tauxHoraire;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        PaieInfoPersonnel paieInfoPersonnel = new PaieInfoPersonnel();
        paieInfoPersonnel.setIdpersonnel(this.getIdPersonnel());
        PaieInfoPersonnel [] list = (PaieInfoPersonnel[]) CGenUtil.rechercher(paieInfoPersonnel,null,null,c,"");
        if (list != null && list.length > 0) {
            this.setTauxHoraire(list[0].getTauxHoraire());
        }
        return super.createObject(u, c);
    }

    public ProcessMaintenance [] genererProcessMaintenance (String idTravaux, Connection c) throws Exception {
        List<ProcessMaintenance> result = new ArrayList<>();
        MoTravaux ref = new MoTravaux();
        ref.setIdTravaux(idTravaux);
        MoTravaux [] affectations = (MoTravaux[]) CGenUtil.rechercher(ref,null,null,c,"");
        for (MoTravaux moTravaux : affectations) {
            double dureeEstimatif = moTravaux.getDureeEstimatif();
            LocalDate dateDebut = LocalDate.now();
            LocalTime heureDebut = LocalTime.parse(Utilitaire.heureCouranteHMS());

            LocalDateTime debut = LocalDateTime.of(dateDebut, heureDebut);
            LocalDateTime fin = debut.plusSeconds((long)dureeEstimatif);

            ProcessMaintenance p = new ProcessMaintenance();
            p.setIdTravaux(moTravaux.getIdTravaux());
            p.setIdPersonnel(moTravaux.getIdPersonnel());
            p.setDateDebut(Date.valueOf(debut.toLocalDate()));
            p.setHeureDebut(debut.toLocalTime().toString());
            p.setDateFin(Date.valueOf(fin.toLocalDate()));
            p.setHeureFin(fin.toLocalTime().toString());
            result.add(p);
        }
        return result.toArray(new ProcessMaintenance[]{});
    }
}
