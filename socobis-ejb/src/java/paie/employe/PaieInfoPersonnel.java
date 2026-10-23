package paie.employe;

import bean.*;
import configuration.Configuration;
import hs.DemandeHsLib;
import mg.cnaps.paie.PaiePersonnelElementpaie;
import paie.CategorieQualification;
import paie.avancement.PaieAvancement;
import paie.edition.Paie_edition;
import paie.edition.PaieEditionmoisannee;
import paie.generique.DetFormu;
import paie.generique.UtilitaireFormule;
import paie.log.LogPersonnel;
import paie.pointage.HeureTravailMensuelle;
import utilitaire.ConstanteEtatPaie;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.time.YearMonth;
import java.util.*;

import paie.conge.MouvementAbsence;
import utilitaire.UtilDB;

public class PaieInfoPersonnel extends ClassEtat implements Comparator<PaieInfoPersEltPaieComplet> {

    private String id, matricule, lieu_naissance_commune, lieu_delivrance_cin, situation_matrimonial, initiale;
    private Date datesaisie;
    private String cturgence_nom_prenom, cturgence_telephone1, cturgence_telephone2, cturgence_telephone3;
    private String idconjoint, code_agence_banque, banque_numero_compte, banque_compte_cle;
    private Date dateembauche, datepromotion;
    private String idfonction, idcategorie, ctg, mode_paiement, classee, matricule_patron, statut, droit_hs, numero_cnaps;
    private int vehiculee, echelon;
    private String numero_ostie;
    private int temporaire;
    private String n_embauche;
    private Date date_depart;
    private String n_depart;
    private double heurejournalier, heurehebdomadaire, heuremensuel;
    private int indice_ct, indice_fonctionnel, indicegrade, nbenfant;
    private int indesirable;
    private String telephone, mail, region, adresse_ligne1, adresse_ligne2, code_postal, code_banque;
    private String idcategorie_paie, idqualification;
    private String formation, discipline, anneeExperience;
    private int personnel_etat;
    private int nb_prorata;
    private double salaire_base;
    private double cnaps12;
    private double cnaps13;
    private double cnaps14;
    private int mois_edition;
    private int annee_edition;

    private String idpersonnel;
    private String libcqetat;
    private double montant;
    private String categorie_paielib;
    private String categorie_qualificationlib;
    private Date date_debut;
    private Date date_fin;
    private String nom, prenom, etatval;
    private String avenant;

    private Date debutcontrat;
    private Date fincontrat;

    private String typeContrat;

    private double heurenormal, heuresupnormal, heuresupferie, heuresupweekend, heuresupnuit, absence;

    private double nbjpreavis;

    private int anciennete;
    private int stc=0;
    private double imposable12;

    private double nbconge;
    private int nbSemaine;
    private double totalPointageTemp;
    private String idPeriodePaie;

    private int nbAnneeService;

    private String idBanque, idAgence;

    private String numeroSecuriteSociale;
    private String numeroCarteSejour;
    private Date dateExpiration;
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
    private String idDepartement;

    private String typeCalcul;
    private double salaireBase;
    private String typeHoraire;
    private String modaliteTravail;

    private double hs30imp;
    private double hs30nonimp;
    private double hs50imp;
    private double hs50nonimp;

    private String idSociete;
    private int estRattacheCnaps;
    private int estRattacheOstie;
    private int transport;
    private String cantine;

    private String idSection;
    private String idBu;
    private double absence_conge;
    private double absence_heure;
    private double absence_jour;
    private double heure_totale_nuit;
    private double jour_total_conge;
    private double work_day;
    private double heure_absence;
    private String sous_categorie_paie;
    private double over60;
    private double base_allocation;

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

    public String getIdSociete() {
        return idSociete;
    }

