/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.employe;

import bean.CGenUtil;
import bean.TypeObjet;
import historique.MapUtilisateur;
import paie.log.LogPersonnel;
import paie.log.LogService;
import paie.log.SigPersonnes;
import utilitaire.ConstanteEtat;
import utilitaire.ConstanteEtatPaie;
import utilitaire.Utilitaire;
import paie.avancement.PaieAvancement;

import java.sql.Connection;

/**
 *
 * @author Finaritra
 */

public class EmployeService {

    public EmployeService() {

    }

    public LogPersonnel saveNewPerson(EmployeComplet ec, Connection c, MapUtilisateur u) throws Exception {
        ec.setDatesaisie(Utilitaire.dateDuJourSql());
        
        //System.out.println("nombre enfantsssssssssssssssssssssssssssss ; " + ec.getNbenfant());
        if (ec.getService() == null || ec.getService().compareToIgnoreCase("") == 0) {
            throw new Exception("Service obligatoire");
        }
        PaieInfoPersonnel pipe = new PaieInfoPersonnel();
        pipe.setNomTable("PAIE_INFO_EMBAUCHE");
        PaieInfoPersonnel[] matriculeTest = (PaieInfoPersonnel[]) CGenUtil.rechercher(pipe, null, null, c, " AND MATRICULE = '" + ec.getMatricule() + "' AND DIRECTION = '" + ec.getDirection() + "'");
        if (matriculeTest.length > 0) {
            throw new Exception("Matricule deja existant dans cet exploitation");
        }

        //insertion sig personne
        SigPersonnes s = new SigPersonnes(ec.getNom(), ec.getPrenom(), ec.getSexe(), ec.getNumero_cin(), ec.getDate_cin(), ec.getDate_dupl_cin(), ec.getLieu_delivrance_cin(), ec.getActe_naissance(), ec.getDate_naissance(), ec.getNationalite(), ec.getFokotany(), ec.getAdresse());
        s.controler(c);
        s.construirePK(c);
        s.insertToTableWithHisto(u.getTuppleID(), c);

        //insertion log personnel
        LogPersonnel logp = new LogPersonnel(ec.getPermis_conduire(), " ", " ", s.getId(), ec.getNom(), ec.getPrenom(), ec.getDate_naissance(), ec.getSexe(), ec.getNumero_cin(), ec.getDate_cin(), ec.getDate_dupl_cin(), ec.getNationalite(), ec.getAdresse(), ec.getFokotany(), ec.getActe_naissance(), ec.getDirection(), ec.getService(), ec.getCheminImage());
        logp.controler(c);
        logp.construirePK(c);
        logp.insertToTableWithHisto(u.getTuppleID(), c);

        TypeObjet obj = new TypeObjet();
//        obj.setNomTable("region");
//        TypeObjet[] tabRegion = (TypeObjet[])CGenUtil.rechercher(obj, null, null, c, " and id = '"+ec.getRegion()+"'");
        obj.setNomTable("log_direction");
        TypeObjet[] tabSousAffect = (TypeObjet[])CGenUtil.rechercher(obj, null, null, c, " and id = '"+ec.getDirection()+"'");
        LogService[] service = (LogService[])CGenUtil.rechercher(new LogService(), null, null, c, " and id = '"+ec.getService()+"'");
//insertion paie info personnel
        String matricule = service[0].getCode_service()+"/"+Utilitaire.completerInt(2, tabSousAffect[0].getDesce())+"/" + Utilitaire.completerInt(5, Utilitaire.getMaxSeq("get_seq"+service[0].getCode_service(), c));
        PaieInfoPersonnel pinf = new PaieInfoPersonnel(logp.getId(), matricule, ec.getLieu_naissance_commune(), ec.getLieu_delivrance_cin(), ec.getSituation_matrimonial(), ec.getInitiale(), ec.getDatesaisie(), ec.getCturgence_nom_prenom(), ec.getCturgence_telephone1(), ec.getCturgence_telephone2(), ec.getCturgence_telephone3(), ec.getIdconjoint(), ec.getCode_agence_banque(), ec.getBanque_numero_compte(), ec.getBanque_compte_cle(), ec.getDateembauche(), ec.getIdfonction(), ec.getIdcategorie(), ec.getMode_paiement(), ec.getClassee(), ec.getIndicegrade(), ec.getIndice_fonctionnel(), ec.getMatricule_patron(), ec.getStatut(), "o",ec.getDebutcontrat(),ec.getFincontrat());
        pinf.setDatesaisie(Utilitaire.dateDuJourSql());
//        pinf.setEchelon(Integer.valueOf(ec.getEchelon()));
        pinf.setCtg(ec.getCtg());
        pinf.setVehiculee(ec.getVehiculee());
        pinf.setEtat(ConstanteEtat.getEtatCreer());
        pinf.setHeurejournalier(ec.getHeurejournalier());
        pinf.setHeurehebdomadaire(ec.getHeurehebdomadaire());
        pinf.setHeuremensuel(ec.getHeuremensuel());
        pinf.setTemporaire(ec.getTemporaire());
        pinf.setNumero_cnaps(ec.getNumero_cnaps());
        pinf.setNumero_ostie(ec.getNumero_ostie());
        pinf.setNbenfant(ec.getNbenfant());
        pinf.setIndesirable(ec.getIndesirable());
        pinf.setTelephone(ec.getTelephone());
        pinf.setMail(ec.getMail());
        pinf.setRegion(ec.getRegion());
        pinf.setAdresse_ligne1(ec.getAdresse_ligne1());
        pinf.setAdresse_ligne2(ec.getAdresse_ligne2());
        pinf.setCode_postal(ec.getCode_postal());
        pinf.setIdcategorie_paie(ec.getIdcategorie_paie());
        pinf.setIdqualification(ec.getIdqualification());
        pinf.setFormation(ec.getFormation());
        pinf.setDiscipline(ec.getDiscipline());
        pinf.setAnneeExperience(ec.getAnneeExperience());
        pinf.setPersonnel_etat(ec.getPersonnel_etat());
        pinf.setDebutcontrat(ec.getDebutcontrat());
        pinf.setFincontrat(ec.getFincontrat());
        //numero de compte
        if (!ec.getCode_agence_banque().isEmpty()) {
            if (ec.getBanque_numero_compte().isEmpty()) {
                throw new Exception("Numero de compte ne doit pas etre vide");
            }
            if (ec.getBanque_compte_cle().isEmpty()) {
                throw new Exception("Cle banque ne doit pas etre vide");
            }
            if (ec.getBanque_numero_compte().length() != 11 && ec.getBanque_numero_compte().length() != 24) {
                throw new Exception("Numero de compte invalide. 11 caracteres ou 24 caract?res");
            }
            if (ec.getBanque_numero_compte().length() == 11) {
                String numerodecompte = ec.getBanque_numero_compte() + ec.getBanque_compte_cle();
                TrsBanqueAgenceDetails[] bankAg = (TrsBanqueAgenceDetails[]) CGenUtil.rechercher(new TrsBanqueAgenceDetails(), null, null, c, " AND ID = '" + ec.getCode_agence_banque() + "'");
                if (bankAg.length == 0) {
                    throw new Exception("Banque inexistant");
                }
                numerodecompte = bankAg[0].getCodebanque() + bankAg[0].getCodeagence() + numerodecompte;
                pinf.setBanque_numero_compte(numerodecompte);
            }
            if (ec.getBanque_numero_compte().length() == 24) {
                pinf.setBanque_numero_compte(ec.getBanque_numero_compte());
            }
        }

        if (pinf.getMode_paiement().equals("PMD28") || pinf.getMode_paiement().equals("PMD29")) {
            if (pinf.getBanque_numero_compte() == "" || pinf.getBanque_numero_compte() == null) {
                throw new Exception("Mode de paiement = Virement. Numero Compte Bancaire obligatoire");
            }
            if (pinf.getBanque_compte_cle() == "" || pinf.getBanque_compte_cle() == null) {
                throw new Exception("Mode de paiement = Virement. Cle de Compte obligatoire");
            }
        }
        pinf.insertToTableWithHisto(u.getTuppleID(), c);

        //insertion avancement
        PaieAvancement pa = new PaieAvancement(logp.getId(), ec.getDirection(), ec.getService(), ec.getIdfonction(), ec.getIdcategorie(), "", "", ec.getDateembauche(), ec.getDateembauche(), 0, Utilitaire.stringToInt(ec.getIndicegrade()), Utilitaire.stringToInt(ec.getIndice_fonctionnel()), ec.getClassee(), ec.getMatricule_patron(), ec.getStatut(), "o");
        pa.setCtg(ec.getCtg());
//        pa.setMotif("Embauche");
        pa.setVehiculee(ec.getVehiculee());
        pa.setEtat(ConstanteEtat.getEtatCreer());
        pa.construirePK(c);
        pa.insertToTableWithHisto(u.getTuppleID(), c);
        return logp;
    }

