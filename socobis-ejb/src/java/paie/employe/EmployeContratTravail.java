 /*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.employe;

import bean.CGenUtil;
import bean.ClassEtat;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import utilitaire.UtilDB;
/**
 *
 * @author tsiky
 */
public class EmployeContratTravail extends ClassEtat {

    private String id, nom, prenom, idpersonnel,lieu_naissance_commune, sexe, numero_cin;
    private Date date_naissance,dateembauche;
    private Date date_cin, date_dupl_cin, date_dernierpromo,datepromotion,date_depart;
    private int vehiculee;
    private String lieu_delivrance_cin, adresse, fokotany, nationalite, acte_naissance, situation_matrimonial, idconjoint, initiale, matricule, direction, service, idfonction, ctg, classee, matricule_patron, statut, mode_paiement, code_agence_banque, banque_code, banque_compte_cle, permis_conduire, chemin_permis, remarque, banque_numero_compte, cturgence_nom_prenom, cturgence_telephone1, cturgence_telephone2, cturgence_telephone3;
    private String droit_hs, numero_cnaps, numero_ostie;
    private double heurejournalier, heurehebdomadaire, heuremensuel, duree;
    private int temporaire, nbenfant,indesirable;   
    private String motifIndesirable;
    private String telephone,mail,region,adresse_ligne1,adresse_ligne2,code_postal;
    private String idcategorie_paie ,idqualification;
    private String formation,discipline,anneeExperience;
    private int personnel_etat ;
    private double montant;
    private int indice_ct ,indice_fonctionnel,echelon;
    private String n_embauche,n_depart,libcqetat,categorie_qualificationlib,categorie_paielib ;
    private String etatval,fonctionlib;
    private int etat,indicegrade;
    private Date date_debut,date_fin;
    private String avenant;
    private Date debutcontrat;
    private Date fincontrat;
    private String idcontrat_avant;
    
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

    
    public String getFonctionlib() {
        return fonctionlib;
    }