    public void setIdSociete(String idSociete) {
        this.idSociete = idSociete;
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

    public String getIdDepartement() {
        return idDepartement;
    }

    public void setIdDepartement(String idDepartement) {
        this.idDepartement = idDepartement;
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

    public String getIdBanque() {
        return idBanque;
    }

    public void setIdBanque(String idBanque) {
        this.idBanque = idBanque;
    }

    public String getIdAgence() {
        return idAgence;
    }

    public void setIdAgence(String idAgence) {
        this.idAgence = idAgence;
    }

    public int getNbAnneeService() {
        return nbAnneeService;
    }

    public void setNbAnneeService(int nbAnneeService) {
        this.nbAnneeService = nbAnneeService;
    }

    public double getNbconge() {
        return nbconge;
    }

    public void setNbconge(double nbconge) {
        this.nbconge = nbconge;
    }

    public int getStc() {
        return stc;
    }

    public void setStc(int stc) {
        this.stc = stc;
    }

    public double getImposable12() {
        return imposable12;
    }

    public void setImposable12(double imposable12) {
        this.imposable12 = imposable12;
    }

    public int getAnciennete() {
        return anciennete;
    }

    public void setAnciennete(int anciennete) {
        this.anciennete = anciennete;
    }

    public double getNbjpreavis() {
        return nbjpreavis;
    }

    public void setNbjpreavis(double nbjpreavis) {
        this.nbjpreavis = nbjpreavis;
    }

    public double getHeurenormal() {
        return heurenormal;
    }

    public void setHeurenormal(double heurenormal) {
        this.heurenormal = heurenormal;
    }

    public double getHeuresupnormal() {
        return heuresupnormal;
    }

    public void setHeuresupnormal(double heuresupnormal) {
        this.heuresupnormal = heuresupnormal;
    }

    public double getHeuresupferie() {
        return heuresupferie;
    }

    public void setHeuresupferie(double heuresupferie) {
        this.heuresupferie = heuresupferie;
    }

    public double getHeuresupweekend() {
        return heuresupweekend;
    }

    public void setHeuresupweekend(double heuresupweekend) {
        this.heuresupweekend = heuresupweekend;
    }

    public double getHeuresupnuit() {
        return heuresupnuit;
    }

    public void setHeuresupnuit(double heuresupnuit) {
        this.heuresupnuit = heuresupnuit;
    }

    public double getAbsence() {
        return absence;
    }

    public void setAbsence(double absence) {
        this.absence = absence;
    }

    public double getSalaire_base() {
        return salaire_base;
    }

    public String getTypeContrat() {
        return typeContrat;
    }

    public void setTypeContrat(String typeContrat) {
        this.typeContrat = typeContrat;
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

    public String getAvenant() {
        return avenant;
    }

    public void setAvenant(String avenant) {
        this.avenant = avenant;
    }

    public String getIdpersonnel() {
        return idpersonnel;
    }

    public void setIdpersonnel(String idpersonnel) {
        this.idpersonnel = idpersonnel;
    }

    public String getEtatval() {
        return etatval;
    }

    public void setEtatval(String etatval) {
        this.etatval = etatval;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getLibcqetat() {
        return libcqetat;
    }

    public void setLibcqetat(String libcqetat) {
        this.libcqetat = libcqetat;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public String getCategorie_paielib() {
        return categorie_paielib;
    }

    public void setCategorie_paielib(String categorie_paielib) {
        this.categorie_paielib = categorie_paielib;
    }

    public String getCategorie_qualificationlib() {
        return categorie_qualificationlib;
    }

    public void setCategorie_qualificationlib(String categorie_qualificationlib) {
        this.categorie_qualificationlib = categorie_qualificationlib;
    }

    public Date getDate_debut() {
        return date_debut;
    }

    public void setDate_debut(Date date_debut) {
        this.date_debut = date_debut;
    }

    public Date getDate_fin() {
        return date_fin;
    }

    public void setDate_fin(Date date_fin) {
        this.date_fin = date_fin;
    }

    public int getMois_edition() {
        return mois_edition;
    }

    public void setMois_edition(int mois_edition) {
        this.mois_edition = mois_edition;
    }

    public int getAnnee_edition() {
        return annee_edition;
    }

    public void setAnnee_edition(int annee_edition) {
        this.annee_edition = annee_edition;
    }

    public double getCnaps12() {
        return cnaps12;
    }

    public void setCnaps12(double cnaps12) {
        this.cnaps12 = cnaps12;
    }

    public double getCnaps13() {
        return cnaps13;
    }

    public void setCnaps13(double cnaps13) {
        this.cnaps13 = cnaps13;
    }

    public double getCnaps14() {
        return cnaps14;
    }

    public void setCnaps14(double cnaps14) {
        this.cnaps14 = cnaps14;
    }

    public double getSalaire_Base() {
        return this.salaire_base;
    }

    public void setSalaire_base(double salaire_base) {
        this.salaire_base = salaire_base;
    }

    public int getNb_prorata() {
        return this.nb_prorata;
    }

    public void setNb_prorata(int nb_prorata) {
        this.nb_prorata = nb_prorata;
    }

    private int mois, annee;

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

    public int getPersonnel_etat() {
        return personnel_etat;
    }

    public void setPersonnel_etat(int personnel_etat) {
        this.personnel_etat = personnel_etat;
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

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getMail() {
        return mail;
    }

    public void setMail(String mail) {
        this.mail = mail;
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

    public String getCode_banque() {
        return code_banque;
    }

    public void setCode_banque(String code_banque) {
        this.code_banque = code_banque;
    }

    public void setHeuremensuel(double heuremensuel) {
        this.heuremensuel = heuremensuel;
    }

    public PaieInfoPersonnel() {
        super.setNomTable("PAIE_INFO_PERSONNEL");
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        MouvementAbsence mouvementAbsence = new MouvementAbsence();
        mouvementAbsence.setIdSource(utils.ConstantePaie.id_typeabsenceconge);
        mouvementAbsence.setIdPersonnel(this.getId());
        mouvementAbsence.setAnnee(Integer.parseInt(Utilitaire.getAnneeEnCours()));
        mouvementAbsence.setMois(Utilitaire.getMoisEnCours());
        mouvementAbsence.setRemarque("Mouvement absence initial ");
        mouvementAbsence.setPlus(0);
        mouvementAbsence.setMoins(0);
        mouvementAbsence.createObject(u, c);

        LogPersonnel logperso = (LogPersonnel) new LogPersonnel().getById(this.getId(), null, c);

        if (logperso == null)
        {
            throw new Exception("Erreur : Employe introuvable");
        }

        PaieAvancement paie = new PaieAvancement();
        paie.setId_logpers(this.getId());
        paie.setDirection(logperso.getDirection());
        paie.setService(logperso.getService());
        paie.setIdcategorie(this.getIdcategorie());
        paie.setIdfonction(this.getIdfonction());
        paie.setDatedecision(utilitaire.Utilitaire.dateDuJourSql());
        paie.setEtat(11);
        paie.createObject(u, c);

        return super.validerObject(u, c);
    }

    @Override
    public int updateObject(String u, Connection c) throws Exception {
        PaieInfoPersonnel base = new PaieInfoPersonnel();
        base.setId(this.getId());
        PaieInfoPersonnel[] paie = (PaieInfoPersonnel[]) CGenUtil.rechercher(base,null,null,c,"");
        if(paie!=null && paie.length>0){
            PaieInfoPersonnel toUpdate = paie[0];
            if(this.getMode_paiement()!=null && !this.getMode_paiement().trim().isEmpty()){
                toUpdate.setMode_paiement(this.getMode_paiement());
                toUpdate.setCode_banque(this.getCode_banque());
                toUpdate.setCode_agence_banque(this.getCode_agence_banque());
                toUpdate.setBanque_numero_compte(this.getBanque_numero_compte());
                toUpdate.setBanque_compte_cle(this.getBanque_compte_cle());
            }
            if(this.getUnite()!=null && !this.getUnite().trim().isEmpty()){
                toUpdate.setUnite(this.getUnite());
            }
            return toUpdate.updateToTableWithHisto(u,c);
        }
        else {
            throw new Exception("Aucune information de paie trouve pour l'id "+this.getId());
        }
    }

    public String getClassee() {
        return classee;
    }

    public void setClassee(String classee) {
        this.classee = classee;
    }

    public int getIndicegrade() {
        return indicegrade;
    }

    public void setIndicegrade(int indicegrade) {
        this.indicegrade = indicegrade;
    }

    public void setIndicegrade(String indicegrade) {
        this.indicegrade = Utilitaire.stringToInt(indicegrade);
    }

    public int getIndice_fonctionnel() {
        return indice_fonctionnel;
    }

    public void setIndice_fonctionnel(String indicefonctionnel) {
        this.indice_fonctionnel = Utilitaire.stringToInt(indicefonctionnel);
    }

    public void setIndice_fonctionnel(int indicefonctionnel) {
        this.indice_fonctionnel = indicefonctionnel;
    }

    public String getMatricule_patron() {
        return matricule_patron;
    }

    public void setMatricule_patron(String matricule_patron) {
        this.matricule_patron = matricule_patron;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public String getDroit_hs() {
        return droit_hs;
    }

    public void setDroit_hs(String droit_hs) {
        this.droit_hs = droit_hs;
    }

    public String getCtg() {
        return ctg;
    }

    public void setCtg(String ctg) {
        this.ctg = ctg;
    }

    @Override
    public boolean getEstIndexable() {
        return true;
    }

    public PaieInfoPersonnel(String id, String matricule, String idfonction) {
        super.setNomTable("PAIE_INFO_PERSONNEL");
        this.setId(id);
        this.setMatricule(matricule);
        this.setIdfonction(idfonction);
    }

    public PaieInfoPersonnel(String matricule, String lieu_naissance_commune, String lieu_delivrance_cin, String situation_matrimonial, String initiale, Date datesaisie, String cturgence_nom_prenom, String cturgence_telephone1, String cturgence_telephone2, String cturgence_telephone3, String idconjoint, String code_agence_banque, String banque_numero_compte, String banque_compte_cle, Date dateembauche, String idfonction, String idcategorie, String mode_paiement, String classee, String indicegrade, String indicefonctionnel, String matricule_patron, String statut, String droit_hs) throws Exception {
        this.setMatricule(matricule);
        this.setLieu_naissance_commune(lieu_naissance_commune);
        this.setLieu_delivrance_cin(lieu_delivrance_cin);
        this.setSituation_matrimonial(situation_matrimonial);
        this.setInitiale(initiale);
        this.setDatesaisie(datesaisie);
        this.setCturgence_nom_prenom(cturgence_nom_prenom);
        this.setCturgence_telephone1(cturgence_telephone1);
        this.setCturgence_telephone2(cturgence_telephone2);
        this.setCturgence_telephone3(cturgence_telephone3);
        this.setIdconjoint(idconjoint);
        this.setCode_agence_banque(code_agence_banque);
        this.setBanque_numero_compte(banque_numero_compte);
        this.setBanque_compte_cle(banque_compte_cle);
        this.setDateembauche(dateembauche);
        this.setIdfonction(idfonction);
        this.setIdcategorie(idcategorie);
        this.setMode_paiement(mode_paiement);
        this.setClassee(classee);
        this.setIndicegrade(indicegrade);
        this.setIndice_fonctionnel(indicefonctionnel);
        this.setMatricule_patron(matricule_patron);
        this.setStatut(statut);
        this.setDroit_hs(droit_hs);
        super.setNomTable("PAIE_INFO_PERSONNEL");
    }

    public PaieInfoPersonnel(String id, String matricule, String lieu_naissance_commune, String lieu_delivrance_cin, String situation_matrimonial, String initiale, Date datesaisie, String cturgence_nom_prenom, String cturgence_telephone1, String cturgence_telephone2, String cturgence_telephone3, String idconjoint, String code_agence_banque, String banque_numero_compte, String banque_compte_cle, Date dateembauche, String idfonction, String idcategorie, String mode_paiement, String classee, String indicegrade, String indicefonctionnel, String matricule_patron, String statut, String droit_hs) throws Exception {
        this.setId(id);
        this.setMatricule(matricule);
        this.setLieu_naissance_commune(lieu_naissance_commune);
        this.setLieu_delivrance_cin(lieu_delivrance_cin);
        this.setSituation_matrimonial(situation_matrimonial);
        this.setInitiale(initiale);
        this.setDatesaisie(datesaisie);
        this.setCturgence_nom_prenom(cturgence_nom_prenom);
        this.setCturgence_telephone1(cturgence_telephone1);
        this.setCturgence_telephone2(cturgence_telephone2);
        this.setCturgence_telephone3(cturgence_telephone3);
        this.setIdconjoint(idconjoint);
        this.setCode_agence_banque(code_agence_banque);
        this.setBanque_numero_compte(banque_numero_compte);
        this.setBanque_compte_cle(banque_compte_cle);
        this.setDateembauche(dateembauche);
        this.setIdfonction(idfonction);
        this.setIdcategorie(idcategorie);
        this.setMode_paiement(mode_paiement);
        this.setClassee(classee);
        this.setIndicegrade(indicegrade);
        this.setIndice_fonctionnel(indicefonctionnel);
        this.setMatricule_patron(matricule_patron);
        this.setStatut(statut);
        this.setDroit_hs(droit_hs);
        super.setNomTable("PAIE_INFO_PERSONNEL");
    }

    public PaieInfoPersonnel(String id, String matricule, String lieu_naissance_commune, String lieu_delivrance_cin, String situation_matrimonial, String initiale, Date datesaisie, String cturgence_nom_prenom, String cturgence_telephone1, String cturgence_telephone2, String cturgence_telephone3, String idconjoint, String code_agence_banque, String banque_numero_compte, String banque_compte_cle, Date dateembauche, String idfonction, String idcategorie, String mode_paiement, String classee, String indicegrade, String indicefonctionnel, String matricule_patron, String statut, String droit_hs, Date debutcontrat, Date fincontrat) throws Exception {
        this.setId(id);
        this.setMatricule(matricule);
        this.setLieu_naissance_commune(lieu_naissance_commune);
        this.setLieu_delivrance_cin(lieu_delivrance_cin);
        this.setSituation_matrimonial(situation_matrimonial);
        this.setInitiale(initiale);
        this.setDatesaisie(datesaisie);
        this.setCturgence_nom_prenom(cturgence_nom_prenom);
        this.setCturgence_telephone1(cturgence_telephone1);
        this.setCturgence_telephone2(cturgence_telephone2);
        this.setCturgence_telephone3(cturgence_telephone3);
        this.setIdconjoint(idconjoint);
        this.setCode_agence_banque(code_agence_banque);
        this.setBanque_numero_compte(banque_numero_compte);
        this.setBanque_compte_cle(banque_compte_cle);
        this.setDateembauche(dateembauche);
        this.setIdfonction(idfonction);
        this.setIdcategorie(idcategorie);
        this.setMode_paiement(mode_paiement);
        this.setClassee(classee);
        this.setIndicegrade(indicegrade);
        this.setIndice_fonctionnel(indicefonctionnel);
        this.setMatricule_patron(matricule_patron);
        this.setStatut(statut);
        this.setDroit_hs(droit_hs);
        this.setDebutcontrat(debutcontrat);
        this.setFincontrat(fincontrat);
        super.setNomTable("PAIE_INFO_PERSONNEL");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("RNAT", "getSeqPaie_info_personnel");
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

    public void setId(String id) {
        this.id = id;
    }

    public String getInitiale() {
        return initiale;
    }

    public void setInitiale(String initiale) {
        this.initiale = initiale;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public void setLieu_naissance_commune(String lieu_naissance_commune) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.lieu_naissance_commune = lieu_naissance_commune;
            return;
        }
//        if (lieu_naissance_commune == null || lieu_naissance_commune.compareToIgnoreCase("") == 0) {
//            throw new Exception("Lieu de naissance invalide car vide");
//        }
        this.lieu_naissance_commune = lieu_naissance_commune;
    }

    public void setLieu_delivrance_cin(String lieu_delivrance_cin) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.lieu_delivrance_cin = lieu_delivrance_cin;
            return;
        }
//        if (lieu_delivrance_cin == null || lieu_delivrance_cin.compareToIgnoreCase(" ") == 0) {
//            throw new Exception("Lieu de delivrance CIN invalide car vide");
//        }
        this.code_agence_banque = code_agence_banque;
        this.lieu_delivrance_cin = lieu_delivrance_cin;
    }

    public void setSituation_matrimonial(String situation_matrimonial) throws Exception {

        this.situation_matrimonial = situation_matrimonial;
    }

    public void setInitial(String initial) {
        this.initiale = initial;
    }

    /*public void setDatesaisie(Date datesaisie) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.datesaisie = datesaisie;
            return;
        }
        if (datesaisie == null) {
            throw new Exception("Date de saisie invalide car vide");
        }
        int diffJourdate = Utilitaire.diffJourDaty(datesaisie, Utilitaire.dateDuJourSql());
        if (this.getMode().compareToIgnoreCase("modif") == 0 && diffJourdate > 0) {
            throw new Exception("Date de saisie supperieur a la date du jour");
        }
        this.datesaisie = datesaisie;
    }*/
    public void setCturgence_nom_prenom(String cturgence_nom_prenom) {
        this.cturgence_nom_prenom = cturgence_nom_prenom;
    }

    public void setCturgence_telephone1(String cturgence_telephone1) {
        this.cturgence_telephone1 = cturgence_telephone1;
    }

    public void setCturgence_telephone2(String cturgence_telephone2) {
        this.cturgence_telephone2 = cturgence_telephone2;
    }

    public void setCturgence_telephone3(String cturgence_telephone3) {
        this.cturgence_telephone3 = cturgence_telephone3;
    }

    public void setIdconjoint(String idconjoint) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.idconjoint = idconjoint;
            return;
        }
//        if(situation_matrimonial.compareTo("1")==0 && (idconjoint!=null || idconjoint.compareTo("")!=0)){
//            throw new Exception ("Erreur conjoint : situation matrimoniale - C libataire");
//
//        }
//        if(situation_matrimonial.compareTo("4")==0 && (idconjoint!=null || idconjoint.compareTo("")!=0)){
//            throw new Exception ("Erreur conjoint : situation matrimoniale - Divorc (e)");
//
//        }
//        if(situation_matrimonial.compareTo("3")==0 && (idconjoint!=null || idconjoint.compareTo("")!=0)){
//            throw new Exception ("Erreur conjoint : situation matrimoniale - Veuve/veuf");
//
//        }
        this.idconjoint = idconjoint;
    }

    public void setCode_agence_banque(String code_agence_banque) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.code_agence_banque = code_agence_banque;
            return;
        }
        this.code_agence_banque = code_agence_banque;
    }

    public void setBanque_numero_compte(String banque_numero_compte) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.banque_numero_compte = banque_numero_compte;
            return;
        }
        this.banque_numero_compte = banque_numero_compte;
    }

