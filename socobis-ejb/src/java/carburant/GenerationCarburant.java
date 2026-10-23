package carburant;

import bean.CGenUtil;
import bean.ClassMAPTable;
import personnel.Personnel;
import utilitaire.UtilDB;

import java.sql.Connection;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.concurrent.ThreadLocalRandom;

public class GenerationCarburant extends ClassMAPTable {
    private String id;
    private String departement;
    private String personne;
    private int semaine;
    private int annee;
    private int nbJour;

    public GenerationCarburant() {
        setNomTable("generationCarburant");
    }

    public int nbJourTravail(String idPersonne, int semaine, int annee, Date dateDebut, Date dateFin) {
        return ThreadLocalRandom.current().nextInt(1, 5); // 1 inclus, 5 exclus
    }


    public Personnel[] generationCarburantPersonne(String idDepartement, String personne, Connection c) throws Exception {
        String aWhere = "";

        if (idDepartement != null && !idDepartement.trim().isEmpty()) {
            aWhere += " AND idDepartement = '" + idDepartement + "'";
        }

        if (personne != null && !personne.trim().isEmpty()) {
            aWhere += " AND (UPPER(id) LIKE UPPER('%" + personne + "%') " +
                    " OR UPPER(nom) LIKE UPPER('%" + personne + "%'))";
        }

        return (Personnel[]) CGenUtil.rechercher(new Personnel(), null, null, c, aWhere);
    }

    public SemainePeriode[] generationCarburantSemaine(String semaine1 , String semaine2, String annee, Connection c) throws Exception {
        if (annee == null || annee.trim().isEmpty()) {
            throw new Exception("annee obligatoire");
        }

        String aWhere = " and annee = " + annee;

        if (semaine1 != null && !semaine1.trim().isEmpty()) {
            aWhere += " and numsemaine >= " + semaine1;
        }

        if (semaine2 != null && !semaine2.trim().isEmpty()) {
            aWhere += " and numsemaine <= " + semaine2;
        }

        return (SemainePeriode[]) CGenUtil.rechercher(new SemainePeriode(), null, null, c, aWhere);
    }

    public GenerationCarburant[] generationCarburantData(String idDepartement, String personne, String annee, String semaine1, String semaine2, Connection c) throws Exception {
        boolean openedLocally = false;

        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                openedLocally = true;
            }

            SemainePeriode[] semainePeriodes = generationCarburantSemaine(semaine1, semaine2, annee, c);
            Personnel[] personnels = generationCarburantPersonne(idDepartement, personne, c);

            List<GenerationCarburant> res = new ArrayList<>();
            for (SemainePeriode semaine : semainePeriodes) {
                for (Personnel personnel : personnels) {
                    SemaineCarburant serachSemaine = new SemaineCarburant();
                    serachSemaine.setPersonne(personnel.getId());
                    serachSemaine.setNumeroSemaine(semaine.getNumSemaine());

                    Object[] resultSemaine = CGenUtil.rechercher(serachSemaine, null, null, c, "");
                    if (resultSemaine.length == 0) {
                        int nbJour = nbJourTravail(personne, semaine.getNumSemaine(), semaine.getAnnee(), semaine.getDateDebut(), semaine.getDateFin());

                        GenerationCarburant generationCarburant = new GenerationCarburant();
                        generationCarburant.setDepartement(idDepartement);
                        generationCarburant.setPersonne(personnel.getId());
                        generationCarburant.setSemaine(semaine.getNumSemaine());
                        generationCarburant.setAnnee(Integer.parseInt(annee));
                        generationCarburant.setNbJour(nbJour);

                        res.add(generationCarburant);
                    }
                }
            }

            return res.toArray(new GenerationCarburant[]{});

        } finally {
            if (openedLocally && c != null) {
                try {
                    c.close();
                } catch (Exception _) {
                }
            }
        }
    }


    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDepartement() {
        return departement;
    }

    public void setDepartement(String departement) {
        this.departement = departement;
    }

    public String getPersonne() {
        return personne;
    }

    public void setPersonne(String personne) {
        this.personne = personne;
    }

    public int getSemaine() {
        return semaine;
    }

    public void setSemaine(int semaine) {
        this.semaine = semaine;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public int getNbJour() {
        return nbJour;
    }

    public void setNbJour(int nbJour) {
        this.nbJour = nbJour;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
}