    public LogPersonnel saveNewPersonSite(EmployeCompletSite ec, Connection c, MapUtilisateur u) throws Exception {
        PaieInfoPersonnel pipe = new PaieInfoPersonnel();
        pipe.setNomTable("PAIE_INFO_EMBAUCHE");
        PaieInfoPersonnel[] matriculeTest = (PaieInfoPersonnel[]) CGenUtil.rechercher(pipe, null, null, c, " AND MATRICULE = '" + ec.getMatricule() + "' AND DIRECTION = '" + ec.getDirection() + "'");
        if (matriculeTest.length > 0) {
            throw new Exception("Le matricule existe dans cet exploitation");
        }

        //insertion log personnel
        LogPersonnel logp = new LogPersonnel(ec.getNom(), ec.getPrenom(), ec.getDirection(), ec.getService());
        logp.setNationalite("Malagasy");

        logp.setPermis_conduire("0");
        logp.setChemin_permis("0");
        logp.setRemarque("0");
        logp.setId_pers("PERS");
        logp.setDate_naissance(Utilitaire.stringDate("05/05/1991"));
        logp.setSexe("0");
        logp.setNumero_cin("000000000000");
        logp.setDate_cin(Utilitaire.dateDuJourSql());
        logp.setDate_dupl_cin(Utilitaire.dateDuJourSql());
        logp.setNationalite("Malagasy");
        logp.setAdresse("0");
        logp.setFokotany("0");
        logp.setActe_naissance("0");

        logp.construirePK(c);
        System.out.println(logp.toString());
        logp.insertToTableWithHisto(u.getTuppleID(), c);

        //insertion paie info personnel
        PaieInfoPersonnel pinf = new PaieInfoPersonnel(logp.getId(), ec.getMatricule(), ec.getIdfonction());
        pinf.setDatesaisie(Utilitaire.dateDuJourSql());
        pinf.setEtat(ConstanteEtat.getEtatValider());
        pinf.insertToTableWithHisto(u.getTuppleID(), c);
        return logp;
    }
    
