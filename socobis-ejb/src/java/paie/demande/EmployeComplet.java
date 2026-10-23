package paie.demande;

import bean.CGenUtil;
import bean.ClassEtat;
import java.sql.Date;
import utils.ConstantePaie;

/**
 *
 * @author Safidimahefa Romario
 */
public class EmployeComplet extends ClassEtat {

    private String id, nom, prenom, id_pers,idgroupefonction;
    private Date date_naissance;
    private String lieu_naissance_commune, sexe, numero_cin,idservice,idfonct;
    private Date date_cin, date_dupl_cin, date_dernierpromo;
    private int vehiculee, periode_essai;
    private String lieu_delivrance_cin, adresse, fokotany, nationalite, acte_naissance, situation_matrimonial, idconjoint, initiale, matricule, direction, service, idfonction, ctg, idcategorie, classee, indicegrade, indice_fonctionnel, matricule_patron, statut, mode_paiement, code_agence_banque, banque_code, banque_compte_cle, permis_conduire, chemin_permis, remarque, banque_numero_compte, cturgence_nom_prenom, cturgence_telephone1, cturgence_telephone2, cturgence_telephone3, echelon;
    private String droit_hs, numero_cnaps, numero_ostie;
    private double heurejournalier, heurehebdomadaire, heuremensuel, hmax;
    private int temporaire, nbenfant, total_enfants;
    private Date dateembauche, datesaisie;
    private double salaire_de_base;
    private String travauxpenibles;
    private double taux_horaire;
    private String idetathierarchie,hierarchie,nomsup;
    private String idsup,refuser;
    private int etatvisa, etatannule;

    private String idRole;
    private int rang;

    private int refusersup;
    private String idDepartement;
    
    public int getRefusersup() {
        return refusersup;
    }

    public void setRefusersup(int refusersup) {
        this.refusersup = refusersup;
    }

    public String getIdRole() {
        return idRole;
    }

    public void setIdRole(String idRole) {
        this.idRole = idRole;
    }

    public int getRang() {
        return rang;
    }

    public void setRang(int rang) {
        this.rang = rang;
    }

    public EmployeComplet() {
        super.setNomTable("EMPLOYE_COMPLET_NOU");
    }

    public EmployeComplet(String id, String nom, String prenom, Date date_naissance, String lieu_naissance_commune, String sexe, String numero_cin, Date date_cin, Date date_dupl_cin, String lieu_delivrance_cin, String adresse, String fokotany, String nationalite, String acte_naissance, String situation_matrimonial, String idconjoint, String initiale, String matricule, String direction, String service, String idfonction, String idcategorie, String classee, String indicegrade, String indice_fonctionnel, String matricule_patron, String statut, String mode_paiement, String code_agence_banque, String banque_compte_cle, String banque_numero_compte, String permis_conduire, String cturgence_nom_prenom, String cturgence_telephone1, String cturgence_telephone2, String cturgence_telephone3, Date dateembauche, Date datesaisie, int nbr_enfant, int total_enfants) throws Exception {
        super.setNomTable("EMPLOYE_COMPLET_NOU");
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
        this.setTotal_enfants(total_enfants);
    }

    public EmployeComplet(String nom, String prenom, Date date_naissance, String lieu_naissance_commune, String sexe, String numero_cin, Date date_cin, Date date_dupl_cin, String lieu_delivrance_cin, String adresse, String fokotany, String nationalite, String acte_naissance, String situation_matrimonial, String idconjoint, String initiale, String matricule, String direction, String service, String idfonction, String idcategorie, String classee, String indicegrade, String indice_fonctionnel, String matricule_patron, String statut, String mode_paiement, String code_agence_banque, String banque_compte_cle, String banque_numero_compte, String permis_conduire, String cturgence_nom_prenom, String cturgence_telephone1, String cturgence_telephone2, String cturgence_telephone3, Date dateembauche, Date datesaisie, int nbr_enfant, int total_enfants) throws Exception {
        super.setNomTable("EMPLOYE_COMPLET_NOU");
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
        this.setTotal_enfants(total_enfants);
    }

       public String getIdetathierarchie() {
        return idetathierarchie;
    }
      public void setIdetathierarchie(String Idhierarchie) {
        this.idetathierarchie = Idhierarchie; 
    }
    
       public String getIdsup() {
        return idsup;
    }

    public void setIdsup(String idsup) {
        this.idsup = idsup;
    }
    


    public double getTaux_horaire() {
        return taux_horaire;
    }

