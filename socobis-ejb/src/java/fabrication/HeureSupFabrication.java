package fabrication;

import bean.CGenUtil;
import bean.ClassFille;
import bean.ClassMAPTable;
import bean.ClassEtat;
import paie.CategorieQualification;
import paie.employe.PaieInfoPersonnel;
import utilitaire.UtilDB;
import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.WeekFields;

import utils.ConstanteSocobis;

import personnel.Personnel;
import utilitaire.Utilitaire;

public class HeureSupFabrication extends ClassEtat {
    String id, idRessParFab, idPersonne, idFabrication, idClasseDefaut, idClasseEffective, matricule, remarque,poste,equipe ;
    double HS, MN, JF, HD, IF, tauxHoraire, tauxHoraireEffective, heurenormale, montant, totalHeureSemaine, heureDejaCumulees;
    int temporaire;
    Date dateFabrication;
    String idQualification;
    double montantJF, montantMN, montantHD, montantIF, montantHS;



    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getTemporaire() {
        return temporaire;
    }

    public void setTemporaire(int temporaire) {
        this.temporaire = temporaire;
    }

    public double getHeurenormale() {
        return heurenormale;
    }

    public void setHeurenormale(double heurenormale) {
        this.heurenormale = heurenormale;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getIdRessParFab() {
        return idRessParFab;
    }

    public void setIdRessParFab(String idRessParFab) {
        this.idRessParFab = idRessParFab;
    }

    public String getIdPersonne() {
        return idPersonne;
    }

    public void setIdPersonne(String idPersonne) {
        this.idPersonne = idPersonne;
    }

    public String getIdFabrication() {
        return idFabrication;
    }

    public void setIdFabrication(String idFabrication) {
        this.idFabrication = idFabrication;
    }

    public String getIdClasseDefaut() {
        return idClasseDefaut;
    }

    public void setIdClasseDefaut(String idClasseDefaut) {
        this.idClasseDefaut = idClasseDefaut;
    }

    public String getIdClasseEffective() {
        return idClasseEffective;
    }

    public void setIdClasseEffective(String idClasseEffective) {
        this.idClasseEffective = idClasseEffective;
    }

    public double getHS() {
        return HS;
    }

    public void setHS(double HS) {
        this.HS = HS;
    }

    public double getMN() {
        return MN;
    }

    public void setMN(double MN) {
        this.MN = MN;
    }

    public double getJF() {
        return JF;
    }

    public void setJF(double JF) {
        this.JF = JF;
    }

    public double getHD() {
        return HD;
    }

    public void setHD(double HD) {
        this.HD = HD;
    }

    public double getIF() {
        return IF;
    }

    public void setIF(double IF) {
        this.IF = IF;
    }

    public double getTauxHoraire() throws Exception {
        PaieInfoPersonnel tmp = new PaieInfoPersonnel();
        tmp.setNomTable("PAIE_INFO_PERSONNEL_SB");
        tmp.setId(this.getIdPersonne());
        PaieInfoPersonnel[] details = (PaieInfoPersonnel[]) CGenUtil.rechercher(tmp, null, null, "");
//        System.out.println(" details " + details.length + details[0].getId() + " montant " + details[0].getMontant());
        double tauxHoraire = 0;
        if (details != null && details.length > 0) {
//            System.out.println("1 " + details[0].getSalaire_Base() + " 2 " + details[0].getSalaire_base() + " 3 " + details[0].getSalaire_de_base());
            tauxHoraire = details[0].getMontant() / 173.33;
            return tauxHoraire;
        }
        return tauxHoraire;
    }

    public void setTauxHoraire(double tauxHoraire) {
        this.tauxHoraire = tauxHoraire;
    }

    public double getTauxHoraireEffective() {
        return tauxHoraireEffective;
    }

    public void setTauxHoraireEffective(double tauxHoraireEffective) {
        this.tauxHoraireEffective = tauxHoraireEffective;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    
    public String getPoste() {
        return poste;
    }

    public void setPoste(String poste) {
        this.poste = poste;
    }

    public String getEquipe() {
        return equipe;
    }

    public void setEquipe(String equipe) {
        this.equipe = equipe;
    }

    public String getAttributIDName() {
        return "id";
    }

    public String getTuppleID() {
        return id;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("HSFab", "getseqheureSupFabrication");
        this.setId(makePK(c));
    }

    public HeureSupFabrication() {
        this.setNomTable("heureSupFabrication");
    }

    public double getMontantHS() throws Exception {
            WeekFields weekFields = WeekFields.ISO;
            LocalDate localDate = this.getDateFabrication().toLocalDate();
            int year = localDate.get(weekFields.weekBasedYear());
            int week = localDate.get(weekFields.weekOfWeekBasedYear());
            String semaineAnnee = year + "-" + week;
            HeureSupSemaine hs = new HeureSupSemaine();
            hs.setSemaine(semaineAnnee);
            hs.setIdPersonne(this.getIdPersonne());
            hs.setAnnee(year);
            HeureSupSemaine[] res = (HeureSupSemaine[]) CGenUtil.rechercher(hs, null, null, "");
            double tauxHoraire = this.getTauxHoraire();
            double montantHS = 0;
            if(res != null && res.length > 0) {
                double hs30 = res[0].getHs30();
                double hs50 = res[0].getHs50();
                if(hs30 < 8) {
                    double resteHs30 = 8 - hs30;
                    if(resteHs30 >= this.getHS()) {
                        montantHS += this.HS * ConstanteSocobis.POURC_HS30NI * tauxHoraire;
                    } else {
                        montantHS += resteHs30 * ConstanteSocobis.POURC_HS30NI * tauxHoraire;
                        double resteAjouter50 = this.getHS() - resteHs30;
                        montantHS += resteAjouter50 * ConstanteSocobis.POURC_HS50NI *  tauxHoraire;
                    }
                } else {
                    montantHS += this.getHS() * ConstanteSocobis.POURC_HS50NI * tauxHoraire;
                }
            } else {
                if(this.getHS() <= 8) {
                    montantHS += this.getHS() * ConstanteSocobis.POURC_HS30NI * tauxHoraire;
                } else {
                    double hs50Plus = this.getHS() - 8;
                    montantHS += hs50Plus * ConstanteSocobis.POURC_HS50NI * tauxHoraire;
                }
            }
            this.setMontantHS(montantHS);
            return montantHS;
    }

//  calcul hs hoe 30% non imposable, 50% NI
    public double calculMontantHs(double totalHeureSemaine) throws Exception {
        double hs30NI = Math.min(totalHeureSemaine, ConstanteSocobis.maxHS30NI) * this.getTauxHoraire() * ConstanteSocobis.POURC_HS30NI;

        double hs50 = Math.max(totalHeureSemaine - ConstanteSocobis.maxHS30NI, 0);
        double hs50NI = Math.min(hs50, ConstanteSocobis.plafondNI) * this.getTauxHoraire() * ConstanteSocobis.POURC_HS50NI; ;

        double montantTotal = hs30NI + hs50NI;
        return montantTotal;
    }

    public double calculMontantHsJour(double heuresHSJour, double heuresDejaCumulees) throws Exception {
        double montant = 0;
        double resteHS30 = Math.max(ConstanteSocobis.maxHS30NI - heuresDejaCumulees, 0);

        double hs30DuJour = Math.min(heuresHSJour, resteHS30);
        montant += hs30DuJour * this.getTauxHoraire() * ConstanteSocobis.POURC_HS30NI;

        double reste = heuresHSJour - hs30DuJour;

        if (reste > 0) {
            double deja50 = Math.max(heuresDejaCumulees - ConstanteSocobis.maxHS30NI, 0);
            double restePlafond50 = Math.max(ConstanteSocobis.plafondNI - deja50, 0);

            double hs50DuJour = Math.min(reste, restePlafond50);
            montant += hs50DuJour * this.getTauxHoraire() * ConstanteSocobis.POURC_HS50NI;
        }
        return montant;
    }


    public double getMontantMN(){
        return this.MN * ConstanteSocobis.POURC_MN * this.tauxHoraire;
    }

    public double getMontantJF(){
        return this.JF * ConstanteSocobis.POURC_JF * this.tauxHoraire;
    }

    public double getMontantHD(){
        return this.HD * ConstanteSocobis.POURC_HD * this.tauxHoraire;
    }

    public double getMontantIF(){
        return this.IF * (this.tauxHoraire - this.tauxHoraireEffective);
    }

    public double getMontantHeureNormale() { return this.heurenormale * this.tauxHoraire; }

    public double getMontantTotalHS() throws Exception {
        HeureSupFabrication sup = new HeureSupFabrication();
        sup.setNomTable("HEURESUPFABRICATION_CPL");
        sup.setId(this.getId());
        HeureSupFabrication[] res = (HeureSupFabrication[]) CGenUtil.rechercher(sup, null, null, "");
        double montant = 0;
        if(res != null && res.length > 0){
//            montant = res[0].getMontantHS();
//            if(temporaire == 1){
//                montant = res[0].getMontantHeureNormale();
//            }
            PaieInfoPersonnel pip = new PaieInfoPersonnel();
            pip.setId(res[0].getIdPersonne());
            double tauxhoraire = pip.getTauxHoraire();
            this.setTauxHoraire(tauxhoraire);

            PaieInfoPersonnel pers = (PaieInfoPersonnel) new PaieInfoPersonnel().getById(res[0].getIdPersonne(), "PAIE_INFO_PERSONNEL", null);

            CategorieQualification categ = new CategorieQualification();
            categ.setIdcategorie(pers.getIdcategorie());
            categ.setIdqualification(res[0].getIdQualification());
            categ.setRemarque("");
            CategorieQualification[] resCateg = (CategorieQualification[]) CGenUtil.rechercher(categ, null, null, "");
            double tauxHoraireEffective = 0;
            if(resCateg != null && resCateg.length > 0){
                if(tauxHoraireEffective < tauxhoraire) {
                    this.setTauxHoraireEffective(tauxhoraire);
                } else {
                    tauxHoraireEffective = resCateg[0].getMontant() / 173.33;
                    this.setTauxHoraireEffective(tauxHoraireEffective);
                }
            }
            return montant + res[0].getMontantHS() + res[0].getMontantMN() + res[0].getMontantJF() + res[0].getMontantHD() + res[0].getMontantIF();
        } else {
            throw new Exception("Erreur pendant la validation!");
        }
    }

    public void checkHS(Connection c)throws Exception{
        RessourceParFabrication hsp = new RessourceParFabrication();
        hsp.setNomTable("ressourceParFabrication");
        hsp.setId(this.getIdRessParFab());
        RessourceParFabrication[] hs = (RessourceParFabrication[]) CGenUtil.rechercher(hsp,null,null, "");

        HeureSupFabricationCPL crt = new HeureSupFabricationCPL();
        crt.setNomTable("heureSupFabrication_cpl_visee");
        crt.setIdFabrication(hs[0].getIdFabrication());
        crt.setIdPersonne(hs[0].getIdRessource());
        HeureSupFabricationCPL [] rep = (HeureSupFabricationCPL[]) CGenUtil.rechercher(crt,null,null, "");
        if(rep.length>0){
            for(int i=0;i<rep.length;i++){
                if(rep[i].getEtat() > 1){
                    throw new Exception("REF : "+this.getIdRessParFab()+", On ne peut pas faire des HS sur une meme fabrication!");
                }
            }
        }
    }

    @Override
    public void controler(Connection c) throws Exception {
        super.controler(c);
        this.checkHS(c);
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception{
        this.controler(c);
        this.setMontant(this.getMontantTotalHS());
//        this.setMontantHS(this.getMontantHS());
        this.setMontantHD(this.getMontantHD());
        this.setMontantIF(this.getMontantIF());
        this.setMontantJF(this.getMontantJF());
        this.setMontantMN(this.getMontantMN());
        this.updateToTableWithHisto(u, c);
        return super.validerObject(u, c);
    }


    public FabricationCpl getFabrication(Connection c) throws Exception {
        String id = this.getIdFabrication();
        try {
            c = new UtilDB().GetConn();
            FabricationCpl crt=new FabricationCpl();
            crt.setNomTable("FABRICATIONCPL");
            crt.setId(id);
            FabricationCpl[] rep = (FabricationCpl[])CGenUtil.rechercher(crt,null,null,c,"");
            return rep[0];
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        } finally {
            if (c != null) {
                c.close();
            }
        }
    }

    public Personnel getPersonne(Connection c) throws Exception {
        String id = this.getIdPersonne();
        try {
            c = new UtilDB().GetConn();
            Personnel crt=new Personnel();
            crt.setId(id);
            Personnel[] rep = (Personnel[])CGenUtil.rechercher(crt,null,null,c,"");
            return rep[0];
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        } finally {
            if (c != null) {
                c.close();
            }
        }
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public double getTotalHeureSemaine() {
        return totalHeureSemaine;
    }

    public void setTotalHeureSemaine(double totalHeureSemaine) {
        this.totalHeureSemaine = totalHeureSemaine;
    }

    public Date getDateFabrication() {
        return dateFabrication;
    }

    public void setDateFabrication(Date dateFabrication) {
        this.dateFabrication = dateFabrication;
    }

    public double getHeureDejaCumulees() {
        return heureDejaCumulees;
    }

    public void setHeureDejaCumulees(double heureDejaCumulees) {
        this.heureDejaCumulees = heureDejaCumulees;
    }

    public String getIdQualification() {
        return idQualification;
    }

    public void setIdQualification(String idQualification) {
        this.idQualification = idQualification;
    }

    public void setMontantJF(double montantJF) {
        this.montantJF = montantJF;
    }

    public void setMontantMN(double montantMN) {
        this.montantMN = montantMN;
    }

    public void setMontantHD(double montantHD) {
        this.montantHD = montantHD;
    }

    public void setMontantIF(double montantIF) {
        this.montantIF = montantIF;
    }

    public void setMontantHS(double montantHS) {
        this.montantHS = montantHS;
    }
}