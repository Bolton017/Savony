/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.log;
import bean.ClassMAPTable;
import java.sql.Date;
import java.util.logging.Logger;

/**
 *
 * @author Tsiky
 */
public class LogPersonnelInfoComplet extends ClassMAPTable{
    private String id, numero_cin, nationalite, adresse, fokotany, acte_naissance, direction, service, idinfo, permis_conduire, matricule, lieu_naissance_commune, lieu_delivrance_cin, situation_matrimonial, initiale, cturgence_nom_prenom, cturgence_telephone1, cturgence_telephone2, cturgence_telephone3, chemin_permis, idconjoint, code_agence_banque, banque_numero_compte, banque_compte_cle, idfonction, idcategorie, mode_paiement, remarque, id_pers, nom, prenom;
    private Date date_cin, date_dupl_cin, datesaisie, dateembauche, date_naissance;
    private String sexe;
    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public LogPersonnelInfoComplet() {
        super.setNomTable("LOG_PERSONNEL_INFOCOMPLET");
    }

    public LogPersonnelInfoComplet(String id, String numero_cin, String nationalite, String adresse, String fokotany, String acte_naissance, String direction, String service, String idinfo, String permis_conduire, String matricule, String lieu_naissance_commune, String lieu_delivrance_cin, String situation_matrimonial, String initiale, String cturgence_nom_prenom, String cturgence_telephone1, String cturgence_telephone2, String cturgence_telephone3, String chemin_permis, String idconjoint, String code_agence_banque, String banque_numero_compte, String banque_compte_cle, String idfonction, String idcategorie, String mode_paiement, String remarque, String id_pers, String nom, String prenom, Date date_cin, Date date_dupl_cin, Date datesaisie, Date dateembauche, Date date_naissance, String sexe) {
        super.setNomTable("LOG_PERSONNEL_INFOCOMPLET");
        this.id = id;
        this.numero_cin = numero_cin;
        this.nationalite = nationalite;
        this.adresse = adresse;
        this.fokotany = fokotany;
        this.acte_naissance = acte_naissance;
        this.direction = direction;
        this.service = service;
        this.idinfo = idinfo;
        this.permis_conduire = permis_conduire;
        this.matricule = matricule;
        this.lieu_naissance_commune = lieu_naissance_commune;
        this.lieu_delivrance_cin = lieu_delivrance_cin;
        this.situation_matrimonial = situation_matrimonial;
        this.initiale = initiale;
        this.cturgence_nom_prenom = cturgence_nom_prenom;
        this.cturgence_telephone1 = cturgence_telephone1;
        this.cturgence_telephone2 = cturgence_telephone2;
        this.cturgence_telephone3 = cturgence_telephone3;
        this.chemin_permis = chemin_permis;
        this.idconjoint = idconjoint;
        this.code_agence_banque = code_agence_banque;
        this.banque_numero_compte = banque_numero_compte;
        this.banque_compte_cle = banque_compte_cle;
        this.idfonction = idfonction;
        this.idcategorie = idcategorie;
        this.mode_paiement = mode_paiement;
        this.remarque = remarque;
        this.id_pers = id_pers;
        this.nom = nom;
        this.prenom = prenom;
        this.date_cin = date_cin;
        this.date_dupl_cin = date_dupl_cin;
        this.datesaisie = datesaisie;
        this.dateembauche = dateembauche;
        this.date_naissance = date_naissance;
        this.sexe = sexe;
    }
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNumero_cin() {
        return numero_cin;
    }

    public void setNumero_cin(String numero_cin) {
        this.numero_cin = numero_cin;
    }

    public String getNationalite() {
        return nationalite;
    }