    public void setTaux_horaire(double taux_horaire) {
        this.taux_horaire = taux_horaire;
    }

    
    
    public double getSalaire_de_base() {
        return salaire_de_base;
    }

    public void setSalaire_de_base(double salaire_de_base) {
        this.salaire_de_base = salaire_de_base;
    }

    public int getPeriode_essai() {
        return periode_essai;
    }

    public void setPeriode_essai(int periode_essai) {
        this.periode_essai = periode_essai;
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

    public String getIdgroupefonction() {
        return idgroupefonction;
    }

    public void setIdgroupefonction(String idgroupefonction) {
        this.idgroupefonction = idgroupefonction;
    }

    public double getHmax() {
        return hmax;
    }

    public void setHmax(double hmax) {
        this.hmax = hmax;
    }

    public void setNom(String nom) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.nom = nom.trim();
            return;
        }
        if (nom == null || nom.trim().compareToIgnoreCase("") == 0) {
            throw new Exception("Nom obligatoire");
        }
        this.nom = nom.trim();
    }

    public String getTravauxpenibles() {
        return travauxpenibles;
    }

    public void setTravauxpenibles(String travauxpenibles) {
        this.travauxpenibles = travauxpenibles;
    }
    
    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getId_pers() {
        return id_pers;
    }

    public void setId_pers(String id_pers) {
        this.id_pers = id_pers;
    }

    public Date getDate_naissance() {
        return date_naissance;
    }

    public void setDate_naissance(Date date_naissance) {
        this.date_naissance = date_naissance;
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

    public void setNumero_cin(String numero_cin) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.numero_cin = numero_cin;
            return;
        }
        if (numero_cin == null || numero_cin.trim().compareToIgnoreCase("") == 0) {
//            throw new Exception("CIN obligatoire");
        }
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

    public String getNationalite() {
        return nationalite;
    }

    public String getIdservice() {
        return idservice;
    }

    public void setIdservice(String idservice) {
        this.idservice = idservice;
    }

    public String getIdfonct() {
        return idfonct;
    }

    public void setIdfonct(String idfonct) {
        this.idfonct = idfonct;
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

    public void setMatricule(String matricule) throws Exception {
        if (getMode().compareTo("modif") != 0) {
           
            this.matricule = matricule;
            return;
        }
        if(matricule.length()>6){
            throw new Exception("Le champ matricule doit contenir au Max 5 caractere");
        }
        if (matricule == null || matricule.trim().compareToIgnoreCase("") == 0) {
            throw new Exception("Matricule obligatoire");
        }
        this.matricule = matricule;
    }

    public String getIdfonction() {
        return idfonction;
    }

    public void setIdfonction(String idfonction) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.idfonction = idfonction;
            return;
        }
        if (idfonction == null || idfonction.trim().compareToIgnoreCase("") == 0) {
            throw new Exception("Fonction obligatoire");
        }
        this.idfonction = idfonction;
    }

    public String getCtg() {
        return ctg;
    }

    public void setCtg(String ctg) {
        this.ctg = ctg;
    }

    public String getIdcategorie() {
        return idcategorie;
    }

    public void setIdcategorie(String idcategorie) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.idcategorie = idcategorie;
            return;
        }
        //if (idcategorie == null || idcategorie.trim().compareToIgnoreCase("") == 0) {
            //throw new Exception("Classification obligatoire");
        //}
        this.idcategorie = idcategorie;
    }

    public String getClassee() {
        return classee;
    }

    public void setClassee(String classee) {
        this.classee = classee;
    }

    public String getIndicegrade() {
        return indicegrade;
    }

    public void setIndicegrade(String indicegrade) throws Exception {
        if(indicegrade==null||indicegrade.compareTo("")==0){
            indicegrade = "0";
        }
        
        if (getMode().compareTo("modif") != 0) {
            this.indicegrade = indicegrade;
            return;
        }
        if (indicegrade == null || indicegrade.trim().compareToIgnoreCase("") == 0) {
            throw new Exception("Indice obligatoire");
        }
        try {
            int indicetemp = Integer.parseInt(indicegrade);
            this.indicegrade = indicegrade;
        } catch (Exception e) {
            throw new Exception("Indice invalide. Doit etre un nombre.");
        }
    }

    public String getIndice_fonctionnel() {
        return indice_fonctionnel;
    }

    public void setIndice_fonctionnel(String indice_fonctionnel) {
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

    public String getEchelon() {
        return echelon;
    }

    public void setEchelon(String echelon) {
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

    public void setNumero_cnaps(String numero_cnaps) throws Exception {
//        if (getMode().compareTo("modif") != 0) {
//            this.numero_cnaps = numero_cnaps;
//            return;
//        }
//        if (numero_cnaps == null || numero_cnaps.trim().compareToIgnoreCase("") == 0) {
//            throw new Exception("CNAPS obligatoire");
//        }
//        try {
//            double cnapstemp = Double.parseDouble(numero_cnaps);
//            this.numero_cnaps = numero_cnaps;
//        } catch (Exception e) {
//            if (numero_cnaps.trim().compareToIgnoreCase("SANS") == 0) {
//                this.numero_cnaps = numero_cnaps;
//            } else {
//                throw new Exception("CNAPS invalide. Saisissez SANS ou un numero CNAPS");
//            }
//        }
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

    public int getTotal_enfants() {
        return total_enfants;
    }

    public void setTotal_enfants(int total_enfants) {
        this.total_enfants = total_enfants;
    }

    public Date getDateembauche() {
        return dateembauche;
    }

    public void setDateembauche(Date dateembauche) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.dateembauche = dateembauche;
            return;
        }
        if (dateembauche == null) {
            throw new Exception("Date embauche obligatoire");
        }
        this.dateembauche = dateembauche;
    }

    public Date getDatesaisie() {
        return datesaisie;
    }

    public void setDatesaisie(Date datesaisie) {
        this.datesaisie = datesaisie;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getRefuser() {
        return refuser;
    }

    public void setRefuser(String refuser) {
        this.refuser = refuser;
    }
     public EmployeComplet getEmployeByRefUser(String refUser) throws Exception{
        EmployeComplet empl = new EmployeComplet();
        empl.setNomTable("employe_complet_nou2");
        EmployeComplet [] employes = (EmployeComplet[])CGenUtil.rechercher(empl, null, null," and refuser ='" +refUser+"'" );
        if(employes.length > 0 ){
            empl = employes[0];
        }else{
            throw new Exception (" Utilisateur non liee a un employe");
        }
            
        return empl ;
    }

    public int getEtatvisa() {
        return etatvisa;
    }

    public void setEtatvisa(int etatvisa) {
        this.etatvisa = etatvisa;
    }

    public int getEtatannule() {
        return etatannule;
    }

    public void setEtatannule(int etatannule) {
        this.etatannule = etatannule;
    }
    
    public EmployeComplet(String nomtable) {
        super.setNomTable(nomtable);
    }
    
    public boolean estRH(){
        return this.getIdetathierarchie()!=null&&this.getIdetathierarchie().compareTo(ConstantePaie.idEtatHierarchieRH)==0;
    }
    
    public boolean estDG(){
        return this.getIdetathierarchie()!=null&&this.getIdetathierarchie().compareTo(ConstantePaie.idEtatHierarchieDG)==0;
    }
    
    public boolean estDE(){
        return this.getIdetathierarchie()!=null&&this.getIdetathierarchie().compareTo(ConstantePaie.idEtatHierarchieDE)==0;
    }
    
    public boolean estEmploye(){
        return this.getIdetathierarchie()!=null&&this.getIdetathierarchie().compareTo(ConstantePaie.idEtatHierarchieEmploye)==0;
    }

    public String getHierarchie() {
        return hierarchie;
    }

    public void setHierarchie(String hierarchie) {
        this.hierarchie = hierarchie;
    }

    public String getNomsup() {
        return nomsup;
    }

    public void setNomsup(String nomsup) {
        this.nomsup = nomsup;
    }

    public String getIdDepartement() {
        return idDepartement;
    }

    public void setIdDepartement(String idDepartement) {
        this.idDepartement = idDepartement;
    }

    public PersonnelAbsence[] getPersonnelAbsenceByIdDepartement(String idDepartement) throws Exception {
        EmployeComplet empl = new EmployeComplet();
        empl.setNomTable("EMPLOYE_COMPLET");
        EmployeComplet[] employe = (EmployeComplet[]) CGenUtil.rechercher(empl, null, null, " AND IDDEPARTEMENT='" + idDepartement + "'");
        PersonnelAbsence[] personnelAbsences = new PersonnelAbsence[employe.length];
        for (int i = 0; i < employe.length; i++) {
            personnelAbsences[i] = new PersonnelAbsence();
            personnelAbsences[i].setIdpersonnel(employe[i].getId());
            personnelAbsences[i].setMatricule(employe[i].getMatricule());
            personnelAbsences[i].setNomPersonnel(employe[i].getNom() + " " + employe[i].getPrenom());
        }
        return personnelAbsences;
    }
}