    public void setBanque_compte_cle(String banque_compte_cle) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.banque_compte_cle = banque_compte_cle;
            return;
        }
        this.banque_compte_cle = banque_compte_cle;
    }

    public void setDateembauche(Date dateembauche) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.dateembauche = dateembauche;
            return;
        }
//        if (dateembauche == null) {
//            throw new Exception("Date embauche invalide car vide");
//        }
//        int diffJourdate = Utilitaire.diffJourDaty(dateembauche, Utilitaire.dateDuJourSql());
//        if (this.getMode().compareToIgnoreCase("modif") == 0 && diffJourdate > 0) {
//            throw new Exception("Date embauche supperieur a la date du jour");
//        }
        this.dateembauche = dateembauche;
    }

    public void setIdfonction(String idfonction) {
        this.idfonction = idfonction;
    }

    public void setIdcategorie(String idcategorie) {
        this.idcategorie = idcategorie;
    }

    public String getId() {
        return id;
    }

    public String getMatricule() {
        return matricule;
    }

    public String getLieu_naissance_commune() {
        return lieu_naissance_commune;
    }

    public String getLieu_delivrance_cin() {
        return lieu_delivrance_cin;
    }

    public String getSituation_matrimonial() {
        return situation_matrimonial;
    }

    public String getInitial() {
        return initiale;
    }

    public Date getDatesaisie() {
        return datesaisie;
    }

    public String getCturgence_nom_prenom() {
        return cturgence_nom_prenom;
    }

    public String getCturgence_telephone1() {
        return cturgence_telephone1;
    }

    public String getCturgence_telephone2() {
        return cturgence_telephone2;
    }

    public String getCturgence_telephone3() {
        return cturgence_telephone3;
    }

    public String getIdconjoint() {
        return idconjoint;
    }

    public String getCode_agence_banque() {
        return code_agence_banque;
    }

    public String getBanque_numero_compte() {
        return banque_numero_compte;
    }

    public String getBanque_compte_cle() {
        return banque_compte_cle;
    }

    public Date getDateembauche() {
        return dateembauche;
    }

    public String getIdfonction() {
        return idfonction;
    }

    public String getIdcategorie() {
        return idcategorie;
    }

    public String getMode_paiement() {
        return mode_paiement;
    }

    public void setMode_paiement(String mode_paiement) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.mode_paiement = mode_paiement;
            return;
        }
        if (mode_paiement == null || mode_paiement.compareToIgnoreCase(" ") == 0) {
            throw new Exception("Mode de paiement invalide car vide");
        }
        this.mode_paiement = mode_paiement;
    }

    public int getIndice_ct() {
        return indice_ct;
    }

    public void setIndice_ct(String indice_ct) {
        this.indice_ct = Utilitaire.stringToInt(indice_ct);
    }

    public void setIndice_ct(int indice_ct) {
        this.indice_ct = indice_ct;
    }

    public int getVehiculee() {
        return vehiculee;
    }

    public void setVehiculee(int vehiculee) {
        this.vehiculee = vehiculee;
    }

    public int getEchelon() {
        return echelon;
    }

    public void setEchelon(int echelon) {
        this.echelon = echelon;
    }

    public Date getDatepromotion() {
        return datepromotion;
    }

    public void setDatepromotion(Date datepromotion) {
        this.datepromotion = datepromotion;
    }

    public String getNumero_cnaps() {
        return numero_cnaps;
    }

    public void setNumero_cnaps(String numero_cnaps) {
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

    public String getN_embauche() {
        return n_embauche;
    }

    public void setN_embauche(String n_embauche) {
        this.n_embauche = n_embauche;
    }

    public Date getDate_depart() {
        return date_depart;
    }

    public void setDate_depart(Date date_depart) {
        this.date_depart = date_depart;
    }

    public String getN_depart() {
        return n_depart;
    }

    public void setN_depart(String n_depart) {
        this.n_depart = n_depart;
    }

    public int getNbenfant() {
        return nbenfant;
    }

    public void setNbenfant(int nbenfant) {
        this.nbenfant = nbenfant;
    }

    public int getIndesirable() {
        return indesirable;
    }

    public void setIndesirable(int indesirable) {
        this.indesirable = indesirable;
    }

    /* Formule */
    private double salaire_de_base;
    static Configuration[] listeConfig;
    static DetFormu[] listeFormule;
    static PaieRubrique[] listRub;

    ArrayList<PaieInfoPersEltPaieComplet> listeElt = new ArrayList<PaieInfoPersEltPaieComplet>();
    ArrayList<PaieInfoPersEltPaieComplet> listeEltAInserer = new ArrayList<PaieInfoPersEltPaieComplet>();

    public double getSalaire_de_base() {
        return salaire_de_base;
    }

    public void setSalaire_de_base(double salaire_de_base) {
        this.salaire_de_base = salaire_de_base;
    }

    public static Configuration[] getListeConfig() {
        return listeConfig;
    }

    public static void setListeConfig(Configuration[] listeConfig) {
        PaieInfoPersonnel.listeConfig = listeConfig;
    }

    public static DetFormu[] getListeFormule() {
        return listeFormule;
    }

    public static void setListeFormule(DetFormu[] listeFormule) {
        PaieInfoPersonnel.listeFormule = listeFormule;
    }

    public static PaieRubrique[] getListRub() {
        return listRub;
    }

    public static void setListRub(PaieRubrique[] listRub) {
        PaieInfoPersonnel.listRub = listRub;
    }

    public ArrayList<PaieInfoPersEltPaieComplet> getListeElt() {
        return listeElt;
    }

    public void setListeElt(ArrayList<PaieInfoPersEltPaieComplet> listeElt) {
        this.listeElt = listeElt;
    }

    public ArrayList<PaieInfoPersEltPaieComplet> getListeEltAInserer() {
        return listeEltAInserer;
    }

    public void setListeEltAInserer(ArrayList<PaieInfoPersEltPaieComplet> listeEltAInserer) {
        this.listeEltAInserer = listeEltAInserer;
    }

    public void afficher() {
        for (PaieInfoPersEltPaieComplet elmt : this.getListeEltAInserer()) {
            elmt.afficher();
        }
    }

    public void calculProrata(int mois, int annee) {
        setNb_prorata(Utilitaire.getNombreJourMois(String.valueOf(mois), String.valueOf(annee)));
        if (mois == Utilitaire.getMois(getDateembauche()) && annee == Utilitaire.getAnnee(getDateembauche())) {
            setNb_prorata(YearMonth.of(annee, mois).atEndOfMonth().getDayOfMonth() - (getDateembauche().getDate() - 1));
        }
        if (getDate_depart() != null) {
            if (mois == Utilitaire.getMois(getDate_depart()) && annee == Utilitaire.getAnnee(getDate_depart())) {
                setNb_prorata(getDate_depart().getDate());
            }
        }
    }

    public double getTauxHoraire() throws Exception {
        PaieInfoPersonnel tmp = new PaieInfoPersonnel();
        tmp.setNomTable("PAIE_INFO_PERSONNEL_SB");
        tmp.setId(this.getId());
        PaieInfoPersonnel[] details = (PaieInfoPersonnel[]) CGenUtil.rechercher(tmp, null, null, "");
//        System.out.println(" details " + details.length + details[0].getId() + " montant " + details[0].getMontant());
        double tauxHoraire = 0;
        if(details!=null && details.length>0){
//            System.out.println("1 " + details[0].getSalaire_Base() + " 2 " + details[0].getSalaire_base() + " 3 " + details[0].getSalaire_de_base());
            tauxHoraire = details[0].getMontant() / 173.33;
            return tauxHoraire;
        }
        return tauxHoraire;
    }

    public void calculSalaire(Connection c, String idpersonnel, int mois, int annee, int nbSemaine) throws Exception {

        Date datedebut = Utilitaire.stringDate("01/"+Utilitaire.completerInt(2, mois)+"/"+annee);
        Date datefin = Utilitaire.stringDate(Utilitaire.getLastJourInMonth(datedebut)+"/"+Utilitaire.completerInt(2, mois)+"/"+annee);

        paie.elementpaie.PaiePersonnelElementpaie paie = new paie.elementpaie.PaiePersonnelElementpaie();
        paie.setCode_rubrique(ConstantePaie.rub_absence_conge);
        paie.setIdpersonnel(idpersonnel);
        String aWhere = "AND ( " +
                "date_debut <= TO_DATE('" + datefin   + "', 'YYYY/MM/DD') " +
                "AND ( " +
                "(date_fin >= TO_DATE('" + datedebut + "', 'YYYY/MM/DD') " +
                "AND date_fin <= TO_DATE('" + datefin + "', 'YYYY/MM/DD')) " +
                "OR date_fin IS NULL " +
                ") " +
                ")";
//        System.out.println(" a where +++++++++++= +" + aWhere);
        paie.elementpaie.PaiePersonnelElementpaie[] res = (paie.elementpaie.PaiePersonnelElementpaie[]) CGenUtil.rechercher(paie, null, null, c, aWhere);
        if(res != null && res.length > 0){
            double absence_conge = res[0].getGain();
//            System.out.println("absence conge +++++++ " + absence_conge);
            setAbsence_conge(absence_conge);
        }
        paie.elementpaie.PaiePersonnelElementpaie paieabseheure = new paie.elementpaie.PaiePersonnelElementpaie();
        paieabseheure.setCode_rubrique(ConstantePaie.rub_absence_heure);
        paieabseheure.setIdpersonnel(idpersonnel);

        paie.elementpaie.PaiePersonnelElementpaie[] resHeure = (paie.elementpaie.PaiePersonnelElementpaie[]) CGenUtil.rechercher(paieabseheure, null, null, c, aWhere);
        if(resHeure != null && resHeure.length > 0){
            double absence_heure = resHeure[0].getGain();
//            System.out.println("absence conge +++++++ " + absence_heure);
            setAbsence_heure(absence_heure);
        }

        paie.elementpaie.PaiePersonnelElementpaie paieabsjour = new paie.elementpaie.PaiePersonnelElementpaie();
        paieabsjour.setCode_rubrique(ConstantePaie.rub_absence_jour);
        paieabsjour.setIdpersonnel(idpersonnel);
        paie.elementpaie.PaiePersonnelElementpaie[] resJour = (paie.elementpaie.PaiePersonnelElementpaie[]) CGenUtil.rechercher(paieabsjour, null, null, c, aWhere);
        if(resJour != null && resJour.length > 0){
            double absence_jour = resJour[0].getGain();
//            System.out.println("absence conge +++++++ " + absence_jour);
            setAbsence_jour(absence_jour);
        }
//        System.out.println(" avant calcul pointeuse +++++++++++++ ");
        this.calculDonneesPointeuse(mois, annee, idpersonnel, c);

        //        Pointage[] pp = (Pointage[]) CGenUtil.rechercher(new Pointage(), null, null, c, " and idpersonnel='" + idpersonnel + "' and mois=" + mois + " and annee=" + annee + " and etat=11");
//        LogPersonnelNonValide lnv = new LogPersonnelNonValide();
//        lnv.setIdlogpers(idpersonnel);
//        LogPersonnelNonValide[] mvt = (LogPersonnelNonValide[]) CGenUtil.rechercher(lnv, null, null, "" );
//        MouvementAbsence mouv = new MouvementAbsence();
//        mouv.setIdPersonnel(idpersonnel);
//
//        System.out.println("mouv.getIdpersonnel==>"+mouv.getIdPersonnel());
//
//        if (pp.length > 0) {
//            setHeurenormal(pp[0].getHeureNormal());
//            setHeuresupnormal(pp[0].getHeureSupNormal());
//            setHeuresupferie(pp[0].getHeureSupFerie());
//            setHeuresupweekend(pp[0].getHeureSupWeekend());
//            setHeuresupnuit(pp[0].getHeureSupNuit());
//            setAbsence(pp[0].getAbsence());
//        }

//        HeureTravailMensuelle heure = new HeureTravailMensuelle();
//        heure.setId(idpersonnel);
//        heure.setMois(mois);
//        heure.setAnnee(annee);
//        HeureTravailMensuelle[] totalHeure = (HeureTravailMensuelle[]) CGenUtil.rechercher(heure, null, null, "");

//        System.out.println(" total heure ++++++ " + totalHeure.length);
//        if(totalHeure != null && totalHeure.length>0) {
//            System.out.println(" hn normale ++++ " + totalHeure[0].getTotal_heure_normale());
//            System.out.println(" hs nuit ++++ " + totalHeure[0].getTotal_heures_nuit());
//
//            setHeurenormal(totalHeure[0].getTotal_heure_normale());
//            setHeuresupnuit(totalHeure[0].getTotal_heures_nuit());
//        }
//        this.calculHsPersonne(idpersonnel, mois, annee);
//        System.out.println(" hs 30 non imppppp ++++ " +  this.getHs30nonimp());
//        setNbSemaine(nbSemaine);

//        if(mvt.length>0){
//            if(mvt[0].getIdtypedebauche().equals(utils.ConstantePaie.dep_idpreavis)) setNbjpreavis(mvt[0].getDureePreavis());
//            if(mvt[0].getIdtypedebauche().equals(utils.ConstantePaie.dep_idlicensiement)) setAnciennete(calculAnciennete(this.getDateembauche(),this.getDate_depart()));
//            if(mvt[0].getStc()>=1) {
//                setStc(mvt[0].getStc());
//                setNbconge(mouv.getSoldeCongePers());
//
//                Archive arc = new Archive();
//                arc.setIdpersonnel(idpersonnel);
//                double imposable12 = arc.getImposable_12();
//                setImposable12(imposable12);
//            }
//        }

    }

    public void calculDonneesPointeuse(int mois, int annee, String idpersonnel, Connection c) throws Exception {
        HeureTravailMensuelle hr = new HeureTravailMensuelle();
        hr.setMois(mois);
        hr.setAnnee(String.valueOf(annee));
        hr.setId(idpersonnel);
        HeureTravailMensuelle[] res = (HeureTravailMensuelle[]) CGenUtil.rechercher(hr, null, null, c, "");

        if(res != null && res.length>0) {

            double heureTotaleNuit = res[0].getTotal_heures_nuit();
            double jourTotalConge = res[0].getTotalConge();
            double workDay = res[0].getWorkDay();
            double heureAbsence = res[0].getHeureAbsence();
            double sb = this.getSalaireBaseById(c);
            double tauxJournalier = sb / 30;
            double tauxHoraire = sb / ConstantePaie.heuremois;
            double over60 = res[0].getOver60();
            this.setOver60(over60);
            this.setWork_day(workDay);
//            this.setAbsence_conge(tauxJournalier * jourTotalConge);
            this.setAbsence_heure(tauxHoraire * heureAbsence);
            this.setHeure_totale_nuit(heureTotaleNuit);
            this.setJour_total_conge(jourTotalConge);
            if(jourTotalConge > 0) {
                double salaireDeuxDerniersMois = this.getSalaireDeuxDerniersMois(mois, annee, idpersonnel, c);
                this.setBase_allocation(salaireDeuxDerniersMois);
            }
            this.setHeure_absence(heureAbsence);
        }

    }

    public double getSalaireDeuxDerniersMois(int mois, int annee, String idpersonnel, Connection c) throws Exception {
        int mois1 = mois - 1;
        int annee1 = annee;

        int mois2 = mois - 2;
        int annee2 = annee;

        if (mois1 <= 0) {
            mois1 += 12;
            annee1--;
        }

        if (mois2 <= 0) {
            mois2 += 12;
            annee2--;
        }
        Paie_edition edition = new Paie_edition();
        edition.setIdpersonnel(idpersonnel);
        edition.setIdelementpaie(ConstantePaie.rub_brut);
        String aWhere =
                " AND ((MOIS = " + mois1 + " AND ANNEE = " + annee1 + ")" +
                        " OR (MOIS = " + mois2 + " AND ANNEE = " + annee2 + "))";

        Paie_edition[] res = (Paie_edition[]) CGenUtil.rechercher(edition, null, null, c, aWhere);
        double total = 0;

        if(res != null && res.length > 0) {
            total = AdminGen.calculSommeDouble(res, "gain");
        }

        return total;
    }

    public void calculHsPersonne(String idPersonnel, int mois, int annee) throws Exception {
        DemandeHsLib hs = new DemandeHsLib();
        hs.setIdPersonnel(idPersonnel);
        hs.setMois(mois);
        hs.setAnnne(annee);
        hs.setNomTable("V_DEMANDEHS_WEEKLY");


        DemandeHsLib[] res = (DemandeHsLib[]) CGenUtil.rechercher(hs, null, null, "");

        System.out.println(" ressss ++++++ " + res.length);

        if(res != null && res.length>0) {
            double hs30Imp = 0;
            double hs30NonImp = 0;
            double hs50Imp = 0;
            double hs50NonImp = 0;

            double cumul = 0;

            for (DemandeHsLib h : res) {

                double hs30 = h.getHeures_30();
                double hs50 = h.getHeures_50();

                System.out.println(" hs 30 and hs 50 ++++ " + h.getHeures_50() + h.getHeures_30());

                double totalSemaine = hs30 + hs50;

                double restantNonImp = Math.max(20 - cumul, 0);

                if (restantNonImp > 0) {
                    if (totalSemaine <= restantNonImp) {
                        hs30NonImp += hs30;
                        hs50NonImp += hs50;
                    } else {
                        double ratio = restantNonImp / totalSemaine;

                        double hs30Non = hs30 * ratio;
                        double hs50Non = hs50 * ratio;

                        hs30NonImp += hs30Non;
                        hs50NonImp += hs50Non;

                        hs30Imp += (hs30 - hs30Non);
                        hs50Imp += (hs50 - hs50Non);
                    }
                } else {
                    // Tout imposable
                    hs30Imp += hs30;
                    hs50Imp += hs50;
                }

                cumul += totalSemaine;
            }
            System.out.println(" id personnel ++++++ " + idPersonnel + " 30 NON IMP ++++ " + hs30NonImp);

            this.setHs30imp(hs30Imp);
            this.setHs50imp(hs50Imp);
            this.setHs30nonimp(hs30NonImp);
            this.setHs50nonimp(hs50NonImp);
        }
    }

    public static int calculAnciennete(Date dateEmbauche, Date dateDepart) {
        if (dateDepart == null || !dateDepart.after(dateEmbauche)) return 0;
        Calendar c1 = Calendar.getInstance(), c2 = Calendar.getInstance();
        c1.setTime(dateEmbauche);
        c2.setTime(dateDepart);
        int years = c2.get(Calendar.YEAR) - c1.get(Calendar.YEAR);
        if (c2.get(Calendar.DAY_OF_YEAR) < c1.get(Calendar.DAY_OF_YEAR)) years--;
        return Math.max(years, 0);
    }

    public void getPrepared(PreparedStatement stmt) throws Exception {
//        calculProrata();
        for (PaieInfoPersEltPaieComplet eltP : this.getListeEltAInserer()) {
//            if( this.getTemporaire() ==1 )System.out.println("Elem_elem------->" + eltP.getIdpersonnel() + "  -- rub " +  eltP.getId_objet()+ " | "+ eltP.getCode_rubrique()  + " -- gain  "  + eltP.getGain() + " --  ret " + eltP.getRetenue() + "-- rang "  + eltP.getRang() + " Mois - Annee " +  eltP.getMois() + eltP.getAnnee() + " | "  +  eltP.getId()   );
            if ((eltP.getRetenue() > 0 || eltP.getGain() > 0) && eltP.getInserted() == 1) {
//                if( this.getTemporaire() ==1 )System.out.println("Elem_insr------->" + eltP.getIdpersonnel() + "  -- rub " +  eltP.getId_objet()+ " | "+ eltP.getCode_rubrique()  + " -- gain  "  + eltP.getGain() + " --  ret " + eltP.getRetenue() + "-- rang "  + eltP.getRang() + " Mois - Annee " +  eltP.getMois() + eltP.getAnnee() + " | "  +  eltP.getId()  );

//                 IDPERSONNEL , IDELEMENTPAIE, MOIS, ANNEE, GAIN, RETENUE, DATEDEBUT, DATEFIN,IDEDITION,REMARQUE
                stmt.setString(1, eltP.getIdpersonnel());
                stmt.setString(2, eltP.getCode_rubrique());
                stmt.setInt(3, eltP.getMois());
                stmt.setInt(4, eltP.getAnnee());
                stmt.setDouble(5, eltP.getGain());
                stmt.setDouble(6, eltP.getRetenue());
                stmt.setDate(7, eltP.getDateDebutEditon());
                stmt.setDate(8, eltP.getDateFinEdition());
                stmt.setString(9, eltP.getMere());
                stmt.setString(10, eltP.getRemarque());
                stmt.setInt(11, eltP.getNbenfant());
                stmt.setString(12, eltP.getIdfonction());
                stmt.setString(13, eltP.getIdcategorie_paie());

                CategorieQualification cat = new CategorieQualification();
                CategorieQualification[] listCats = (CategorieQualification[]) CGenUtil.rechercher(cat, null, null, stmt.getConnection(), " and REMARQUE ='" + eltP.getIdpersonnel() + "'");
                if (listCats.length > 0) {
                    eltP.setSalaire_de_base(listCats[0].getMontant());
                } else {
                    listCats = (CategorieQualification[]) CGenUtil.rechercher(cat, null, null, stmt.getConnection(), " and idcategorie ='" + eltP.getIdcategorie_paie() + "' and idqualification='" + eltP.getIdqualification() + "'");
                    if (listCats.length > 0) {
                        eltP.setSalaire_de_base(listCats[0].getMontant());
                    } else {
                        eltP.setSalaire_de_base(0);
                    }
                }
                stmt.setDouble(14, eltP.getSalaire_de_base() / ConstantePaie.heuremois);
                stmt.setDouble(15, eltP.getSalaire_de_base());
                stmt.setInt(16, eltP.getTemporaire());
                stmt.setString(17, eltP.getMatricule());
                stmt.setString(18, eltP.getDirection());
                stmt.setString(19, eltP.getService());
                stmt.setInt(20, eltP.getRegroupement());
                stmt.setString(21, eltP.getMode_paiement());
                stmt.setInt(22, ConstanteEtatPaie.getEtatCreer());
                stmt.setString(23, this.getIdPeriodePaie());
                stmt.setDouble(24, eltP.getBase());
                stmt.setDouble(25, eltP.getTaux());
                stmt.setDouble(26, eltP.getQuantite());

                stmt.addBatch();
            }
        }
    }

    public void nettoyerDoublons() throws Exception {
        ArrayList<PaieInfoPersEltPaieComplet> listeSB = getListeEltPaie(this.getListeEltAInserer(), "code", "101");
//        System.out.println("listeSB.size() = " + listeSB.size());
        if (listeSB.size() > 1) {
            for (PaieInfoPersEltPaieComplet elt : listeSB) {
                if (elt.getDate_fin() == null || elt.getDate_fin().compareTo(Utilitaire.getFinDuMoisByMoisAnnee(this.getMois(), this.getAnnee())) != 0) {
                    this.getListeEltAInserer().remove(elt);
                }
            }
        }
    }

    public void initFormule(PaieEditionmoisannee idEdition) throws Exception {
        ArrayList<PaieRubrique> rubBen = getRubriqueBeneficiaire();
        for (PaieRubrique rub : rubBen) {
            ArrayList<PaieInfoPersEltPaieComplet> listeEltl = getListeEltPaie(listeEltAInserer, "code", rub.getCode());
            for (PaieInfoPersEltPaieComplet el : listeEltl) {
//                System.out.println(rub.getCode() + "-----+ " + rub.getVal() + "  Valeur element paie===> " + el.getCode() + "-+---" + el.getGain() + "-+----" + el.getRetenue());
            }

            if (listeEltl.size() > 0) {
                continue;
            }
            if (estBeneficiaire(rub)) {

//                System.out.println("++++++++++> A inserer d "+ this.getId()+" | code "+ rub.getId() );
                PaieInfoPersEltPaieComplet pers = new PaieInfoPersEltPaieComplet(rub, this.getListeEltAInserer(), rub.getCode(), this.getId(), 0, -1, "", "");

                if (rub.getTyperubrique().compareToIgnoreCase("G") == 0) {
                    pers.setGain(-1);
                    pers.setRetenue(0);
                }
                pers.setIdpersonnel(this.getId());
                pers.setDirection(this.getDirection());
                pers.setService(this.getService());
                pers.setIdcategorie_paie(this.getIdcategorie_paie());
                pers.setIdfonction(this.getIdfonction());
                pers.setIdqualification(this.getIdqualification());
                pers.setPersonnel_etat(this.getPersonnel_etat());
                pers.setMois(idEdition.getMois());
                pers.setAnnee(idEdition.getAnnee());
                pers.setMere(idEdition.getId());
                pers.setNbenfant(this.getNbenfant());
                String mois = Utilitaire.completerInt(2, idEdition.getMois());

                pers.setNbjmois(Utilitaire.getNombreJourMois(mois, String.valueOf(idEdition.getAnnee())));
                pers.setNbpro(this.getNb_prorata());
                pers.setSalaire_base(this.getSalaire_Base());
                pers.setCnaps12(this.getCnaps12());
                pers.setCnaps13(this.getCnaps13());
                pers.setMois_edition(this.getMois_edition());
                pers.setAnnee_edition(this.getAnnee_edition());

                pers.setHeurenormal(this.getHeurenormal());
                pers.setHeuresupnormal(this.getHeuresupnormal());
                pers.setHeuresupferie(this.getHeuresupferie());
                pers.setHeuresupnuit(this.getHeuresupnuit());
                pers.setHeuresupweekend(this.getHeuresupweekend());
                pers.setAbsence(this.getAbsence());
                pers.setNbjpreavis(this.getNbjpreavis());
                pers.setAnciennete(this.getAnciennete());
                pers.setHs30nonimp(this.getHs30nonimp());
                pers.setHs50nonimp(this.getHs50nonimp());
                pers.setHs50imp(this.getHs50imp());
                pers.setHs30imp(this.getHs30imp());

                pers.setStc(this.getStc());
                pers.setImposable12(this.getImposable12());
                pers.setNbconge(this.getNbconge());
                pers.setAbsence_conge(this.getAbsence_conge());
                pers.setAbsence_heure(this.getAbsence_heure());
                pers.setAbsence_jour(this.getAbsence_jour());
                pers.setAnciennete(this.getAnciennete());
                pers.setWork_day(this.getWork_day());
                pers.setCantine(this.getCantine());
                pers.setHeure_absence(this.getHeure_absence());
                pers.setSous_categorie_paie(this.getSous_categorie_paie());
                pers.setOver60(this.getOver60());
                pers.setJour_total_conge(this.getJour_total_conge());
                pers.setBase_allocation(this.getBase_allocation());



//                System.out.println("stc====>"+pers.getStc()+"   imposable12=====>"+pers.getImposable12()+"   Nbconge=======>"+this.getNbconge());

                this.getListeEltAInserer().add(pers);
            }
        }
    }

    public ArrayList<PaieRubrique> getRubriqueBeneficiaire() throws Exception {
        ArrayList<PaieRubrique> retour = new ArrayList<PaieRubrique>();
        for (PaieRubrique rub : getListRub()) {
            if (rub.getBeneficiaire() != null && rub.getBeneficiaire().compareToIgnoreCase("") != 0) {
                retour.add(rub);
            }
        }
        return retour;
    }

    public static ArrayList<PaieInfoPersEltPaieComplet> getListeEltPaie(ArrayList<PaieInfoPersEltPaieComplet> liste, String colonne, String valeur) throws Exception {
        ArrayList<PaieInfoPersEltPaieComplet> retour = new ArrayList<PaieInfoPersEltPaieComplet>();
        for (PaieInfoPersEltPaieComplet elt : liste) {
            if (elt.verifieCondition(colonne, valeur)) {
                retour.add(elt);
            }
        }
        return retour;
    }

    public static ArrayList<PaieInfoPersEltPaieComplet> getListeEltPaieInserable(ArrayList<PaieInfoPersEltPaieComplet> liste, String colonne, String valeur) throws Exception {
        ArrayList<PaieInfoPersEltPaieComplet> retour = new ArrayList<PaieInfoPersEltPaieComplet>();
        for (PaieInfoPersEltPaieComplet elt : liste) {
            if (elt.verifieCondition(colonne, valeur) && (elt.getInserted() == 1)) {
                retour.add(elt);
            }
        }
        return retour;
    }

    public boolean estBeneficiaire(PaieRubrique pr) throws Exception {
        if (pr.getBeneficiaire() == null || pr.getBeneficiaire().compareToIgnoreCase("") == 0) {
            return false;
        }
        if (pr.getBeneficiaire().compareToIgnoreCase("%") == 0) {
            return true;
        }
        return evaluerBeneficiaire(pr);
    }

    public boolean estFormule(PaieInfoPersEltPaieComplet e) throws Exception {
        String[] attributET = {"mere"};
        String[] valET = {e.getCode_rubrique()};
        return AdminGen.testExiste(getListeFormule(), attributET, valET);
    }

    public boolean evaluerBeneficiaire(PaieRubrique pr) throws Exception {
        String benefChiffre = UtilitaireFormule.remplacerRubriqueParChiffre(this, pr.getBeneficiaire(), listeEltAInserer);
        return UtilitaireFormule.evaluerCondition(benefChiffre);
    }

    public void evaluerFormule() throws Exception {
        this.getListeEltAInserer().sort(this);

//        System.out.println("Taille liste a inserer" + this.getListeEltAInserer().size());

        for (PaieInfoPersEltPaieComplet elmt : this.getListeEltAInserer()) {
            try {
                if (this.estFormule(elmt) && (elmt.getGain() == -1 || elmt.getRetenue() == -1)) {

                    double valeur = 0;
                    for (DetFormu formu : getListeFormule()) // Mila amboarina fa tsy mila atao boucle intsony
                    {
                        valeur += formu.calculerValeur(elmt, listeEltAInserer);
                    }
                    if (elmt.getTyperubrique().compareToIgnoreCase("G") == 0) {
                        elmt.setGain(valeur);
                    } else {
                        elmt.setRetenue(valeur);
                    }
                }

//                System.out.println("APRES FORMULE");

                if (elmt.getCode().equals("PR000041")) {
//                    System.out.println("Idpers==>" + elmt.getIdpersonnel());
//                    System.out.println("PR000041==>" + elmt.getGain());
                }

            } catch (Exception e) {
                e.printStackTrace();
                e.getMessage();
            }
        }
    }

    public static double[] getValeurEltPaie(ArrayList<PaieInfoPersEltPaieComplet> liste, String colonne, String valeur) throws Exception {
        double[] retour = new double[2];
        retour[0] = 0;
        retour[1] = 0;
        for (PaieInfoPersEltPaieComplet elt : liste) {
            double[] valiny = elt.getGainRetenue(colonne, valeur);
            if (valiny[0] > 0) {
                retour[0] = retour[0] + valiny[0];
            }
            if (valiny[1] > 0) {
                retour[1] = retour[1] + valiny[1];
            }
        }
        return retour;
    }

    public void genererStc(String idobjet,String refUser,String idtypedepart)throws Exception{
        Connection c = null;
        try {
            c = new UtilDB().GetConn();
            c.setAutoCommit(false);
            System.out.println("id===> "+this.getId());
            PaieInfoPersonnel pip = new PaieInfoPersonnel();
            pip.setNomTable("PAIE_INFO_PERSONNELDIRECT");
            PaieInfoPersonnel[] liste=(PaieInfoPersonnel[]) CGenUtil.rechercher(pip, null, null, c, " and id = '"+this.getId()+"'");
            System.out.println("Taille liste===> "+liste.length);

            System.out.println("id"+liste[0].getId());
            System.out.println("mode_payement"+liste[0].getMode_paiement());
            System.out.println("matricule"+liste[0].getMatricule());
            System.out.println("nbanneeservice"+liste[0].getNbAnneeService());


            System.out.println("val salaire"+liste[0].getSalaire_Base());
            System.out.println("val salaire"+liste[0].getSalaire_base());



            this.setSalaire_de_base(liste[0].getSalaire_Base());
            System.out.println("Salaire===>"+this.getSalaire_de_base());
            insert_elp_stc(c,idobjet,refUser,this.getNbjpreavis(),idtypedepart);
            c.commit();
            if(c!=null) c.close();
        } catch (Exception e) {
            c.rollback();
            e.printStackTrace();
        }
    }


    public void insert_elp_stc(Connection c,String idobjet,String refUser,double nbjpreavis,String typedepart)throws Exception{
        this.indem_licenciement(c, idobjet,refUser);
        this.indem_preavis(c, idobjet, refUser,typedepart);
        this.allocongeReste(c, idobjet, refUser);
    }

    public PaiePersonnelElementpaie indem_licenciement(Connection c,String idobjet,String refUser)throws Exception{
        PaiePersonnelElementpaie temp = new PaiePersonnelElementpaie();
        double montant = this.getSalaire_de_base()/30*10*this.getNbAnneeService();
        temp.setCode_rubrique(ConstantePaie.idLicensiement);
        temp.setDate_debut(this.getDate_depart());
        temp.setDate_fin(this.getDate_depart());
        temp.setGain(montant);
        temp.setRetenue(0);
        temp.setRemarque("");
        temp.setIdpersonnel(this.getId());
        temp.setEtat(1);
        temp.setId_objet(idobjet);
        temp.setIduser(refUser);
        temp.construirePK(c);
        temp.insertToTableWithHisto(refUser, c);
        return temp;
    }

    public PaiePersonnelElementpaie indem_preavis(Connection c,String idobjet,String refUser,String typedepart)throws Exception{
        PaiePersonnelElementpaie temp = new PaiePersonnelElementpaie();
        double montant = this.getSalaire_de_base()/30*this.getNbjpreavis();
        temp.setCode_rubrique(ConstantePaie.idPreavis);
        temp.setDate_debut(this.getDate_depart());
        temp.setDate_fin(this.getDate_depart());
        temp.setGain(montant);
        temp.setRetenue(0);
        temp.setRemarque("");
        temp.setIdpersonnel(this.getId());
        temp.setEtat(1);
        temp.setId_objet(idobjet);
        temp.setIduser(refUser);
        if(typedepart.equals(ConstantePaie.dep_iddemissionSansPreavis)){
            temp.setCode_rubrique(ConstantePaie.idPreavisRetenue);
            temp.setGain(0);
            temp.setRetenue(montant);
        }
        temp.construirePK(c);
        temp.insertToTableWithHisto(refUser, c);
        return temp;
    }

    public PaiePersonnelElementpaie retenue_preavis(Connection c,String idobjet,String refUser,String typedepart)throws Exception{
        PaiePersonnelElementpaie temp = new PaiePersonnelElementpaie();
        double montant = this.getSalaire_Base()/30*this.getNbjpreavis();
        temp.setCode_rubrique(ConstantePaie.idPreavis);
        temp.setDate_debut(this.getDate_depart());
        temp.setDate_fin(this.getDate_depart());
        temp.setGain(0);
        temp.setRetenue(montant);
        temp.setRemarque("");
        temp.setIdpersonnel(this.getId());
        temp.setEtat(1);
        temp.setId_objet(idobjet);
        temp.setIduser(refUser);
        if(typedepart.equals(ConstantePaie.dep_iddemissionSansPreavis)){
            temp.setCode_rubrique(ConstantePaie.idPreavisRetenue);
            temp.setGain(0);
            temp.setRetenue(montant);
        }
        temp.construirePK(c);
        temp.insertToTableWithHisto(refUser, c);
        return temp;
    }

    public PaiePersonnelElementpaie allocongeReste(Connection c,String idobjet,String refUser)throws Exception{
        Paie_edition pe = new Paie_edition();
        pe.setIdpersonnel(this.getId());
        pe.setNomTable("sb_12dernier_mois");
        Paie_edition[] sb12Mois = (Paie_edition[])CGenUtil.rechercher(pe, null, null, "");
        double montant = 0.0;
        if(sb12Mois != null && sb12Mois.length>0){
            MouvementAbsence mvt = new MouvementAbsence();
            mvt.setIdPersonnel(this.getId());
            mvt.setNomTable("SOLDECONGE_PERS");
            MouvementAbsence[] solde = (MouvementAbsence[])CGenUtil.rechercher(mvt, null, null, "");

            System.out.println("montant=>"+montant);
            System.out.println("solde[0].getSolde()=>"+solde[0].getSolde());
            System.out.println("sb12Mois.length=>"+sb12Mois.length);


            System.out.println("solde.length=>"+solde.length);




            montant = AdminGen.calculSommeDouble(sb12Mois, "salaire_base");
            montant = montant * solde[0].getSolde() / sb12Mois.length;
            PaiePersonnelElementpaie temp = new PaiePersonnelElementpaie();
            temp.setCode_rubrique(ConstantePaie.idAllocationconge);
            temp.setDate_debut(this.getDate_depart());
            temp.setDate_fin(this.getDate_depart());
            temp.setGain(montant);
            temp.setRetenue(0);
            temp.setRemarque("");
            temp.setIdpersonnel(this.getId());
            temp.setEtat(1);
            temp.setId_objet(idobjet);
            temp.setIduser(refUser);
            temp.construirePK(c);
            temp.insertToTableWithHisto(refUser, c);
            return temp;
        } else {
            throw new Exception("Erreur pendant le calcul de l'allocation de cong\\u00E9, veuillez v\\u00E9rifier l'anciennet\\u00E9 de ce personnel.");
        }
    }


    public static double[] getValeurEltPaieInserable(ArrayList<PaieInfoPersEltPaieComplet> liste, String colonne, String valeur) throws Exception {
        double[] retour = new double[2];
        retour[0] = 0;
        retour[1] = 0;
        int i = 0;
        for (PaieInfoPersEltPaieComplet elt : liste) {
            if (elt.getInserted() == 1) {
                double[] valiny = elt.getGainRetenue(colonne, valeur);
                if (valiny[0] > 0) {
                    retour[0] = retour[0] + valiny[0];
                }
                if (valiny[1] > 0) {
                    retour[1] = retour[1] + valiny[1];
                }
            }
        }
        return retour;
    }

    public static void desactivateAll(String[] ids) throws Exception
    {
        Connection c = null;
        String currentId = null;

        try{

            c = new UtilDB().GetConn();
            c.setAutoCommit(false);



            for (String id : ids)
            {
                currentId = id;

                PaieInfoPersonnel pip = new PaieInfoPersonnel();
                pip.setId(id);
                pip.updateEtat(7, id, c);
                System.out.println(id + " Desactivated");
            }

            c.commit();

        } catch (Exception e)
        {
            if (c != null) {
                try {
                    c.rollback();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            throw new Exception("Erreur lors de la désactivation pour l'ID : " + currentId, e);
        } finally {

            if (c != null)
            {
                c.close();
            }

        }

    }

    public static void activateAll(String[] ids) throws Exception
    {
        Connection c = null;
        String currentId = null;

        try{

            c = new UtilDB().GetConn();
            c.setAutoCommit(false);



            for (String id : ids)
            {
                currentId = id;

                PaieInfoPersonnel pip = new PaieInfoPersonnel();
                pip.setId(id);
                pip.updateEtat(11, id, c);
                System.out.println(id + " Activated");
            }

            c.commit();

        } catch (Exception e)
        {
            if (c != null) {
                try {
                    c.rollback();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            throw new Exception("Erreur lors de la activation pour l'ID : " + currentId, e);
        } finally {

            if (c != null)
            {
                c.close();
            }

        }

    }

    public double getTauxHoraire(Connection c) throws Exception {
        PaieInfoPersonnel pip = new PaieInfoPersonnel();
        pip.setId(this.getId());
        pip.setNomTable("PAIE_INFO_PERSONNELDIRECT");
        PaieInfoPersonnel[] res = (PaieInfoPersonnel[]) CGenUtil.rechercher(pip, null, null, c, "");
        if(res != null && res.length>0) {
            System.out.println(" sb 1 +++++++ " + res[0].getSalaire_Base());
            System.out.println(" sb 2 +++++++ " + res[0].getSalaireBase());
            System.out.println(" sb 3 +++++++ " + res[0].getSalaire_base());
            System.out.println(" sb 4 +++++++ " + res[0].getSalaire_de_base());

            return res[0].getSalaire_Base();
        } else {
            throw new Exception("Salaire de base introuvable pour le personnel num: " + this.getId());
        }

    }

    public HashMap<String, PaieInfoPersonnel> getSalaireBaseByIdMultiple (Connection c, String[] ids) throws Exception
    {
        PaieInfoPersonnel pip = new PaieInfoPersonnel();
        pip.setNomTable("PAIE_INFO_PERSONNELDIRECT");
        PaieInfoPersonnel[] pips = (PaieInfoPersonnel[]) CGenUtil.rechercher(pip, null, null, c, " and ID in (" +Utilitaire.tabToString(ids, "'", ",")+" )");

        if (pips == null || pips.length == 0)
        {
            throw new Exception("Salaire de base introuvable");
        }

        HashMap<String, PaieInfoPersonnel> personnelSalaireMap = new HashMap<>();

        for (PaieInfoPersonnel p : pips)
        {
            personnelSalaireMap.put(p.getId(), p);
        }

        return personnelSalaireMap;
    }

    public double getSalaireBaseById(Connection c) throws Exception {
        PaieInfoPersonnel pip = new PaieInfoPersonnel();
        pip.setId(this.getId());
        pip.setNomTable("PAIE_INFO_PERSONNELDIRECT");
        PaieInfoPersonnel[] res = (PaieInfoPersonnel[]) CGenUtil.rechercher(pip, null, null, c, "");
        if(res != null && res.length>0) {
//            System.out.println(" sb 1 +++++++ " + res[0].getSalaire_Base());
//            System.out.println(" sb 2 +++++++ " + res[0].getSalaireBase());
//            System.out.println(" sb 3 +++++++ " + res[0].getSalaire_base());
//            System.out.println(" sb 4 +++++++ " + res[0].getSalaire_de_base());

            return res[0].getSalaire_Base();
        } else {
            throw new Exception("Salaire de base introuvable pour le personnel num: " + this.getId());
        }

    }

    public PaieInfoPersonnel[] getIdPersByMatriculeMultiple(Connection c, String[] matricules) throws Exception
    {
        PaieInfoPersonnel[] pips = (PaieInfoPersonnel[]) CGenUtil.rechercher(new PaieInfoPersonnel(), null, null, c, " AND ETAT = 11 and MATRICULE in (" +Utilitaire.tabToString(matricules, "'", ",")+" )");


        if (pips == null || pips.length == 0)
        {
            throw new Exception("Personnels introuvable");
        }

        return pips;
    }

    public String getIdPersByMatricule(Connection c) throws Exception {
        PaieInfoPersonnel pip = new PaieInfoPersonnel();
        pip.setMatricule(this.getMatricule());
        PaieInfoPersonnel[] paieInfoPersonnels = (PaieInfoPersonnel[]) CGenUtil.rechercher(pip, null, null, c, "");

        if (paieInfoPersonnels == null || paieInfoPersonnels.length == 0)
        {
            throw new Exception("Personnel introuvable pour la matricule: " + this.getMatricule());
        }

        return paieInfoPersonnels[0].getId();

    }

    public int compare(PaieInfoPersEltPaieComplet e1, PaieInfoPersEltPaieComplet e2) {
        return e1.getRang() - e2.getRang();
    }

    public void setDatesaisie(Date datesaisie) {
        this.datesaisie = datesaisie;
    }

    @Override
    public String getValColLibelle() {
        return this.getCturgence_nom_prenom();
    }

    public int getNbSemaine() {
        return nbSemaine;
    }

    public void setNbSemaine(int nbSemaine) {
        this.nbSemaine = nbSemaine;
    }

    public double getTotalPointageTemp() {
        return totalPointageTemp;
    }

    public void setTotalPointageTemp(double totalPointageTemp) {
        this.totalPointageTemp = totalPointageTemp;
    }

    public String getIdPeriodePaie() {
        return idPeriodePaie;
    }

    public void setIdPeriodePaie(String idPeriodePaie) {
        this.idPeriodePaie = idPeriodePaie;
    }

    public double getHs30imp() {
        return hs30imp;
    }

    public void setHs30imp(double hs30imp) {
        this.hs30imp = hs30imp;
    }

    public double getHs30nonimp() {
        return hs30nonimp;
    }

    public void setHs30nonimp(double hs30nonimp) {
        this.hs30nonimp = hs30nonimp;
    }

    public double getHs50imp() {
        return hs50imp;
    }

    public void setHs50imp(double hs50imp) {
        this.hs50imp = hs50imp;
    }

    public double getHs50nonimp() {
        return hs50nonimp;
    }

    public void setHs50nonimp(double hs50nonimp) {
        this.hs50nonimp = hs50nonimp;
    }

    public double getAbsence_conge() {
        return absence_conge;
    }

    public void setAbsence_conge(double absence_conge) {
        this.absence_conge = absence_conge;
    }

    public double getAbsence_heure() {
        return absence_heure;
    }

    public void setAbsence_heure(double absence_heure) {
        this.absence_heure = absence_heure;
    }

    public double getAbsence_jour() {
        return absence_jour;
    }

    public void setAbsence_jour(double absence_jour) {
        this.absence_jour = absence_jour;
    }

    public double getHeure_totale_nuit() {
        return heure_totale_nuit;
    }

    public void setHeure_totale_nuit(double heure_totale_nuit) {
        this.heure_totale_nuit = heure_totale_nuit;
    }

    public double getJour_total_conge() {
        return jour_total_conge;
    }

    public void setJour_total_conge(double jour_total_conge) {
        this.jour_total_conge = jour_total_conge;
    }

    public double getWork_day() {
        return work_day;
    }

    public void setWork_day(double work_day) {
        this.work_day = work_day;
    }

    public double getHeure_absence() {
        return heure_absence;
    }

    public void setHeure_absence(double heure_absence) {
        this.heure_absence = heure_absence;
    }

    public String getSous_categorie_paie() {
        return sous_categorie_paie;
    }

    public void setSous_categorie_paie(String sous_categorie_paie) {
        this.sous_categorie_paie = sous_categorie_paie;
    }

    public double getOver60() {
        return over60;
    }

    public void setOver60(double over60) {
        this.over60 = over60;
    }

    public double getBase_allocation() {
        return base_allocation;
    }

    public void setBase_allocation(double base_allocation) {
        this.base_allocation = base_allocation;
    }
}
