package paie.hs;

import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;

import java.sql.Connection;
import java.sql.Date;
import fabrication.HeureSupMois;
import mg.cnaps.paie.PaiePersonnelElementpaie;
import paie.edition.PeriodePaie;
import paie.employe.PaieInfoPersonnel;
import utilitaire.Utilitaire;

public class HsMois extends ClassEtat {

    private String id;
    private int mois;
    private int annee;
    private String idCategorie;
    private String idDepartement;
    private Date daty;
    private double hs30_mois;
    private double hs50_mois, hs30NI, hs30I, hs50NI, hs50I;
    private String moisLib;

    public HsMois() {
        this.setNomTable("HSMOIS");
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        PaiePersonnelElementpaie paie = new PaiePersonnelElementpaie();
        paie.setId_objet(this.getId());
        paie.setNomTable("PAIE_PERSONNEL_ELEMENTPAIE");
        PaiePersonnelElementpaie[] hs = (PaiePersonnelElementpaie[]) CGenUtil.rechercher(paie, null, null, "");
        if(hs!=null && hs.length>0){
            for(int i=0; i<hs.length; i++){
                hs[i].validerObject(u, c);
            }
            return super.validerObject(u, c);
        } else {
            throw new Exception("Aucune heure suppl\u00E9mentaire trouv\u00E9e!");
        }
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("HSMO", "getSeqHsMois");
        this.setId(makePK(c));
    }
    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        super.createObject(u, c);
        this.calculerHsPersonnel(u, c);
        return this;
    }

    public void insererEltPaieHs(String u, Connection c, String idPersonnel)  throws Exception {
        PeriodePaie periode = new PeriodePaie();
        periode.setAnnee(this.getAnnee());
        periode.setMois(String.valueOf(this.getMois()));
        periode.setIdcategoriepaie(this.getIdCategorie());


        PeriodePaie[] currentPeriode = (PeriodePaie[]) CGenUtil.rechercher(periode, null, null, c, "");
        if(currentPeriode==null){
            throw new Exception("Periode introuvable pour ces parametres!");
        }

//        System.out.println(currentPeriode[0] + " periode paie ");
//        System.out.println(currentPeriode[0].getAnnee() + " periode paie annee");

//        PaiePersonnelElementpaie elem = new PaiePersonnelElementpaie();
//        elem.setIdpersonnel(idPersonnel);
//        elem.setDate_debut(currentPeriode[0].getDatedebut());
//        elem.setDate_fin(currentPeriode[0].getDatefin());
//        elem.setMoisregularisation(currentPeriode[0].getMois().toString());
//        elem.setAnneeregularisation(String.valueOf(currentPeriode[0].getAnnee()));
//        elem.setId_objet(this.getId());

        double tauxHoraire = 0;
        PaieInfoPersonnel paieInfoPersonnel = new PaieInfoPersonnel();
        paieInfoPersonnel.setId(idPersonnel);
        tauxHoraire = paieInfoPersonnel.getTauxHoraire();
//        System.out.println( "tauxHoraire = " + tauxHoraire);

//        HS 30NI
        double montant30NI = tauxHoraire * 1.3 * this.getHs30NI();
//        System.out.println(" 30NI " + this.getHs30NI() + " montant 30 NI " + montant30NI);
        if(montant30NI > 0) {
            PaiePersonnelElementpaie elem = new PaiePersonnelElementpaie();
            elem.setIdpersonnel(idPersonnel);
            elem.setDate_debut(currentPeriode[0].getDatedebut());
            elem.setDate_fin(currentPeriode[0].getDatefin());
            elem.setMoisregularisation(currentPeriode[0].getMois().toString());
            elem.setAnneeregularisation(String.valueOf(currentPeriode[0].getAnnee()));
            elem.setId_objet(this.getId());
            elem.setCode_rubrique("PR0000130");
            elem.setGain(montant30NI);
            elem.setEtat(1);
            elem.setDatesaisie(Utilitaire.dateDuJourSql());
            elem.createObject(u, c);
        }

        //        HS 50NI
        double montant50NI = tauxHoraire * 1.5 * this.getHs50NI();
//        System.out.println(" 50NI " + this.getHs50NI() + " montant 50 NI " + montant50NI);

        if(montant50NI > 0) {
            PaiePersonnelElementpaie elem = new PaiePersonnelElementpaie();
            elem.setIdpersonnel(idPersonnel);
            elem.setDate_debut(currentPeriode[0].getDatedebut());
            elem.setDate_fin(currentPeriode[0].getDatefin());
            elem.setMoisregularisation(currentPeriode[0].getMois().toString());
            elem.setAnneeregularisation(String.valueOf(currentPeriode[0].getAnnee()));
            elem.setId_objet(this.getId());
            elem.setCode_rubrique("PR0000150");
            elem.setGain(montant50NI);
            elem.setEtat(1);
            elem.setDatesaisie(Utilitaire.dateDuJourSql());
            elem.createObject(u, c);
        }

        //        HS 30I
        double montant30I = tauxHoraire * 1.3 * this.getHs30I();
//        System.out.println(" 30I " + this.getHs30I() + " montant 30 NI " + montant30I);

        if(montant30I > 0) {
            PaiePersonnelElementpaie elem = new PaiePersonnelElementpaie();
            elem.setIdpersonnel(idPersonnel);
            elem.setDate_debut(currentPeriode[0].getDatedebut());
            elem.setDate_fin(currentPeriode[0].getDatefin());
            elem.setMoisregularisation(currentPeriode[0].getMois().toString());
            elem.setAnneeregularisation(String.valueOf(currentPeriode[0].getAnnee()));
            elem.setId_objet(this.getId());
            elem.setCode_rubrique("PR0000130I");
            elem.setGain(montant30I);
            elem.setEtat(1);
            elem.setDatesaisie(Utilitaire.dateDuJourSql());
            elem.createObject(u, c);
        }
        //        HS 50I
        double montant50I = tauxHoraire * 1.5 * this.getHs50I();
//        System.out.println(" 50I " + this.getHs50I() + " montant 50 I " + montant50I);

        if(montant50I > 0) {
            PaiePersonnelElementpaie elem = new PaiePersonnelElementpaie();
            elem.setIdpersonnel(idPersonnel);
            elem.setDate_debut(currentPeriode[0].getDatedebut());
            elem.setDate_fin(currentPeriode[0].getDatefin());
            elem.setMoisregularisation(currentPeriode[0].getMois().toString());
            elem.setAnneeregularisation(String.valueOf(currentPeriode[0].getAnnee()));
            elem.setId_objet(this.getId());
            elem.setCode_rubrique("PR0000150I");
            elem.setGain(montant50I);
            elem.setEtat(1);
            elem.setDatesaisie(Utilitaire.dateDuJourSql());
            elem.createObject(u, c);
        }

    }

    public void calculerHsPersonnel(String u, Connection c) throws Exception {
        System.out.println(" dans calcul hs personnel ");
        HeureSupMois tmp = new HeureSupMois();
        tmp.setMois(this.getMois());
        tmp.setAnnee(this.getAnnee());
        tmp.setIdCategorie(this.getIdCategorie());
        if(this.getIdDepartement() != null) {
            tmp.setIdDepartement(this.getIdDepartement());
        }
        HeureSupMois[] hs = (HeureSupMois[]) CGenUtil.rechercher(tmp, null, null, "");
        if (hs != null && hs.length > 0) {
            final double SEUIL_NI = 20;

            for (HeureSupMois h : hs) {

                double hs30 = h.getHs30_mois();
                double hs50 = h.getHs50_mois();

                double hs30NI = 0;
                double hs30I = 0;

                double hs50NI = 0;
                double hs50I = 0;

                if (hs30 <= SEUIL_NI) {
                    hs30NI = hs30;
                    hs30I = 0;
                } else {
                    hs30NI = SEUIL_NI;
                    hs30I = hs30 - SEUIL_NI;
                }

                double resteNI = SEUIL_NI - hs30NI;
                double resteHs50 = 0;
                if(hs50 >= resteNI) {
                    resteHs50 = hs50 - resteNI;
                    hs50NI = resteNI;
                    hs50I = resteHs50;
                } else {
                    hs50NI = hs50;
                }

//                System.out.println("Personnel = " + h.getIdPersonnel());
//                System.out.println("HS30NI : " + hs30NI + " | HS30I : " + hs30I);
//                System.out.println("HS50NI : " + hs50NI + " | HS50I : " + hs50I);
//                System.out.println("----------------------------------------");

                this.setHs30NI(hs30NI);
                this.setHs30I(hs30I);
                this.setHs50NI(hs50NI);
                this.setHs50I(hs50I);

                this.insererEltPaieHs(u, c, h.getIdPersonnel());

            }
        }
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
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

    public String getIdCategorie() {
        return idCategorie;
    }

    public void setIdCategorie(String idCategorie) {
        this.idCategorie = idCategorie;
    }

    public String getIdDepartement() {
        return idDepartement;
    }

    public void setIdDepartement(String idDepartement) {
        this.idDepartement = idDepartement;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public double getHs30_mois() {
        return hs30_mois;
    }

    public void setHs30_mois(double hs30_mois) {
        this.hs30_mois = hs30_mois;
    }

    public double getHs50_mois() {
        return hs50_mois;
    }

    public void setHs50_mois(double hs50_mois) {
        this.hs50_mois = hs50_mois;
    }

    public double getHs30NI() {
        return hs30NI;
    }

    public void setHs30NI(double hs30NI) {
        this.hs30NI = hs30NI;
    }

    public double getHs30I() {
        return hs30I;
    }

    public void setHs30I(double hs30I) {
        this.hs30I = hs30I;
    }

    public double getHs50NI() {
        return hs50NI;
    }

    public void setHs50NI(double hs50NI) {
        this.hs50NI = hs50NI;
    }

    public double getHs50I() {
        return hs50I;
    }

    public void setHs50I(double hs50I) {
        this.hs50I = hs50I;
    }

    public String getMoisLib() {
        return moisLib;
    }

    public void setMoisLib(String moisLib) {
        this.moisLib = moisLib;
    }
}