    public void reembaucheOrUpdateEmploye(EmployeComplet e, Connection c, MapUtilisateur u) throws Exception {
        PaieInfoPersonnel[] lpnv = (PaieInfoPersonnel[]) CGenUtil.rechercher(new PaieInfoPersonnel(), null, null, c, " AND id = '" + e.getId() + "'");
        if (lpnv.length != 0 && lpnv != null) {
            if (lpnv[0].getDate_depart() != null || lpnv[0].getEtat()== ConstanteEtatPaie.getPaieInfoPersonnelDebauche()) {
                reembaucheEmploye(e, c, u);
            }
            updateEmploye(e, c, u);
        }
    }
    
    public void reembaucheEmploye(EmployeComplet e, Connection c, MapUtilisateur u) throws Exception {
        PaieInfoPersonnel[] pip = (PaieInfoPersonnel[]) CGenUtil.rechercher(new PaieInfoPersonnel(), null, null, c, " AND ID = '" + e.getId() + "'");
        if (pip.length == 0) {
            throw new Exception("Employe introuvable");
        } else {
            pip[0].setDate_depart(null);
            pip[0].setEtat(ConstanteEtat.getEtatCreer());
            pip[0].setIndicegrade(e.getIndicegrade());
            pip[0].setIdfonction(e.getIdfonction());
            pip[0].setIdcategorie(e.getIdcategorie());
            pip[0].setDirection(e.getDirection());
            pip[0].setService(e.getService());
            pip[0].updateToTable(c);

            PaieAvancement pa = new PaieAvancement();
            pa.setMode_paiement(e.getMode_paiement());
            pa.setId_logpers(e.getId());
            pa.setDirection(e.getDirection());
            pa.setService(e.getService());
            pa.setIdfonction(e.getIdfonction());
            pa.setIdcategorie(e.getIdcategorie());
            pa.setCtg(e.getCtg());
            /**/pa.setMatricule_patron(e.getMatricule());
            pa.setRemarque("Reembauche");
            //pa.setTemporaire(e.getTemporaire());
            pa.setRefdecision("-");
            pa.setMotif("TYD0000015");
            pa.setDate_application(e.getDateembauche());
            pa.setDatedecision(e.getDateembauche());
            pa.setClassee(e.getClassee());
            pa.setMatricule_patron(e.getMatricule_patron());
            pa.setStatut(e.getStatut());
//            pa.setDroit_hs(e.getDroit_hs());
            pa.setVehiculee(e.getVehiculee());
            pa.setIndicegrade(Integer.parseInt(e.getIndicegrade()));
            pa.setIduser(u.getTuppleID());
            pa.construirePK(c);
            System.out.println("miditra ato");
            pa.setEtat(ConstanteEtat.getEtatCreer());
            pa.insertToTableWithHisto(u.getTuppleID(), c);
            
            //EditionCalcul.reinitialiserSalBaseIndDivAnterieur(e.getId(), e.getDateembauche(), c);
        }
    }
    