    public void setFonctionlib(String fonctionlib) {
        this.fonctionlib = fonctionlib;
    }

    
    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }
    
  
    
    public String getCategorie_paielib() {
        return categorie_paielib;
    }

    public void setCategorie_paielib(String categorie_paielib) {
        this.categorie_paielib = categorie_paielib;
    }
    
    public String getLibcqetat() {
        return libcqetat;
    }

    public void setLibcqetat(String libcqetat) {
        this.libcqetat = libcqetat;
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
    
    public String getEtatval() {
        return etatval;
    }

    public void setEtatval(String etatval) {
        this.etatval = etatval;
    }

    public int getEtat() {
        return etat;
    }

    public void setEtat(int etat) {
        this.etat = etat;
    }
    
    public String getN_depart() {
        return n_depart;
    }

    public void setN_depart(String n_depart) {
        this.n_depart = n_depart;
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
    
    public double getIndice_ct() {
        return indice_ct;
    }

    public void setIndice_ct(int indice_ct) {
        this.indice_ct = indice_ct;
    }
    
    public Date getDatepromotion() {
        return datepromotion;
    }

    public void setDatepromotion(Date datepromotion) {
        this.datepromotion = datepromotion;
    }
    
    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }
    
    public Date getDateembauche() {
        return dateembauche;
    }

    public void setDateembauche(Date dateembauche) {
        this.dateembauche = dateembauche;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
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

    public String getIdpersonnel() {
        return idpersonnel;
    }

    public void setIdpersonnel(String idpersonnel) {
        this.idpersonnel = idpersonnel;
    }

    public Date getDate_naissance() {
        return date_naissance;
    }

    public void setDate_naissance(Date Date_naissance) {
        this.date_naissance = Date_naissance;
    }

    public String getLieu_naissance_commune() {
        return lieu_naissance_commune;
    }

    public void setLieu_naissance_commune(String lieu_naissance_commune) {
        this.lieu_naissance_commune = lieu_naissance_commune;
    }

    public String getSexe() {
        return sexe;
    }

    public void setSexe(String sexe) {
        this.sexe = sexe;
    }

    public String getNumero_cin() {
        return numero_cin;
    }

    public void setNumero_cin(String numero_cin) {
        this.numero_cin = numero_cin;
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

    public Date getDate_dernierpromo() {
        return date_dernierpromo;
    }

    public void setDate_dernierpromo(Date date_dernierpromo) {
        this.date_dernierpromo = date_dernierpromo;
    }

    public int getVehiculee() {
        return vehiculee;
    }

    public void setVehiculee(int vehiculee) {
        this.vehiculee = vehiculee;
    }

    public String getLieu_delivrance_cin() {
        return lieu_delivrance_cin;
    }

    public void setLieu_delivrance_cin(String lieu_delivrance_cin) {
        this.lieu_delivrance_cin = lieu_delivrance_cin;
    }

    public String getFokotany() {
        return fokotany;
    }

    public void setFokotany(String fokotany) {
        this.fokotany = fokotany;
    }

    public String getNationalite() {
        return nationalite;
    }

    public void setNationalite(String nationalite) {
        this.nationalite = nationalite;
    }

    public String getActe_naissance() {
        return acte_naissance;
    }

    public void setActe_naissance(String acte_naissance) {
        this.acte_naissance = acte_naissance;
    }

    public String getSituation_matrimonial() {
        return situation_matrimonial;
    }

    public void setSituation_matrimonial(String situation_matrimonial) {
        this.situation_matrimonial = situation_matrimonial;
    }

    public String getIdconjoint() {
        return idconjoint;
    }

    public void setIdconjoint(String idconjoint) {
        this.idconjoint = idconjoint;
    }

    public String getInitiale() {
        return initiale;
    }

    public void setInitiale(String initiale) {
        this.initiale = initiale;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
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

    public String getIdfonction() {
        return idfonction;
    }

    public void setIdfonction(String idfonction) {
        this.idfonction = idfonction;
    }

    public String getCtg() {
        return ctg;
    }

    public void setCtg(String ctg) {
        this.ctg = ctg;
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

    public double getIndice_fonctionnel() {
        return indice_fonctionnel;
    }

    public void setIndice_fonctionnel(int indice_fonctionnel) {
        this.indice_fonctionnel = indice_fonctionnel;
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

    public String getMode_paiement() {
        return mode_paiement;
    }

    public void setMode_paiement(String mode_paiement) {
        this.mode_paiement = mode_paiement;
    }

    public String getCode_agence_banque() {
        return code_agence_banque;
    }

    public void setCode_agence_banque(String code_agence_banque) {
        this.code_agence_banque = code_agence_banque;
    }

    public String getBanque_code() {
        return banque_code;
    }

    public void setBanque_code(String banque_code) {
        this.banque_code = banque_code;
    }

    public String getBanque_compte_cle() {
        return banque_compte_cle;
    }

    public void setBanque_compte_cle(String banque_compte_cle) {
        this.banque_compte_cle = banque_compte_cle;
    }

    public String getPermis_conduire() {
        return permis_conduire;
    }

    public void setPermis_conduire(String permis_conduire) {
        this.permis_conduire = permis_conduire;
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

    public String getBanque_numero_compte() {
        return banque_numero_compte;
    }

    public void setBanque_numero_compte(String banque_numero_compte) {
        this.banque_numero_compte = banque_numero_compte;
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

    public double getEchelon() {
        return echelon;
    }

    public void setEchelon(int echelon) {
        this.echelon = echelon;
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

    public void setNumero_cnaps(String numero_cnaps) {
        this.numero_cnaps = numero_cnaps;
    }

    public String getNumero_ostie() {
        return numero_ostie;
    }

    public void setNumero_ostie(String numero_ostie) {
        this.numero_ostie = numero_ostie;
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

    public double getDuree() {
        return duree;
    }

    public void setDuree(double duree) {
        this.duree = duree;
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

    public int getIndesirable() {
        return indesirable;
    }

    public void setIndesirable(int indesirable) {
        this.indesirable = indesirable;
    }

    public String getMotifIndesirable() {
        return motifIndesirable;
    }

    public void setMotifIndesirable(String motifIndesirable) {
        this.motifIndesirable = motifIndesirable;
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

    public int getPersonnel_etat() {
        return personnel_etat;
    }

    public void setPersonnel_etat(int personnel_etat) {
        this.personnel_etat = personnel_etat;
    }

   
    public EmployeContratTravail() {
        super.setNomTable("paie_info_pers_histo_contrat");
    }

    @Override
    public String getTuppleID() {
        return this.id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    
    
    
    public String getSexePdf() {
        System.out.println(this.getSexe());
        return  getSexe().compareToIgnoreCase("0") == 0 ? "Madame" :  "Monsieur";
    }

    public String getPronompersonnelsujet() {
        return  getSexe().compareToIgnoreCase("0") == 0 ? "elle" :  "il";
    }

    public String getGenrePdf() {
        return  getSexe().compareToIgnoreCase("0") == 0 ? "Elle" :  "Il";
    }
    
    public String getIdcontrat_avant() {
        return idcontrat_avant;
    }

    public void setIdcontrat_avant(String idcontrat_avant) {
        this.idcontrat_avant = idcontrat_avant;
    }
    


    public String check(String tmp, int l) {
        if (tmp == null || tmp.compareToIgnoreCase("") == 0) {
            String point = "";
            for (int i = 0; i < l; i++) {
                point += " . ";
            }
            return point;
        }
        return tmp;
    }
    
    public String getCondition(String[] idhisto){
        String where ="";
        String order =" order by matricule";
        if(idhisto.length>0) where = "and id in(";
        for(int i=0;i<idhisto.length;i++){
            if(i==idhisto.length-1) where += "'"+idhisto[i]+"')";
            else where += "'"+idhisto[i]+"',";
        }
        return where.concat(order);
    }
   
    public ArrayList<EmployeContratTravail> getData(String []idhisto) throws SQLException{
        EmployeContratTravail[] li = null;
        EmployeContratTravail emp = new EmployeContratTravail();
        emp.setNomTable("paie_info_pers_histo_contrat");
        String where =this.getCondition(idhisto);
        try{
            li =(EmployeContratTravail[]) CGenUtil.rechercher(emp,null,null,where);
        }catch(Exception e){
            e.getMessage();
        }
            return new ArrayList<EmployeContratTravail>(Arrays.asList(li));       
    } 
    
    public String getDateNaissance(){
        return  utilitaire.Utilitaire.formatterDaty(this.getDate_naissance()) + "";
    }
     
    public String getDateEmbauche (){
        return utilitaire.Utilitaire.formatterDaty(this.getDateembauche()) + "";
    }
    
    public String getTypeContrat(){
        String retour ="0";
        if (this.getFincontrat()!=null) retour= "1";
        return retour;
    }
    
    public String getDateContrat(){
        String retour = utilitaire.Utilitaire.formatterDaty(String.valueOf(this.getDebutcontrat()));
        System.out.println("Fin contrat == "+this.getFincontrat());
        if (this.getFincontrat()!=null){
            retour = retour.concat(" au ").concat(utilitaire.Utilitaire.formatterDaty(String.valueOf(this.getFincontrat())));
        }
        return retour;
    }

    public ArrayList<PaieInfoPersonnelPdf> ToPipPdf(ArrayList<EmployeContratTravail> le){
        ArrayList<PaieInfoPersonnelPdf> data = new  ArrayList<PaieInfoPersonnelPdf>();

            for(EmployeContratTravail e:le ){
                PaieInfoPersonnelPdf de =new PaieInfoPersonnelPdf();
                de.setId(e.getId());
                de.setNom(e.getNom());
                de.setPrenom(e.getPrenom());
                de.setSexe(e.getSexePdf());
                de.setGenre(e.getGenrePdf());
                de.setAvenant(e.check(e.getAvenant(), 10));
                de.setNomcomplet(e.check(e.getNom() + " " + e.getPrenom(), 20));
                de.setMatricule(e.getMatricule());
                de.setDate_naissance(utilitaire.Utilitaire.formatterDaty(e.getDate_naissance()) + "");
                de.setLieu_naissance_commune(e.getLieu_naissance_commune());
                de.setAdresse(e.check(e.getAdresse_ligne1(),10));
                de.setNumero_cin(utilitaire.Utilitaire.separerEnMillier(e.getNumero_cin()));
                de.setDate_cin(utilitaire.Utilitaire.formatterDaty(e.getDate_cin()) + "");
                de.setDateembauche(utilitaire.Utilitaire.formatterDaty(e.getDateembauche()) + "");
                de.setIdcategorie_paie(e.check(e.getCategorie_paielib(), 10));
                de.setIdfonction(e.check(e.getFonctionlib(), 10));
                de.setDuree(e.check(utilitaire.ChiffreLettre.convertRealToString(e.getDuree()), 2));
                de.setIdqualification(e.check(e.getCategorie_qualificationlib(), 10));
                de.setMontant(e.check((e.getMontant() == 0 ? "" : utilitaire.Utilitaire.formaterAr(e.getMontant())), 4));
                de.setMontantlettre(e.check((e.getMontant() == 0 ? "" : utilitaire.ChiffreLettre.convertRealToStringDevise(e.getMontant(), "Ariary")), 10));
                de.setTypecontrat(e.getTypeContrat());
                de.setDatecontrat(e.getDateContrat());
                de.setIdcontrat_avant(e.getIdcontrat_avant());

                System.out.println("Id===>"+de.getId());                
                System.out.println("Nom===>"+de.getNom());
                System.out.println("Prenom===>"+de.getPrenom());
                System.out.println("Sexe===>"+de.getSexe());
                System.out.println("Genre===>"+de.getGenre());
                System.out.println("Nom===>"+de.getNom());
                System.out.println("Matricule===>"+de.getMatricule());
                System.out.println("Naissance===>"+de.getDate_naissance());
                System.out.println("Lieu_naissance_commune===>"+de.getLieu_naissance_commune());
                System.out.println("Adresse===>"+de.getAdresse());
                System.out.println("Numero_Cin===>"+de.getNumero_cin());
                System.out.println("Date_Cin===>"+de.getDate_cin());
                System.out.println("DateEmbauche===>"+de.getDateembauche());
                System.out.println("IdcategoriePaie===>"+de.getIdcategorie_paie());
                System.out.println("IdFonction===>"+de.getIdfonction());
                System.out.println("Duree===>"+de.getDuree());
                System.out.println("IdQualification===>"+de.getIdqualification());
                System.out.println("Montant===>"+de.getMontant());
                System.out.println("MontantLettre===>"+de.getMontantlettre());
                System.out.println("Type contrat===>"+de.getTypecontrat());
                System.out.println("Date contrat===>"+de.getDatecontrat()); 
                System.out.println("Id contrat avant===>"+de.getIdcontrat_avant()); 
                data.add(de);
            }
        return data; 
    }

/*
      
        param.put("montant", e.check((e.getMontant() == 0 ? "" : utilitaire.Utilitaire.formaterAr(e.getMontant())), 4));
        param.put("montantlettre", e.check((e.getMontant() == 0 ? "" : utilitaire.ChiffreLettre.convertRealToStringDevise(e.getMontant(), "Ariary")), 10));
  */      

}