    public void setNationalite(String nationalite) {
        this.nationalite = nationalite;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public String getFokotany() {
        return fokotany;
    }

    public void setFokotany(String fokotany) {
        this.fokotany = fokotany;
    }

    public String getActe_naissance() {
        return acte_naissance;
    }

    public void setActe_naissance(String acte_naissance) {
        this.acte_naissance = acte_naissance;
    }

    public String getDirection() {
        return direction;
    }

    public void setDirection(String direction) {
        this.direction = direction;
    }

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    public String getIdinfo() {
        return idinfo;
    }

    public void setIdinfo(String idinfo) {
        this.idinfo = idinfo;
    }

    public String getPermis_conduire() {
        return permis_conduire;
    }

    public void setPermis_conduire(String permis_conduire) {
        this.permis_conduire = permis_conduire;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getLieu_naissance_commune() {
        return lieu_naissance_commune;
    }

    public void setLieu_naissance_commune(String lieu_naissance_commune) {
        this.lieu_naissance_commune = lieu_naissance_commune;
    }

    public String getLieu_delivrance_cin() {
        return lieu_delivrance_cin;
    }

    public void setLieu_delivrance_cin(String lieu_delivrance_cin) {
        this.lieu_delivrance_cin = lieu_delivrance_cin;
    }

    public String getSituation_matrimonial() {
        return situation_matrimonial;
    }

    public void setSituation_matrimonial(String situation_matrimonial) {
        this.situation_matrimonial = situation_matrimonial;
    }

    public String getInitiale() {
        return initiale;
    }

    public void setInitiale(String initiale) {
        this.initiale = initiale;
    }

    public String getCturgence_nom_prenom() {
        return cturgence_nom_prenom;
    }

    public void setCturgence_nom_prenom(String cturgence_nom_prenom) {
        this.cturgence_nom_prenom = cturgence_nom_prenom;
    }

    public String getCturgence_telephone1() {
        return cturgence_telephone1;
    }

    public void setCturgence_telephone1(String cturgence_telephone1) {
        this.cturgence_telephone1 = cturgence_telephone1;
    }

    public String getCturgence_telephone2() {
        return cturgence_telephone2;
    }

    public void setCturgence_telephone2(String cturgence_telephone2) {
        this.cturgence_telephone2 = cturgence_telephone2;
    }

    public String getCturgence_telephone3() {
        return cturgence_telephone3;
    }

    public void setCturgence_telephone3(String cturgence_telephone3) {
        this.cturgence_telephone3 = cturgence_telephone3;
    }

    public String getChemin_permis() {
        return chemin_permis;
    }

    public void setChemin_permis(String chemin_permis) {
        this.chemin_permis = chemin_permis;
    }

    public String getIdconjoint() {
        return idconjoint;
    }

    public void setIdconjoint(String idconjoint) {
        this.idconjoint = idconjoint;
    }

    public String getCode_agence_banque() {
        return code_agence_banque;
    }

    public void setCode_agence_banque(String code_agence_banque) {
        this.code_agence_banque = code_agence_banque;
    }

    public String getBanque_numero_compte() {
        return banque_numero_compte;
    }

    public void setBanque_numero_compte(String banque_numero_compte) {
        this.banque_numero_compte = banque_numero_compte;
    }

    public String getBanque_compte_cle() {
        return banque_compte_cle;
    }

    public void setBanque_compte_cle(String banque_compte_cle) {
        this.banque_compte_cle = banque_compte_cle;
    }

    public String getIdfonction() {
        return idfonction;
    }

    public void setIdfonction(String idfonction) {
        this.idfonction = idfonction;
    }

    public String getIdcategorie() {
        return idcategorie;
    }

    public void setIdcategorie(String idcategorie) {
        this.idcategorie = idcategorie;
    }

    public String getMode_paiement() {
        return mode_paiement;
    }

    public void setMode_paiement(String mode_paiement) {
        this.mode_paiement = mode_paiement;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getId_pers() {
        return id_pers;
    }

    public void setId_pers(String id_pers) {
        this.id_pers = id_pers;
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

    public Date getDate_cin() {
        return date_cin;
    }

    public void setDate_cin(Date date_cin) {
        this.date_cin = date_cin;
    }

    public Date getDate_dupl_cin() {
        return date_dupl_cin;
    }

    public void setDate_dupl_cin(Date date_dupl_cin) {
        this.date_dupl_cin = date_dupl_cin;
    }

    public Date getDatesaisie() {
        return datesaisie;
    }

    public void setDatesaisie(Date datesaisie) {
        this.datesaisie = datesaisie;
    }

    public Date getDateembauche() {
        return dateembauche;
    }

    public void setDateembauche(Date dateembauche) {
        this.dateembauche = dateembauche;
    }

    public Date getDate_naissance() {
        return date_naissance;
    }

    public void setDate_naissance(Date date_naissance) {
        this.date_naissance = date_naissance;
    }

    public String getSexe() {
        return sexe;
    }

    public void setSexe(String sexe) {
        this.sexe = sexe;
    }
    
    
}