    public void updateEmploye(EmployeComplet e, Connection c, MapUtilisateur u) throws Exception {
        LogPersonnel[] lg = (LogPersonnel[]) CGenUtil.rechercher(new LogPersonnel(), null, null, c, " AND ID = '" + e.getId() + "'");
        PaieInfoPersonnel[] i = (PaieInfoPersonnel[]) CGenUtil.rechercher(new PaieInfoPersonnel(), null, null, c, " AND ID = '" + e.getId() + "'");
        if (lg.length == 0 || i.length == 0) {
            throw new Exception("Employe introuvable");
        }
        LogPersonnel log = lg[0];
        PaieInfoPersonnel info = i[0];

        log.setNom(e.getNom());
        log.setPrenom(e.getPrenom());
        info.setInitial(e.getInitiale());
        info.setMatricule(e.getMatricule());
        log.setDate_naissance(e.getDate_naissance());
        info.setLieu_naissance_commune(e.getLieu_naissance_commune());
        log.setSexe(e.getSexe());
        log.setNumero_cin(e.getNumero_cin());
        log.setDate_cin(e.getDate_cin());
        log.setDate_dupl_cin(e.getDate_dupl_cin());
        info.setLieu_delivrance_cin(e.getLieu_delivrance_cin());
        log.setAdresse(e.getAdresse());
        log.setFokotany(e.getFokotany());
        log.setNationalite(e.getNationalite());
        log.setActe_naissance(e.getActe_naissance());
        info.setSituation_matrimonial(e.getSituation_matrimonial());
        log.setDirection(e.getDirection());
        log.setService(e.getService());
        info.setIdfonction(e.getIdfonction());
        info.setMode_paiement(e.getMode_paiement());
        info.setCode_agence_banque(e.getCode_agence_banque());
        info.setBanque_numero_compte(e.getBanque_numero_compte());
        info.setBanque_compte_cle(e.getBanque_compte_cle());
        info.setTemporaire(e.getTemporaire());
        info.setNumero_cnaps(e.getNumero_cnaps());
        info.setNumero_ostie(e.getNumero_ostie());
        log.setPermis_conduire(e.getPermis_conduire());
        log.setRemarque(e.getRemarque());
        info.setCturgence_nom_prenom(e.getCturgence_nom_prenom());
        info.setCturgence_telephone1(e.getCturgence_telephone1());
        info.setCturgence_telephone2(e.getCturgence_telephone2());
        info.setCturgence_telephone3(e.getCturgence_telephone3());
        info.setDateembauche(e.getDateembauche());
        info.setVehiculee(e.getVehiculee());
        info.setDroit_hs(e.getDroit_hs());
        info.setEchelon(Integer.parseInt(e.getEchelon()));
        info.setNbenfant(e.getNbenfant());
        info.setIndesirable(e.getIndesirable());
        if (u.getRang()>=6) { // izay users manana role >=6 no afaka manova anio
            info.setIdcategorie(e.getIdcategorie());
            info.setCtg(e.getCtg());
            info.setEchelon(Integer.valueOf(e.getEchelon()));
            info.setClassee(e.getClassee());
            info.setIndicegrade(e.getIndicegrade());
            info.setIndice_fonctionnel(e.getIndice_fonctionnel());
            info.setStatut(e.getStatut());
        }

        info.updateToTableWithHisto(u.getTuppleID(), c);
        log.updateToTableWithHisto(u.getTuppleID(), c);
    }
    
    public void updateEmployeCompletSite(EmployeCompletSite employeCompletSite, Connection c, MapUtilisateur u) throws Exception {
        
        LogPersonnel[] logPersonnel = (LogPersonnel[]) CGenUtil.rechercher(new LogPersonnel(), null, null, c, " AND ID ='" + employeCompletSite.getId() + "'");
        logPersonnel[0].setMode("modif");
        logPersonnel[0].setNom(employeCompletSite.getNom());
        logPersonnel[0].setPrenom(employeCompletSite.getPrenom());
        logPersonnel[0].setDirection(employeCompletSite.getDirection());
        logPersonnel[0].setService(employeCompletSite.getService());
        logPersonnel[0].updateToTableWithHisto(u.getTuppleID(), c);
        
        
        PaieInfoPersonnel[] listepersonnel = (PaieInfoPersonnel[]) CGenUtil.rechercher(new PaieInfoPersonnel(), null, null, c, " AND ID ='" + employeCompletSite.getId() + "'");
        listepersonnel[0].setMode("modif");
        listepersonnel[0].setMatricule(employeCompletSite.getMatricule());
        listepersonnel[0].setIdfonction(employeCompletSite.getIdfonction());
        listepersonnel[0].updateToTableWithHisto(u.getTuppleID(), c);
    }

    public static boolean estTemporaire(String conditions, Connection c) throws Exception {
        PersonnelValideInfoLibelle p = new PersonnelValideInfoLibelle();
        PersonnelValideInfoLibelle[] v = (PersonnelValideInfoLibelle[]) CGenUtil.rechercher(p, null, null, c, " AND id = '" + conditions + "'");
        return estTemporaire(v[0].getTemporaire());
    }

    public static boolean estTemporaire(int type) {
        return type == -1;
    }

}

