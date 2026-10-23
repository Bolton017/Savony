package hs;

import bean.ClassEtat;

import java.sql.Connection;
import java.sql.Date;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.WeekFields;

public class DemandeHs extends ClassEtat {
    private String id;
    private String idPersonnel;
    private double duree;
    private Date dateHeureSupp;
    private Date daty;
    private String motif;
    private String heureFin;

    public String getHeureFin() {
        return heureFin;
    }

    public void setHeureFin(String heureFin) {
        this.heureFin = heureFin;
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

    public double getDuree() {
        return duree;
    }

    public void setDuree(double duree) {
        this.duree = duree;
    }

    public Date getDateHeureSupp() {
        return dateHeureSupp;
    }

    public void setDateHeureSupp(Date dateHeureSupp) {
        this.dateHeureSupp = dateHeureSupp;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getMotif() {
        return motif;
    }

    public void setMotif(String motif) throws Exception {

        if("modif".equals(this.getMode()))
        {
            if(motif==null || motif.trim().equals(""))
                throw new Exception("Vous devez insérer un motif ");
        }
        this.motif = motif;
    }



    public DemandeHs() throws Exception {
        this.setNomTable("DEMANDEHS");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("DMHS","GETSEQDEMANDEHS");
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

//    @Override
//    public String[] getRoleValidation() {
//        String[] roleValidation = {"manager","rh"};
//        return roleValidation;
//    }

//    @Override
//    public Object validerObject(MapUtilisateur u, Connection c) throws Exception {
//        String role = u.getIdrole();
//        switch (role) {
//            case "manager":
//                this.setEtat(4);
//                break;
//            case "rh":
//                this.setEtat(11);
//                break;
//        }
//        return super.validerObject(u, c);
//    }

    public static int weekOfMonth(Date sqlDate) {
        LocalDate date = sqlDate.toLocalDate();
        WeekFields wf = WeekFields.of(DayOfWeek.SUNDAY, 1);
        return date.get(wf.weekOfMonth());
    }

    public static String getPeriod(Date sqlDate) {
        return sqlDate.toLocalDate()
                .format(DateTimeFormatter.ofPattern("yyyy-MM"));
    }

//    @Override
//    public Object validerObject(String u, Connection c) throws Exception {
//
//        int weekofmonth = DemandeHs.weekOfMonth(this.getDateHeureSupp());
//        String period = DemandeHs.getPeriod(this.getDateHeureSupp());
//
//        HeureTravailHebdo hth = new HeureTravailHebdo();
//        hth.setId(this.getIdPersonnel());
//        hth.setPeriod(period);
//        String aWhere = " AND semaine = " + weekofmonth;
//
//        System.out.println("ID PERSONNEL: " + this.getIdPersonnel());
//        System.out.println("WEEK OF MONTH: " + weekofmonth);
//        System.out.println("PERIOD: " + period);
//
//        HeureTravailHebdo[] heureTravailHebdos = (HeureTravailHebdo[]) CGenUtil.rechercher(hth, null, null, c, aWhere);
//
//        if (heureTravailHebdos == null || heureTravailHebdos.length == 0)
//        {
//            throw new Exception("Heure Travail Hebdo n'existe pas");
//        }
//
//        double heureSup = 0.0;
//        heureSup = heureTravailHebdos[0].getNuit() + heureTravailHebdos[0].getHs30() + heureTravailHebdos[0].getHs50();
//
//        System.out.println(
//                heureTravailHebdos[0].getNuit()
//        );
//        System.out.println(
//                heureTravailHebdos[0].getHs30()
//        );
//        System.out.println(
//                heureTravailHebdos[0].getSemaine()
//        );
//        System.out.println(
//                heureTravailHebdos[0].getPeriod()
//        );
//
//
//        if (heureSup <= 0.0)
//        {
//            throw new Exception("Pas d\u2019heure suppl\u00E9mentaire trouv\u00E9e pour la date du " + this.getDateHeureSupp());
//        }
//        else if (this.getDuree() > heureSup) {
//            throw new Exception(
//                    "La dur\u00E9e demand\u00E9e (" + this.getDuree() + "h) d\u00E9passe le total des heures suppl\u00E9mentaires disponibles ("
//                            + heureSup + "h) pour la date du " + this.getDateHeureSupp()
//            );
//        }
//
//        return super.validerObject(u, c);
//    }
}

