/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.employe;

import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;
import bean.TypeObjet;
import historique.MapUtilisateur;
import org.krysalis.barcode4j.impl.code128.Code128Bean;
import org.krysalis.barcode4j.output.bitmap.BitmapCanvasProvider;
import paie.annexe.Ville;
import paie.avancement.PaieAvancement;
import paie.log.LogPersonnel;
import paie.log.LogService;
import paie.log.SigPersonnes;
import utilitaire.ConstanteEtatPaie;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteAxelle;
import utils.ConstanteXC;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 *
 * @author ASUS
 */
public class EmployeComplet extends ClassEtat {

    private String id, nom, prenom, id_pers;
    private Date date_naissance;
    private String lieu_naissance_commune, sexe, numero_cin;
    private Date date_cin, date_dupl_cin, date_dernierpromo;
    private int vehiculee;
    private String lieu_delivrance_cin, adresse, fokotany, nationalite, acte_naissance, situation_matrimonial, idconjoint, initiale, matricule, direction, service, idfonction, ctg, idcategorie, classee, indicegrade, indice_fonctionnel, matricule_patron, statut, mode_paiement, code_agence_banque, banque_code, banque_compte_cle, permis_conduire, chemin_permis, remarque, banque_numero_compte, cturgence_nom_prenom, cturgence_telephone1, cturgence_telephone2, cturgence_telephone3, echelon;
    private String droit_hs, numero_cnaps, numero_ostie;
    private double heurejournalier, heurehebdomadaire, heuremensuel, duree;
    private int temporaire, nbenfant,indesirable;
    private String motifIndesirable;
    private String telephone,mail,region,adresse_ligne1,adresse_ligne2,code_postal;
    private String idcategorie_paie ,idqualification;
    private String formation,discipline,anneeExperience;
    private int personnel_etat ;

    private Date debutcontrat;
    private Date fincontrat;
    private String idsup;

    private String cheminImage;

    private String typeContrat , typeContratLib;

    private String idDepartement;

    private String mere, pere, idCiviliteLib, idBanque, idBanqueLib, idAgence, codeAgence, idAgenceLib, idCivilite;

    private String nomDusage;
    private String numeroSecuriteSociale;
    private String numeroCarteSejour;
    private Date dateExpiration;
    private String adresse2;
    private String commune;
    private String pays;

    private String referenceContrat;
    private Date dateDebutPeriodeEssai;
    private Date dateFinPeriodeEssai;
    private String typeEntree;
    private Date dateEntreeProfession;
    private Date dateEntreeEtablissement;
    private int dureePeriodeDessai;
    private String unite;
    private String idHierarchie;
    private double indice;
    private String niveau;
    private double coefficient;
    private Date dateDebutPoste;
    private Date dateFinPoste;

    private String typeCalcul;
    private double salaireBase;
    private String typeHoraire;
    private String modaliteTravail;

    private double distance;

    private String idSociete;
    private int estRattacheCnaps;
    private int estRattacheOstie;
    private int transport;
    private String cantine;
    private String cantineLib;

    private int estHandicape;
    private String natureHandicap;
    public static final String PATH_DIR = System.getProperty("jboss.server.base.dir") + "/deployments/dossier.war";
    private static final Code128Bean CODE128_BEAN = new Code128Bean();
    private static final int DPI = 150;

    private String idSection;
    private String idBu;
    String image;



    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public int getEstHandicape() {
        return estHandicape;
    }

    public void setEstHandicape(int estHandicape) {
        this.estHandicape = estHandicape;
    }

    public String getNatureHandicap() {
        return natureHandicap;
    }

    public void setNatureHandicap(String natureHandicap) {
        this.natureHandicap = natureHandicap;
    }

    public String getIdBu() {
        return idBu;
    }

    public void setIdBu(String idBu) {
        this.idBu = idBu;
    }

    public String getIdSection() {
        return idSection;
    }

    public void setIdSection(String idSection) {
        this.idSection = idSection;
    }

    public String getIdSociete() {
        return idSociete;
    }

    public int getEstRattacheCnaps() {
        return estRattacheCnaps;
    }

    public void setEstRattacheCnaps(int estRattacheCnaps) {
        this.estRattacheCnaps = estRattacheCnaps;
    }

    public int getEstRattacheOstie() {
        return estRattacheOstie;
    }

    public void setEstRattacheOstie(int estRattacheOstie) {
        this.estRattacheOstie = estRattacheOstie;
    }

    public int getTransport() {
        return transport;
    }

    public void setTransport(int transport) {
        this.transport = transport;
    }

    public String getCantine() {
        return cantine;
    }

    public void setCantine(String cantine) {
        this.cantine = cantine;
    }

    public void setIdSociete(String idSociete) {
        this.idSociete = idSociete;
    }


    public String getTypeContratLib() {
        return typeContratLib;
    }

    public void setTypeContratLib(String typeContratLib) {
        this.typeContratLib = typeContratLib;
    }

    public double getDistance() {
        return distance;
    }

    public void setDistance(double distance) {
        this.distance = distance;
    }

    public String getModaliteTravail() {
        return modaliteTravail;
    }

    public void setModaliteTravail(String modaliteTravail) {
        this.modaliteTravail = modaliteTravail;
    }


    public String getTypeHoraire() {
        return typeHoraire;
    }

    public void setTypeHoraire(String typeHoraire) {
        this.typeHoraire = typeHoraire;
    }

    public double getSalaireBase() {
        return salaireBase;
    }

    public void setSalaireBase(double salaireBase) {
        this.salaireBase = salaireBase;
    }


    public String getTypeCalcul() {
        return typeCalcul;
    }

    public void setTypeCalcul(String typeCalcul) {
        this.typeCalcul = typeCalcul;
    }



    public Date getDateDebutPoste() {
        return dateDebutPoste;
    }

    public void setDateDebutPoste(Date dateDebutPoste) {
        this.dateDebutPoste = dateDebutPoste;
    }

    public Date getDateFinPoste() {
        return dateFinPoste;
    }

    public void setDateFinPoste(Date dateFinPoste) {
        this.dateFinPoste = dateFinPoste;
    }

    public double getCoefficient() {
        return coefficient;
    }

    public void setCoefficient(double coefficient) {
        this.coefficient = coefficient;
    }


    public String getNiveau() {
        return niveau;
    }

    public void setNiveau(String niveau) {
        this.niveau = niveau;
    }

    public double getIndice() {
        return indice;
    }

    public void setIndice(double indice) {
        this.indice = indice;
    }

    public String getIdHierarchie() {
        return idHierarchie;
    }

    public void setIdHierarchie(String idHierarchie) {
        this.idHierarchie = idHierarchie;
    }

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }

    public int getDureePeriodeDessai() {
        return dureePeriodeDessai;
    }

    public void setDureePeriodeDessai(int dureePeriodeDessai) {
        this.dureePeriodeDessai = dureePeriodeDessai;
    }

    public Date getDateEntreeProfession() {
        return dateEntreeProfession;
    }

    public void setDateEntreeProfession(Date dateEntreeProfession) {
        this.dateEntreeProfession = dateEntreeProfession;
    }

    public Date getDateEntreeEtablissement() {
        return dateEntreeEtablissement;
    }

    public void setDateEntreeEtablissement(Date dateEntreeEtablissement) {
        this.dateEntreeEtablissement = dateEntreeEtablissement;
    }

    public String getTypeEntree() {
        return typeEntree;
    }

    public void setTypeEntree(String typeEntree) {
        this.typeEntree = typeEntree;
    }

    public Date getDateFinPeriodeEssai() {
        return dateFinPeriodeEssai;
    }

    public void setDateFinPeriodeEssai(Date dateFinPeriodeEssai) {
        this.dateFinPeriodeEssai = dateFinPeriodeEssai;
    }


    public Date getDateDebutPeriodeEssai() {
        return dateDebutPeriodeEssai;
    }

    public void setDateDebutPeriodeEssai(Date dateDebutPeriodeEssai) {
        this.dateDebutPeriodeEssai = dateDebutPeriodeEssai;
    }



    public String getReferenceContrat() {
        return referenceContrat;
    }

    public void setReferenceContrat(String referenceContrat) {
        this.referenceContrat = referenceContrat;
    }


    public String getPays() {
        return pays;
    }

    public void setPays(String pays) {
        this.pays = pays;
    }

    public String getCommune() {
        return commune;
    }

    public void setCommune(String commune) {
        this.commune = commune;
    }

    public String getAdresse2() {
        return adresse2;
    }

    public void setAdresse2(String adresse2) {
        this.adresse2 = adresse2;
    }

    public String getNumeroSecuriteSociale() {
        return numeroSecuriteSociale;
    }

    public void setNumeroSecuriteSociale(String numeroSecuriteSociale) {
        this.numeroSecuriteSociale = numeroSecuriteSociale;
    }

    public String getNumeroCarteSejour() {
        return numeroCarteSejour;
    }

    public void setNumeroCarteSejour(String numeroCarteSejour) {
        this.numeroCarteSejour = numeroCarteSejour;
    }

    public Date getDateExpiration() {
        return dateExpiration;
    }

    public void setDateExpiration(Date dateExpiration) {
        this.dateExpiration = dateExpiration;
    }

    public String getIdCivilite() {
        return idCivilite;
    }

    public void setIdCivilite(String idCivilite) {
        this.idCivilite = idCivilite;
    }

    public String getMere() {
        return mere;
    }

    public void setMere(String mere) {
        this.mere = mere;
    }

    public String getPere() {
        return pere;
    }

    public void setPere(String pere) {
        this.pere = pere;
    }

    public String getIdDepartement() {
        return idDepartement;
    }

    public String getIdCiviliteLib() {
        return idCiviliteLib;
    }

    public void setIdCiviliteLib(String idCiviliteLib) {
        this.idCiviliteLib = idCiviliteLib;
    }

    public String getIdBanque() {
        return idBanque;
    }

    public void setIdBanque(String idBanque) {
        this.idBanque = idBanque;
    }

    public String getIdBanqueLib() {
        return idBanqueLib;
    }

    public void setIdBanqueLib(String idBanqueLib) {
        this.idBanqueLib = idBanqueLib;
    }

    public String getIdAgence() {
        return idAgence;
    }

    public void setIdAgence(String idAgence) {
        this.idAgence = idAgence;
    }

    public String getCodeAgence() {
        return codeAgence;
    }

    public void setCodeAgence(String codeAgence) {
        this.codeAgence = codeAgence;
    }

    public String getIdAgenceLib() {
        return idAgenceLib;
    }

    public void setIdAgenceLib(String idAgenceLib) {
        this.idAgenceLib = idAgenceLib;
    }

    public void setIdDepartement(String idDepartement) {
        this.idDepartement = idDepartement;
    }

    public String getTypeContrat() {
        return typeContrat;
    }

    public void setTypeContrat(String typeContract) {
        this.typeContrat = typeContract;
    }

    public String getIdsup() {
        return idsup;
    }

    public void setIdsup(String idsup) {
        this.idsup = idsup;
    }

    public Date getDebutcontrat() {
        return debutcontrat;
    }

    public void setDebutcontrat(Date debutcontrat) {
        this.debutcontrat = debutcontrat;
    }

    public Date getFincontrat() {
        return fincontrat;
    }

    public void setFincontrat(Date fincontrat) {
        this.fincontrat = fincontrat;
    }

    public int getPersonnel_etat() {
        return personnel_etat;
    }

    public void setPersonnel_etat(int personnel_etat) {
        this.personnel_etat = personnel_etat;
    }

    public String getNomDusage() {
        return nomDusage;
    }

    public void setNomDusage(String nomDusage) {
        this.nomDusage = nomDusage;
    }

    public EmployeComplet find(EmployeComplet obj ) throws Exception{
        EmployeComplet[] ls = null ;
        try {
            ls =(EmployeComplet[]) CGenUtil.rechercher(obj, null, null, null, "  " );
            if( ls.length > 0 ){
                obj = ls[0];
            }else{
                throw new Exception("Personnel non trouver");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return obj ;
    }

    public PaieAvancement genererPaieAvancement() throws Exception {
        Connection con = null;
        boolean isOpen = true;

        try {
            EmployeComplet emp = (EmployeComplet)this.getById(this.getId(), "EMPLOYE_COMPLET_LIBELLE2", con);
            if (emp != null) {
                PaieAvancement paie = new PaieAvancement();

                paie.setId_logpers(emp.getId());
                paie.setService(emp.getService());
                paie.setIdfonction(emp.getIdfonction());

                return paie;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (isOpen && con != null) con.close();
        }

        return null;
    }

    public String getCheminImage() {
        return cheminImage;
    }

    public void setCheminImage(String cheminImage) {
        this.cheminImage = cheminImage;
    }

    public String getFormation() {
        return formation;
    }

    public void setFormation(String formation) {
        this.formation = formation;
    }

    public String getDiscipline() {
        return discipline;
    }

    public void setDiscipline(String discipline) {
        this.discipline = discipline;
    }

    public String getAnneeExperience() {
        return anneeExperience;
    }

    public void setAnneeExperience(String anneeExperience) {
        this.anneeExperience = anneeExperience;
    }

    public String getIdcategorie_paie() {
        return idcategorie_paie;
    }

    public void setIdcategorie_paie(String idcategorie_paie) {
        this.idcategorie_paie = idcategorie_paie;
    }

    public String getIdqualification() {
        return idqualification;
    }

    public void setIdqualification(String idqualification) {
        this.idqualification = idqualification;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public String getAdresse_ligne1() {
        return adresse_ligne1;
    }

    public void setAdresse_ligne1(String adresse_ligne1) {
        this.adresse_ligne1 = adresse_ligne1;
    }

    public String getAdresse_ligne2() {
        return adresse_ligne2;
    }

    public void setAdresse_ligne2(String adresse_ligne2) {
        this.adresse_ligne2 = adresse_ligne2;
    }

    public String getCode_postal() {
        return code_postal;
    }

    public void setCode_postal(String code_postal) {
        this.code_postal = code_postal;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone)throws Exception{
        if (this.getId() == null && this.getMode().compareTo("modif") == 0) {
            if (String.valueOf(telephone) == null || String.valueOf(telephone).compareToIgnoreCase("") == 0) {
                throw new Exception("Telephone Obligatoire");
            }
        }
        this.telephone = telephone;
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","matricule", "nom", "prenom"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] valMotCles={"id","matricule", "nom", "prenom"};
        return valMotCles;
    }

    public String getMail() {
        return mail;
    }

    public void setMail(String mail) {
        this.mail = mail;
    }

    public String getMotifIndesirable() {
        return motifIndesirable;
    }

    public void setMotifIndesirable(String motifIndesirable) {
        this.motifIndesirable = motifIndesirable;
    }
    public int getIndesirable() {
        return indesirable;
    }

    public void setIndesirable(int indesirable) {
        this.indesirable = indesirable;
    }

    public double getHeurejournalier() {
        return heurejournalier;
    }

    public void setHeurejournalier(double heurejournalier) {
        this.heurejournalier = heurejournalier;
    }

    public double getHeurehebdomadaire() {
        return heurehebdomadaire;
    }

    public void setHeurehebdomadaire(double heurehebdomadaire) {
        this.heurehebdomadaire = heurehebdomadaire;
    }

    public double getHeuremensuel() {
        return heuremensuel;
    }

    public void setHeuremensuel(double heuremensuel) {
        this.heuremensuel = heuremensuel;
    }

    public String getEchelon() {
        return echelon;
    }

    public void setEchelon(String echelon) {
        this.echelon = echelon;
    }
    private Date dateembauche, datesaisie;

    public static int monthsBetween(Date d1, Date d2) throws Exception {
        if (d1 == null || d2 == null) {
            return 0;
        }

        LocalDate start = d1.toLocalDate();
        LocalDate end = d2.toLocalDate();

        long months = ChronoUnit.MONTHS.between(start, end);

        return (int) Math.max(months, 0);
    }

    public static String getPrefix(String s) {
        if (s == null || s.length() < 3) {
            return s;
        }
        return s.substring(0, 3);
    }



    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        return this.saveNewPerson(u, c);
    }

    @Override
    public int updateToTableWithHisto(String refUser, Connection c) throws Exception {
        try {
            this.updateEmploye(this,c,refUser);
            return 1;
        } catch (Exception e) {
            throw new Exception("Erreur de modification", e);
        }
    }

    public EmployeComplet() {
        super.setNomTable("EMPLOYE_COMPLET");
    }

    public EmployeComplet(String id, String nom, String prenom, Date date_naissance, String lieu_naissance_commune, String sexe, String numero_cin, Date date_cin, Date date_dupl_cin, String lieu_delivrance_cin, String adresse, String fokotany, String nationalite, String acte_naissance, String situation_matrimonial, String idconjoint, String initiale, String matricule, String direction, String service, String idfonction, String idcategorie, String classee, String indicegrade, String indice_fonctionnel, String matricule_patron, String statut, String mode_paiement, String code_agence_banque, String banque_compte_cle, String banque_numero_compte, String permis_conduire, String cturgence_nom_prenom, String cturgence_telephone1, String cturgence_telephone2, String cturgence_telephone3, Date dateembauche, Date datesaisie, int nbr_enfant) throws Exception {
        super.setNomTable("LOG_PERSONNEL");
        this.setId(id);
        this.setNom(nom);
        this.setPrenom(prenom);
        this.setDate_naissance(date_naissance);
        this.setLieu_naissance_commune(lieu_naissance_commune);
        this.setSexe(sexe);
        this.setNumero_cin(numero_cin);
        this.setDate_cin(date_cin);
        this.setDate_dupl_cin(date_dupl_cin);
        this.setLieu_delivrance_cin(lieu_delivrance_cin);
        this.setAdresse(adresse);
        this.setFokotany(fokotany);
        this.setNationalite(nationalite);
        this.setActe_naissance(acte_naissance);
        this.setSituation_matrimonial(situation_matrimonial);
        this.setIdconjoint(idconjoint);
        this.setInitiale(initiale);
        this.setMatricule(matricule);
        this.setDirection(direction);
        this.setService(service);
        this.setIdfonction(idfonction);
        this.setIdcategorie(idcategorie);
        this.setClassee(classee);
        this.setIndice_fonctionnel(indice_fonctionnel);
        this.setMatricule_patron(matricule_patron);
        this.setStatut(statut);
        this.setMode_paiement(mode_paiement);
        this.setCode_agence_banque(code_agence_banque);
        this.setBanque_compte_cle(banque_compte_cle);
        this.setBanque_numero_compte(banque_numero_compte);
        this.setPermis_conduire(permis_conduire);
        this.setCturgence_nom_prenom(cturgence_nom_prenom);
        this.setCturgence_telephone1(cturgence_telephone1);
        this.setCturgence_telephone2(cturgence_telephone2);
        this.setCturgence_telephone3(cturgence_telephone2);
        this.setDateembauche(dateembauche);
        this.setDatesaisie(datesaisie);
        this.setNbenfant(nbr_enfant);
    }

    public EmployeComplet(String nom, String prenom, Date date_naissance, String lieu_naissance_commune, String sexe, String numero_cin, Date date_cin, Date date_dupl_cin, String lieu_delivrance_cin, String adresse, String fokotany, String nationalite, String acte_naissance, String situation_matrimonial, String idconjoint, String initiale, String matricule, String direction, String service, String idfonction, String idcategorie, String classee, String indicegrade, String indice_fonctionnel, String matricule_patron, String statut, String mode_paiement, String code_agence_banque, String banque_compte_cle, String banque_numero_compte, String permis_conduire, String cturgence_nom_prenom, String cturgence_telephone1, String cturgence_telephone2, String cturgence_telephone3, Date dateembauche, Date datesaisie, int nbr_enfant) throws Exception {
        super.setNomTable("EMPLOYE_COMPLET");
        this.setNom(nom);
        this.setPrenom(prenom);
        this.setDate_naissance(date_naissance);
        this.setLieu_naissance_commune(lieu_naissance_commune);
        this.setSexe(sexe);
        this.setNumero_cin(numero_cin);
        this.setDate_cin(date_cin);
        this.setDate_dupl_cin(date_dupl_cin);
        this.setLieu_delivrance_cin(lieu_delivrance_cin);
        this.setAdresse(adresse);
        this.setFokotany(fokotany);
        this.setNationalite(nationalite);
        this.setActe_naissance(acte_naissance);
        this.setSituation_matrimonial(situation_matrimonial);
        this.setIdconjoint(idconjoint);
        this.setInitiale(initiale);
        this.setMatricule(matricule);
        this.setDirection(direction);
        this.setService(service);
        this.setIdfonction(idfonction);
        this.setIdcategorie(idcategorie);
        this.setClassee(classee);
        this.setIndice_fonctionnel(indice_fonctionnel);
        this.setMatricule_patron(matricule_patron);
        this.setStatut(statut);
        this.setMode_paiement(mode_paiement);
        this.setCode_agence_banque(code_agence_banque);
        this.setBanque_compte_cle(banque_compte_cle);
        this.setBanque_numero_compte(banque_numero_compte);
        this.setPermis_conduire(permis_conduire);
        this.setCturgence_nom_prenom(cturgence_nom_prenom);
        this.setCturgence_telephone1(cturgence_telephone1);
        this.setCturgence_telephone2(cturgence_telephone2);
        this.setCturgence_telephone3(cturgence_telephone2);
        this.setDateembauche(dateembauche);
        this.setDatesaisie(datesaisie);
        this.setNbenfant(nbr_enfant);
    }


    public EmployeComplet(String nom, String prenom, Date date_naissance, String lieu_naissance_commune, String sexe, String numero_cin, Date date_cin, Date date_dupl_cin, String lieu_delivrance_cin, String adresse, String fokotany, String nationalite, String acte_naissance, String situation_matrimonial, String idconjoint, String initiale, String matricule, String direction, String service, String idfonction, String idcategorie, String classee, String indicegrade, String indice_fonctionnel, String matricule_patron, String statut, String mode_paiement, String code_agence_banque, String banque_compte_cle, String banque_numero_compte, String permis_conduire, String cturgence_nom_prenom, String cturgence_telephone1, String cturgence_telephone2, String cturgence_telephone3, Date dateembauche, Date datesaisie, int nbr_enfant, Date debutcontrat, Date fincontrat) throws Exception {
        super.setNomTable("EMPLOYE_COMPLET");
        this.setNom(nom);
        this.setPrenom(prenom);
        this.setDate_naissance(date_naissance);
        this.setLieu_naissance_commune(lieu_naissance_commune);
        this.setSexe(sexe);
        this.setNumero_cin(numero_cin);
        this.setDate_cin(date_cin);
        this.setDate_dupl_cin(date_dupl_cin);
        this.setLieu_delivrance_cin(lieu_delivrance_cin);
        this.setAdresse(adresse);
        this.setFokotany(fokotany);
        this.setNationalite(nationalite);
        this.setActe_naissance(acte_naissance);
        this.setSituation_matrimonial(situation_matrimonial);
        this.setIdconjoint(idconjoint);
        this.setInitiale(initiale);
        this.setMatricule(matricule);
        this.setDirection(direction);
        this.setService(service);
        this.setIdfonction(idfonction);
        this.setIdcategorie(idcategorie);
        this.setClassee(classee);
        this.setIndice_fonctionnel(indice_fonctionnel);
        this.setMatricule_patron(matricule_patron);
        this.setStatut(statut);
        this.setMode_paiement(mode_paiement);
        this.setCode_agence_banque(code_agence_banque);
        this.setBanque_compte_cle(banque_compte_cle);
        this.setBanque_numero_compte(banque_numero_compte);
        this.setPermis_conduire(permis_conduire);
        this.setCturgence_nom_prenom(cturgence_nom_prenom);
        this.setCturgence_telephone1(cturgence_telephone1);
        this.setCturgence_telephone2(cturgence_telephone2);
        this.setCturgence_telephone3(cturgence_telephone2);
        this.setDateembauche(dateembauche);
        this.setDatesaisie(datesaisie);
        this.setNbenfant(nbr_enfant);
        this.setDebutcontrat(debutcontrat);
        this.setFincontrat(fincontrat);
    }

    public void updateEmploye(EmployeComplet e, Connection c, String refuser) throws Exception {
        LogPersonnel[] lg = (LogPersonnel[]) CGenUtil.rechercher(new LogPersonnel(), null, null, c, " AND ID = '" + e.getId() + "'");
        PaieInfoPersonnel[] i = (PaieInfoPersonnel[]) CGenUtil.rechercher(new PaieInfoPersonnel(), null, null, c, " AND ID = '" + e.getId() + "'");
        if (lg.length == 0 || i.length == 0) {
            throw new Exception("Employe introuvable");
        }
        LogPersonnel log = lg[0];
        PaieInfoPersonnel info = i[0];

        String matriculePrefix = EmployeComplet.getPrefix(e.getMatricule());
        String matricule = e.getMatricule();

        if (!matriculePrefix.equals(e.getIdSociete()))
        {
            System.out.println("NOT THE SAME, CHANGE FROM = " + matriculePrefix);
            int sequenceNumber = Utilitaire.getMaxSeq(ConstanteAxelle.SEQUENCE_MATRICULE_CREATION, c);

            matricule = e.getIdSociete() + "0000" + sequenceNumber;

        }

        log.setNom(e.getNom());
        log.setPrenom(e.getPrenom());
        info.setInitial(e.getInitiale());
        info.setMatricule(matricule);
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

        // Conversion sécurisée de l'échelon
        if (e.getEchelon() != null && !e.getEchelon().isEmpty()) {
            try {
                info.setEchelon(Integer.parseInt(e.getEchelon()));
            } catch (NumberFormatException ex) {
                throw new Exception("Échelon invalide : " + e.getEchelon());
            }
        }

        info.setNbenfant(e.getNbenfant());
        info.setIndesirable(e.getIndesirable());

        info.setIdcategorie(e.getIdcategorie());
        info.setCtg(e.getCtg());
        info.setClassee(e.getClassee());
        info.setIndicegrade(e.getIndicegrade());
        info.setIndice_fonctionnel(e.getIndice_fonctionnel());
        info.setStatut(e.getStatut());
        info.setTelephone(e.getTelephone());
        info.setMail(e.getMail());
        info.setTypeContrat(e.getTypeContrat());
        info.setAnneeExperience(e.getAnneeExperience());
        /*
        if (u.getRang()>=6) { // izay users manana role >=6 no afaka manova anio
            info.setIdcategorie(e.getIdcategorie());
            info.setCtg(e.getCtg());
            info.setEchelon(Integer.valueOf(e.getEchelon()));
            info.setClassee(e.getClassee());
            info.setIndicegrade(e.getIndicegrade());
            info.setIndice_fonctionnel(e.getIndice_fonctionnel());
            info.setStatut(e.getStatut());
        }
         */

        log.setChemin_permis(e.getChemin_permis());
        info.setIdDepartement(e.getIdDepartement());
        log.setIdCivilite(e.getIdCivilite());
        info.setIdBanque(e.getIdBanque());
        info.setIdAgence(e.getIdAgence());
        info.setNumeroCarteSejour(e.getNumeroCarteSejour());
        info.setNumeroSecuriteSociale(e.getNumeroSecuriteSociale());
        info.setDateExpiration(e.getDateExpiration());
        log.setAdresse2(e.getAdresse2());
        log.setCommune(e.getCommune());
        info.setRegion(e.getRegion());
        info.setReferenceContrat(e.getReferenceContrat());
        info.setPays(e.getPays());
        log.setPays(e.getPays());
        info.setDateDebutPeriodeEssai(e.getDateDebutPeriodeEssai());
        info.setDateFinPeriodeEssai(e.getDateFinPeriodeEssai());
        info.setDureePeriodeDessai(EmployeComplet.monthsBetween(e.getDateDebutPeriodeEssai(), e.getDateFinPeriodeEssai()));
        info.setDateEntreeProfession(e.getDateEntreeProfession());
        info.setDateEntreeEtablissement(e.getDateEntreeEtablissement());
        info.setUnite(e.getUnite());
        info.setNiveau(e.getNiveau());
        info.setTypeCalcul(e.getTypeCalcul());
        info.setSalaireBase(e.getSalaireBase());
        info.setTypeHoraire(e.getTypeHoraire());
        info.setModaliteTravail(e.getModaliteTravail());
        log.setDistance(e.getDistance());
        info.setIdSociete(e.getIdSociete());
        info.setIdHierarchie(e.getIdHierarchie());
        info.setIdcategorie_paie(e.getIdcategorie_paie());
        info.setIdqualification(e.getIdqualification());
        info.setDiscipline(e.getDiscipline());
        info.setFormation(e.getFormation());
        info.setDebutcontrat(e.getDebutcontrat());
        info.setFincontrat(e.getFincontrat());
        info.setTypeEntree(e.getTypeEntree());
        info.setIdSection(e.getIdSection());


        info.updateToTableWithHisto(refuser, c);
        log.updateToTableWithHisto(refuser, c);
    }


    public LogPersonnel saveNewPerson(String u, Connection c) throws Exception {
        try {
            this.setDatesaisie(Utilitaire.dateDuJourSql());

            //System.out.println("nombre enfantsssssssssssssssssssssssssssss ; " + ec.getNbenfant());
            if (this.getService() == null || this.getService().compareToIgnoreCase("") == 0) {
                throw new Exception("Service obligatoire");
            }
            PaieInfoPersonnel pipe = new PaieInfoPersonnel();
            pipe.setNomTable("PAIE_INFO_EMBAUCHE");
            PaieInfoPersonnel[] matriculeTest = (PaieInfoPersonnel[]) CGenUtil.rechercher(pipe, null, null, c, " AND MATRICULE = '" + this.getMatricule() + "' AND DIRECTION = '" + this.getDirection() + "'");
            if (matriculeTest.length > 0) {
                throw new Exception("Matricule deja existant dans cet exploitation");
            }

            //insertion sig personne
            SigPersonnes s = new SigPersonnes(this.getNom(), this.getPrenom(), this.getSexe(), this.getNumero_cin(), this.getDate_cin(), this.getDate_dupl_cin(), this.getLieu_delivrance_cin(), this.getActe_naissance(), this.getDate_naissance(), this.getNationalite(), this.getFokotany(), this.getAdresse());
            s.controler(c);
            s.construirePK(c);
            s.insertToTableWithHisto(u, c);

            Ville v = new Ville();
            v.setId(this.getCommune());

            Ville[] villes = (Ville[]) CGenUtil.rechercher(v, null, null, c, "");

            if (villes == null || villes.length == 0)
            {
                throw new Exception("La ville: " + this.getCommune() + " n'existe pas");
            }


            //insertion log personnel
            LogPersonnel logp = new LogPersonnel(this.getPermis_conduire(), " ", " ", s.getId(), this.getNom(), this.getPrenom(), this.getDate_naissance(), this.getSexe(), this.getNumero_cin(), this.getDate_cin(), this.getDate_dupl_cin(), this.getNationalite(), this.getAdresse(), this.getFokotany(), this.getActe_naissance(), this.getDirection(), this.getService(), this.getCheminImage());
            logp.setMere(this.getMere());
            logp.setPere(this.getPere());
            logp.setIdCivilite(this.getIdCivilite());
            logp.setNomDusage(this.getNomDusage());
            logp.setAdresse2(this.getAdresse2());
            logp.setCommune(this.getCommune());
            logp.setPays(this.getPays());
            logp.setDistance(this.getDistance());
            logp.setDirection(this.getDirection());
            logp.setIdDirection(this.getDirection());
            logp.setRefUser(1060);
            logp.controler(c);
            logp.construirePK(c);
            logp.insertToTableWithHisto(u, c);

            TypeObjet obj = new TypeObjet();
//        obj.setNomTable("region");
//        TypeObjet[] tabRegion = (TypeObjet[])CGenUtil.rechercher(obj, null, null, c, " and id = '"+ec.getRegion()+"'");
            obj.setNomTable("log_direction");
            TypeObjet[] tabSousAffect = (TypeObjet[]) CGenUtil.rechercher(obj, null, null, c, " and id = '" + this.getDirection() + "'");
            LogService[] service = (LogService[]) CGenUtil.rechercher(new LogService(), null, null, c, " and id = '" + this.getService() + "'");
//insertion paie info personnel
//            String matricule = service[0].getCode_service() + "/" + Utilitaire.completerInt(2, tabSousAffect[0].getDesce()) + "/" + Utilitaire.completerInt(5, Utilitaire.getMaxSeq("get_seq" + service[0].getCode_service(), c));
//            String matricule =Utilitaire.getMaxSeq("get_seq" + ConstanteXC.indiceMatricule, c)) + "-" + ConstanteXC.indiceMatricule;


//            String nomProcedure = "get_seq" + ConstanteXC.indiceMatricule;
//            String matricule = null;
//            if (this.getIdcategorie_paie().equals(ConstantePaie.idCategoriePaieTemp))
//            {
//                matricule =  Utilitaire.getMaxSeq(nomProcedure, c) + ConstantePaie.matriculeTemp;
//            }
//            else {
//                matricule = Utilitaire.getMaxSeq(nomProcedure, c) + "";
//            }


            if (this.getIdSociete() == null || this.getIdSociete().trim().isEmpty()) {
                throw new Exception("Societe obligatoire");
            }
            String typeSociete = this.getIdSociete() + "0000";

            int sequenceNumber = Utilitaire.getMaxSeq(ConstanteAxelle.SEQUENCE_MATRICULE_CREATION, c);

            String generatedMatricule = typeSociete + sequenceNumber;


            String matricule = this.getMatricule();
            PaieInfoPersonnel pinf = new PaieInfoPersonnel(logp.getId(), matricule, this.getLieu_naissance_commune(), this.getLieu_delivrance_cin(), this.getSituation_matrimonial(), this.getInitiale(), this.getDatesaisie(), this.getCturgence_nom_prenom(), this.getCturgence_telephone1(), this.getCturgence_telephone2(), this.getCturgence_telephone3(), this.getIdconjoint(), this.getCode_agence_banque(), this.getBanque_numero_compte(), this.getBanque_compte_cle(), this.getDateembauche(), this.getIdfonction(), this.getIdcategorie(), this.getMode_paiement(), this.getClassee(), this.getIndicegrade(), this.getIndice_fonctionnel(), this.getMatricule_patron(), this.getStatut(), "o", this.getDebutcontrat(), this.getFincontrat());
            pinf.setIdcategorie_paie(this.getIdcategorie_paie());
            pinf.setDatesaisie(Utilitaire.dateDuJourSql());
//        pinf.setEchelon(Integer.valueOf(ec.getEchelon()));
            pinf.setCtg(this.getCtg());
            pinf.setVehiculee(this.getVehiculee());
            pinf.setEtat(ConstanteEtatPaie.getEtatCreer());
            pinf.setHeurejournalier(this.getHeurejournalier());
            pinf.setHeurehebdomadaire(this.getHeurehebdomadaire());
            pinf.setHeuremensuel(this.getHeuremensuel());
            pinf.setTypeContrat(this.getTypeContrat());
            pinf.setNumero_cnaps(this.getNumero_cnaps());
            pinf.setNumero_ostie(this.getNumero_ostie());
            pinf.setNbenfant(this.getNbenfant());
            pinf.setIndesirable(this.getIndesirable());
            pinf.setTelephone(this.getTelephone());
            pinf.setMail(this.getMail());
            pinf.setRegion(this.getRegion());
            pinf.setAdresse_ligne1(this.getAdresse_ligne1());
            pinf.setAdresse_ligne2(this.getAdresse_ligne2());
            pinf.setCode_postal(villes[0].getCodePostal());
            pinf.setIdcategorie_paie(this.getIdcategorie_paie());
            pinf.setIdqualification(this.getIdqualification());
            pinf.setFormation(this.getFormation());
            pinf.setDiscipline(this.getDiscipline());
            pinf.setAnneeExperience(this.getAnneeExperience());
            pinf.setPersonnel_etat(this.getPersonnel_etat());
            pinf.setDebutcontrat(this.getDebutcontrat());
            pinf.setFincontrat(this.getFincontrat());
            pinf.setIdBanque(this.getIdBanque());
            pinf.setIdAgence(this.getIdAgence());
            pinf.setNumeroSecuriteSociale(this.getNumeroSecuriteSociale());
            pinf.setNumeroCarteSejour(this.getNumeroCarteSejour());
            pinf.setDateExpiration(this.getDateExpiration());
            pinf.setReferenceContrat(this.getReferenceContrat());
            pinf.setDateDebutPeriodeEssai(this.getDateDebutPeriodeEssai());
            pinf.setDateFinPeriodeEssai(calculateDateFinPeriodeEssai(this.getDureePeriodeDessai(), this.getDateDebutPeriodeEssai()));
            pinf.setTypeEntree(this.getTypeEntree());
            pinf.setDateEntreeProfession(this.getDateEntreeProfession());
            pinf.setDateEntreeEtablissement(this.getDateEntreeEtablissement());
            pinf.setDureePeriodeDessai(this.getDureePeriodeDessai());
            pinf.setIdDepartement(this.getIdDepartement());
            pinf.setService(this.getService());
            pinf.setUnite(this.getUnite());
            pinf.setIdfonction(this.getIdfonction());
            pinf.setIdHierarchie(this.getIdHierarchie());
            pinf.setNiveau(this.getNiveau());
            pinf.setIndice(this.getIndice());
            pinf.setCoefficient(this.getCoefficient());
            pinf.setDateDebutPoste(this.getDateDebutPoste());
            pinf.setDateFinPoste(this.getDateFinPoste());
            pinf.setTypeCalcul(this.getTypeCalcul());
            pinf.setSalaireBase(this.getSalaireBase());
            pinf.setTypeHoraire(this.getTypeHoraire());
            pinf.setHeurehebdomadaire(this.getHeurehebdomadaire());
            pinf.setModaliteTravail(this.getModaliteTravail());
            pinf.setHeuremensuel(this.getHeuremensuel());
            pinf.setIdSociete(this.getIdSociete());
            pinf.setCturgence_nom_prenom(this.getCturgence_nom_prenom());
            pinf.setCturgence_telephone1(this.getCturgence_telephone1());
            pinf.setCantine(String.valueOf(this.getCantine()));
            pinf.setTransport(this.getTransport());
            pinf.setEstRattacheCnaps(this.getEstRattacheCnaps());
            pinf.setEstRattacheOstie(this.getEstRattacheOstie());
            pinf.setMatricule(generatedMatricule);
            pinf.setIdSection(this.getIdSection());
            pinf.setPays(this.getPays());
            pinf.setIdBu(this.getIdBu());


            if (ConstantePaie.CATEGORIE_TEMPORAIRE.equals(this.getIdcategorie_paie()))
            {
                System.out.println("TEMP CATEGORIE: " + this.getIdcategorie_paie() + " C:" + ConstantePaie.CATEGORIE_TEMPORAIRE);
                pinf.setTemporaire(-1);
            }
            else {
                System.out.println("No CATEGORIE: " + this.getIdcategorie_paie()+ " C:" + ConstantePaie.CATEGORIE_TEMPORAIRE);
                pinf.setTemporaire(0);
            }


            //numero de compte
            if (!this.getCode_agence_banque().isEmpty()) {
                if (this.getBanque_numero_compte().isEmpty()) {
                    throw new Exception("Numero de compte ne doit pas etre vide");
                }
                if (this.getBanque_compte_cle().isEmpty()) {
                    throw new Exception("Cle banque ne doit pas etre vide");
                }
                if (this.getBanque_numero_compte().length() != 11 && this.getBanque_numero_compte().length() != 24) {
                    throw new Exception("Numero de compte invalide. 11 caracteres ou 24 caract?res");
                }
                if (this.getBanque_numero_compte().length() == 11) {
                    String numerodthisompte = this.getBanque_numero_compte() + this.getBanque_compte_cle();
                    TrsBanqueAgenceDetails[] bankAg = (TrsBanqueAgenceDetails[]) CGenUtil.rechercher(new TrsBanqueAgenceDetails(), null, null, c, " AND ID = '" + this.getCode_agence_banque() + "'");
                    if (bankAg.length == 0) {
                        throw new Exception("Banque inexistant");
                    }
                    numerodthisompte = bankAg[0].getCodebanque() + bankAg[0].getCodeagence() + numerodthisompte;
                    pinf.setBanque_numero_compte(numerodthisompte);
                }
                if (this.getBanque_numero_compte().length() == 24) {
                    pinf.setBanque_numero_compte(this.getBanque_numero_compte());
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
            System.out.println("Temporaire" + pinf.getTemporaire());
            pinf.insertToTableWithHisto(u, c);

            //insertion avancement
//            PaieAvancement pa = new PaieAvancement(logp.getId(), this.getDirection(), this.getService(), this.getIdfonction(), this.getIdcategorie(), "", "", this.getDateembauche(), this.getDateembauche(), 0, Utilitaire.stringToInt(this.getIndicegrade()), Utilitaire.stringToInt(this.getIndice_fonctionnel()), this.getClassee(), this.getMatricule_patron(), this.getStatut(), "o");
//            pa.setCtg(this.getCtg());
////        pa.setMotif("Embauche");
//            pa.setVehiculee(this.getVehiculee());
//            pa.setEtat(ConstanteEtatPaie.getEtatCreer());
//            pa.construirePK(c);
//            pa.insertToTableWithHisto(u, c);
            return logp;
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    public static Date calculateDateFinPeriodeEssai(int months, Date dateDebut) throws Exception {
        LocalDate localDate = dateDebut.toLocalDate();

        // Add months
        LocalDate result = localDate.plusMonths(months);

        // If original day was end of month, force result to end of month
        if (localDate.getDayOfMonth() == localDate.lengthOfMonth()) {
            result = result.withDayOfMonth(result.lengthOfMonth());
        }

        return Date.valueOf(result);
    }


    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    /**
     * @return the id
     */
    public String getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(String id) {
        this.id = id;
    }

    /**
     * @return the nom
     */
    public String getNom() {
        return nom;
    }

    /**
     * @param nom the nom to set
     */
    public void setNom(String nom) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.nom = nom;
            return;
        }
        if (String.valueOf(nom) == null || String.valueOf(nom).compareToIgnoreCase(" ") == 0) {
            throw new Exception("Nom Obligatoire");
        }
        this.nom = nom;
    }

    /**
     * @return the prenom
     */
    public String getPrenom() {
        if (prenom == null || prenom.equals("null")) {
            return "";
        }
        return prenom;
    }

    /**
     * @param prenom the prenom to set
     */
    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    /**
     * @return the date_naissance
     */
    public Date getDate_naissance() {
        return date_naissance;
    }

    /**
     * @param date_naissance the date_naissance to set
     */
    public void setDate_naissance(Date date_naissance) {
        this.date_naissance = date_naissance;
    }

    /**
     * @return the lieu_naissance_commune
     */
    public String getLieu_naissance_commune() {
        return lieu_naissance_commune;
    }

    /**
     * @param lieu_naissance_commune the lieu_naissance_commune to set
     */
    public void setLieu_naissance_commune(String lieu_naissance_commune) {
        this.lieu_naissance_commune = lieu_naissance_commune;
    }

    /**
     * @return the sexe
     */
    public String getSexe() {
        return sexe;
    }

    /**
     * @param sexe the sexe to set
     */
    public void setSexe(String sexe) {
        this.sexe = sexe;
    }

    /**
     * @return the numero_cin
     */
    public String getNumero_cin() {
        return numero_cin;
    }

    /**
     * @param numero_cin the numero_cin to set
     */
    public void setNumero_cin(String numero_cin) {
        this.numero_cin = numero_cin;
    }

    /**
     * @return the date_cin
     */
    public Date getDate_cin() {
        return date_cin;
    }

    /**
     * @param date_cin the date_cin to set
     */
    public void setDate_cin(Date date_cin) {
        this.date_cin = date_cin;
    }

    /**
     * @return the date_dupl_cin
     */
    public Date getDate_dupl_cin() {
        return date_dupl_cin;
    }

    /**
     * @param date_dupl_cin the date_dupl_cin to set
     */
    public void setDate_dupl_cin(Date date_dupl_cin) {
        this.date_dupl_cin = date_dupl_cin;
    }

    /**
     * @return the lieu_delivrance_cin
     */
    public String getLieu_delivrance_cin() {
        return lieu_delivrance_cin;
    }

    /**
     * @param lieu_delivrance_cin the lieu_delivrance_cin to set
     */
    public void setLieu_delivrance_cin(String lieu_delivrance_cin) {
        this.lieu_delivrance_cin = lieu_delivrance_cin;
    }

    /**
     * @return the adresse
     */
    public String getAdresse() {
        return adresse;
    }

    /**
     * @param adresse the adresse to set
     */
    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    /**
     * @return the fokotany
     */
    public String getFokotany() {
        return fokotany;
    }

    /**
     * @param fokotany the fokotany to set
     */
    public void setFokotany(String fokotany) {
        this.fokotany = fokotany;
    }

    /**
     * @return the nationalite
     */
    public String getNationalite() {
        return nationalite;
    }

    /**
     * @param nationalite the nationalite to set
     */
    public void setNationalite(String nationalite) {
        this.nationalite = nationalite;
    }

    /**
     * @return the acte_naissance
     */
    public String getActe_naissance() {
        return acte_naissance;
    }

    /**
     * @param acte_naissance the acte_naissance to set
     */
    public void setActe_naissance(String acte_naissance) {
        this.acte_naissance = acte_naissance;
    }

    /**
     * @return the situation_matrimonial
     */
    public String getSituation_matrimonial() {
        return situation_matrimonial;
    }

    /**
     * @param situation_matrimonial the situation_matrimonial to set
     */
    public void setSituation_matrimonial(String situation_matrimonial) {
        this.situation_matrimonial = situation_matrimonial;
    }

    /**
     * @return the idconjoint
     */
    public String getIdconjoint() {
        return idconjoint;
    }

    /**
     * @param idconjoint the idconjoint to set
     */
    public void setIdconjoint(String idconjoint) {
        this.idconjoint = idconjoint;
    }

    /**
     * @return the initiale
     */
    public String getInitiale() {
        return initiale;
    }

    /**
     * @param initiale the initiale to set
     */
    public void setInitiale(String initiale) {
        this.initiale = initiale;
    }

    /**
     * @return the matricule
     */
    public String getMatricule() {
        return matricule;
    }

    /**
     * @param matricule the matricule to set
     */
    public void setMatricule(String matricule) throws Exception {
        this.matricule = matricule;
    }

    /**
     * @return the direction
     */
    public String getDirection() {
        return direction;
    }

    /**
     * @param direction the direction to set
     */
    public void setDirection(String direction) {
        this.direction = direction;
    }

    /**
     * @return the service
     */
    public String getService() {
        return service;
    }

    /**
     * @param service the service to set
     */
    public void setService(String service) {
        this.service = service;
    }

    /**
     * @return the idfonction
     */
    public String getIdfonction() {
        return idfonction;
    }

    /**
     * @param idfonction the idfonction to set
     */
    public void setIdfonction(String idfonction) throws Exception {
        try {
            if (getMode().compareTo("modif") != 0) {
                this.idfonction = idfonction;
                return;
            }
            if (idfonction == null || idfonction.compareToIgnoreCase("") == 0) {
                throw new Exception("Fonction obligatoire");
            }
            this.idfonction = idfonction;
        } catch (Exception e) {
            throw e;
        }
    }

    /**
     * @return the idcategorie
     */
    public String getIdcategorie() {
        return idcategorie;
    }

    /**
     * @param idcategorie the idcategorie to set
     */
    public void setIdcategorie(String idcategorie) throws Exception {
        try {
            if (getMode().compareTo("modif") != 0) {
                this.idcategorie = idcategorie;
                return;
            }
            this.idcategorie = idcategorie;
        } catch (Exception e) {
            throw e;
        }
    }

    public String getCtg() {
        return ctg;
    }

    public void setCtg(String ctg) {
        this.ctg = ctg;
    }

    /**
     * @return the classee
     */
    public String getClassee() {
        return classee;
    }

    /**
     * @param classee the classee to set
     */
    public void setClassee(String classee) {
        this.classee = classee;
    }

    /**
     * @return the indicegrade
     */
    public String getIndicegrade() {
        return indicegrade;
    }

    /**
     * @param indicegrade the indicegrade to set
     */
    public void setIndicegrade(String indicegrade) throws Exception {
        /*  try {
         if (getMode().compareTo("modif") != 0) {
         this.indicegrade = indicegrade;
         return;
         }
         if (indicegrade == null || indicegrade.compareToIgnoreCase("") == 0) {
         throw new Exception("Indice obligatoire");
         }
         try {
         double a = Double.parseDouble(indicegrade);
         } catch (Exception ee) {
         throw new Exception("Indice invalide");
         }*/
        this.indicegrade = indicegrade;
        /*    } catch (Exception e) {
         throw e;
         }*/
    }

    /**
     * @return the indicefonctionnel
     */
    public String getIndice_fonctionnel() {
        return indice_fonctionnel;
    }

    /**
     * @param indicefonctionnel the indicefonctionnel to set
     */
    public void setIndice_fonctionnel(String indice_fonctionnel) {
        this.indice_fonctionnel = indice_fonctionnel;
    }

    /**
     * @return the matricule_patron
     */
    public String getMatricule_patron() {
        return matricule_patron;
    }

    /**
     * @param matricule_patron the matricule_patron to set
     */
    public void setMatricule_patron(String matricule_patron) {
        this.matricule_patron = matricule_patron;
    }

    /**
     * @return the statut
     */
    public String getStatut() {
        return statut;
    }

    /**
     * @param statut the statut to set
     */
    public void setStatut(String statut) {
        this.statut = statut;
    }

    /**
     * @return the mode_paiement
     */
    public String getMode_paiement() {
        return mode_paiement;
    }

    /**
     * @param mode_paiement the mode_paiement to set
     */
    public void setMode_paiement(String mode_paiement) {
        this.mode_paiement = mode_paiement;
    }

    /**
     * @return the code_agence_banque
     */
    public String getCode_agence_banque() {
        return code_agence_banque;
    }

    /**
     * @param code_agence_banque the code_agence_banque to set
     */
    public void setCode_agence_banque(String code_agence_banque) {
        this.code_agence_banque = code_agence_banque;
    }

    /**
     * @return the banque_compte_cle
     */
    public String getBanque_compte_cle() {
        return banque_compte_cle;
    }

    /**
     * @param banque_compte_cle the banque_compte_cle to set
     */
    public void setBanque_compte_cle(String banque_compte_cle) {
        this.banque_compte_cle = banque_compte_cle;
    }

    /**
     * @return the banque_numero_compte
     */
    public String getBanque_numero_compte() {
        return banque_numero_compte;
    }

    /**
     * @param banque_numero_compte the banque_numero_compte to set
     */
    public void setBanque_numero_compte(String banque_numero_compte) {
        this.banque_numero_compte = banque_numero_compte;
    }

    /**
     * @return the cturgence_nom_prenom
     */
    public String getCturgence_nom_prenom() {
        return cturgence_nom_prenom;
    }

    /**
     * @param cturgence_nom_prenom the cturgence_nom_prenom to set
     */
    public void setCturgence_nom_prenom(String cturgence_nom_prenom) {
        this.cturgence_nom_prenom = cturgence_nom_prenom;
    }

    /**
     * @return the cturgence_telephone1
     */
    public String getCturgence_telephone1() {
        return cturgence_telephone1;
    }

    /**
     * @param cturgence_telephone1 the cturgence_telephone1 to set
     */
    public void setCturgence_telephone1(String cturgence_telephone1) {
        this.cturgence_telephone1 = cturgence_telephone1;
    }

    /**
     * @return the cturgence_telephone2
     */
    public String getCturgence_telephone2() {
        return cturgence_telephone2;
    }

    /**
     * @param cturgence_telephone2 the cturgence_telephone2 to set
     */
    public void setCturgence_telephone2(String cturgence_telephone2) {
        this.cturgence_telephone2 = cturgence_telephone2;
    }

    /**
     * @return the cturgence_telephone3
     */
    public String getCturgence_telephone3() {
        return cturgence_telephone3;
    }

    /**
     * @param cturgence_telephone3 the cturgence_telephone3 to set
     */
    public void setCturgence_telephone3(String cturgence_telephone3) {
        this.cturgence_telephone3 = cturgence_telephone3;
    }

    /**
     * @return the dateembauche
     */
    public Date getDateembauche() {
        return dateembauche;
    }

    /**
     * @param dateembauche the dateembauche to set
     */
    public void setDateembauche(Date dateembauche) {
        this.dateembauche = dateembauche;
    }

    /**
     * @return the datesaisie
     */
    public Date getDatesaisie() {
        return datesaisie;
    }

    /**
     * @param datesaisie the datesaisie to set
     */
    public void setDatesaisie(Date datesaisie) {
        this.datesaisie = datesaisie;
    }

    /**
     * @return the permis_conduire
     */
    public String getPermis_conduire() {
        return permis_conduire;
    }

    /**
     * @param permis_conduire the permis_conduire to set
     */
    public void setPermis_conduire(String permis_conduire) {
        this.permis_conduire = permis_conduire;
    }

    public String getBanque_code() {
        return banque_code;
    }

    public void setBanque_code(String banque_code) {
        this.banque_code = banque_code;
    }

    public int getVehiculee() {
        return vehiculee;
    }

    public void setVehiculee(int vehiculee) {
        this.vehiculee = vehiculee;
    }

    public Date getDate_dernierpromo() {
        return date_dernierpromo;
    }

    public void setDate_dernierpromo(Date date_dernierpromo) {
        this.date_dernierpromo = date_dernierpromo;
    }

    public String getId_pers() {
        return id_pers;
    }

    public void setId_pers(String id_pers) {
        this.id_pers = id_pers;
    }

    public String getChemin_permis() {
        return chemin_permis;
    }

    public void setChemin_permis(String chemin_permis) {
        this.chemin_permis = chemin_permis;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getDroit_hs() {
        return droit_hs;
    }

    public void setDroit_hs(String droit_hs) {
        this.droit_hs = droit_hs;
    }

    public String getNumero_cnaps() {
        return numero_cnaps;
    }

    public void setNumero_cnaps(String numero_cnaps) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.numero_cnaps = numero_cnaps;
            return;
        }
        if (String.valueOf(numero_cnaps) == null || String.valueOf(numero_cnaps).compareToIgnoreCase(" ") == 0) {
            throw new Exception("CNAPS Obligatoire");
        }
        this.numero_cnaps = numero_cnaps;
    }

    public String getNumero_ostie() {
        return numero_ostie;
    }

    public void setNumero_ostie(String numero_ostie) {
        this.numero_ostie = numero_ostie;
    }

    public int getTemporaire() {
        return temporaire;
    }

    public void setTemporaire(int temporaire) {
        this.temporaire = temporaire;
    }

    public int getNbenfant() {
        return nbenfant;
    }

    public void setNbenfant(int nbenfant) {
        this.nbenfant = nbenfant;
    }

    public double getDuree() {
        return duree;
    }

    public void setDuree(double duree) {
        this.duree = duree;
    }


    public EmployeComplet[] getEmployeCompletOneMonth() throws Exception{
        EmployeComplet[] employeComplet = null;
        Date onemonth = Date.valueOf(LocalDate.now().plusMonths(1));
        System.out.println("onemonth: " + onemonth);
        employeComplet = (EmployeComplet[]) CGenUtil.rechercher(new EmployeComplet(), null, null, null, " AND dateFinPeriodeEssai = TO_DATE('" + onemonth + "', 'YYYY-MM-DD')");
        return employeComplet;
    }

    public EmployeComplet[] getEmployeComplet2Weeks() throws Exception{
        EmployeComplet[] employeComplet = null;
        Date twoweeks = Date.valueOf(LocalDate.now().plusWeeks(2));
        employeComplet = (EmployeComplet[]) CGenUtil.rechercher(new EmployeComplet(), null, null, null, " AND dateFinPeriodeEssai = TO_DATE('" + twoweeks + "', 'YYYY-MM-DD')");
//        employeComplet = (EmployeComplet[]) CGenUtil.rechercher(new EmployeComplet(), null, null, null, " AND dateFinPeriodeEssai is not null");
        return employeComplet;
    }

    public String[] messageOneMonth() throws Exception{
        String[] message = null;

        EmployeComplet[] emp = getEmployeCompletOneMonth();
        if (emp != null && emp.length > 0) {
            message = new String[emp.length];
            for (int i = 0; i < emp.length; i++) {
                message[i] = "Le contract de "+ emp[i].getNom() + " " + emp[i].getPrenom() + " sera terminer dans un mois";
            }
        }
        return message;
    }

    public String[] message2Weeks() throws Exception{
        String[] message = null;
        EmployeComplet[] emp = getEmployeComplet2Weeks();
        if (emp != null && emp.length > 0) {
            message = new String[emp.length];
            for (int i = 0; i < emp.length; i++) {
                message[i] =  "Fin du periode d'essai de "+ emp[i].getNom() + " " + emp[i].getPrenom() + " dans 2 semaines";
            }
        }
        return message;
    }

    public void message() throws Exception{
        String[] a = messageOneMonth();
        String[] b = message2Weeks();
        if (a != null) {
            for (String mois : a){
                EmployeComplet temp = new EmployeComplet();
                temp.setMessageNotif(mois);
                temp.setNotifAWhere(" and idrole in('dg','vente')");
                temp.creerNotification("null", null);
                System.out.println(mois);
            }
        }
        if (b != null) {
            for (String week : b){
                EmployeComplet temp = new EmployeComplet();
                temp.setMessageNotif(week);
                temp.setNotifAWhere(" and idrole in('dg','vente')");
                temp.creerNotification("null", null);
                System.out.println(week);
            }
        }
    }


    public File genererCodeBarre(Connection c, String u) throws Exception {
        if(c==null){
            c = new UtilDB().GetConn();
        }
        CodeBarre bean = new CodeBarre();
        bean.construirePK(c);
        bean.setIdIng(this.getId());
        bean.setImage("codebarre/ing/" + this.getId() + ".png");
        String codebarre = "CB"+this.getId();
        bean.insertToTable(c);

        return genererCodeBarreWithName(bean.getId(), buildChemin(codebarre), codebarre, u);
    }

    private File genererCodeBarreWithName(String id, String chemin, String nomPersonne, String u) throws Exception {
        File fichier = new File(chemin);

        File parentDir = fichier.getParentFile();
        if (parentDir != null && !parentDir.exists() && !parentDir.mkdirs()) {
            parentDir = new File(System.getProperty("java.io.tmpdir"), "ing/personnel");
            parentDir.mkdirs();
            fichier = new File(parentDir, fichier.getName());
            System.out.println("Fichier redirige vers : " + fichier.getAbsolutePath());
        }

        if (fichier.exists()) {
            System.out.println("ℹ Code-barre déjà généré : " + fichier.getAbsolutePath());
            return fichier;
        }

        CODE128_BEAN.setFontSize(0);

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        BitmapCanvasProvider canvas = new BitmapCanvasProvider(
                baos, "image/png", DPI, BufferedImage.TYPE_BYTE_BINARY, false, 0);
        CODE128_BEAN.generateBarcode(canvas, id);
        canvas.finish();

        BufferedImage barcodeImage = ImageIO.read(new ByteArrayInputStream(baos.toByteArray()));

        int extraHeight = 30;
        BufferedImage combined = new BufferedImage(
                barcodeImage.getWidth(), barcodeImage.getHeight() + extraHeight,
                BufferedImage.TYPE_INT_RGB);

        Graphics2D g = combined.createGraphics();

        g.setColor(Color.WHITE);
        g.fillRect(0, 0, combined.getWidth(), combined.getHeight());

        g.setColor(Color.BLACK);
        g.setFont(new Font("Arial", Font.BOLD, 14));

        FontMetrics fm = g.getFontMetrics();
        int textWidth = fm.stringWidth(nomPersonne);
        int x = (combined.getWidth() - textWidth) / 2;
        int y = fm.getAscent() + 5;
        g.drawString(nomPersonne, x, y);

        g.drawImage(barcodeImage, 0, extraHeight, null);

        g.dispose();

        ImageIO.write(combined, "png", fichier);

        return fichier;
    }


    private String buildChemin(String id) {
        return PATH_DIR + "/async/codebarre/ing/" + id + ".png";
    }

    public String getCantineLib() {
        return cantineLib;
    }

    public void setCantineLib(String cantineLib) {
        this.cantineLib = cantineLib;
    }
}
