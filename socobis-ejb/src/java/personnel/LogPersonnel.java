/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package personnel;

import bean.ClassMAPTable;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;

/**
 *
 * @author Jetta
 */
public class LogPersonnel extends ClassMAPTable {

    private String id, permis_conduire, chemin_permis, remarque, id_pers, nom, prenom;
    private Date date_naissance;
    private String sexe, numero_cin;
    private Date date_cin, date_dupl_cin;
    private String nationalite, adresse, fokotany, acte_naissance, direction, service;

    public LogPersonnel() {
        super.setNomTable("log_personnel");
    }

    public LogPersonnel(String permis_conduire, String chemin_permis, String remarque, String id_pers, String nom, String prenom, Date date_naissance, String sexe, String numero_cin, Date date_cin, Date date_dupl_cin, String nationalite, String adresse, String fokotany, String acte_naissance, String direction, String service) throws Exception {
        super.setNomTable("log_personnel");
        this.setPermis_conduire(permis_conduire);
        this.setChemin_permis(chemin_permis);
        this.setRemarque(remarque);
        this.setId_pers(id_pers);
        this.setNom(nom);
        this.setPrenom(prenom);
        this.setDate_naissance(date_naissance);
        this.setSexe(sexe);
        this.setNumero_cin(numero_cin);
        this.setDate_cin(date_cin);
        this.setDate_dupl_cin(date_dupl_cin);
        this.setNationalite(nationalite);
        this.setAdresse(adresse);
        this.setFokotany(fokotany);
        this.setActe_naissance(acte_naissance);
        this.setDirection(direction);
        this.setService(service);
    }
     public LogPersonnel(String id, String permis_conduire, String chemin_permis, String remarque, String id_pers, String nom, String prenom, Date date_naissance, String sexe, String numero_cin, Date date_cin, Date date_dupl_cin, String nationalite, String adresse, String fokotany, String acte_naissance, String direction, String service) throws Exception {
        super.setNomTable("log_personnel");
        this.setId(id);
        this.setPermis_conduire(permis_conduire);
        this.setChemin_permis(chemin_permis);
        this.setRemarque(remarque);
        this.setId_pers(id_pers);
        this.setNom(nom);
        this.setPrenom(prenom);
        this.setDate_naissance(date_naissance);
        this.setSexe(sexe);
        this.setNumero_cin(numero_cin);
        this.setDate_cin(date_cin);
        this.setDate_dupl_cin(date_dupl_cin);
        this.setNationalite(nationalite);
        this.setAdresse(adresse);
        this.setFokotany(fokotany);
        this.setActe_naissance(acte_naissance);
        this.setDirection(direction);
        this.setService(service);
    }
    @Override
     public void construirePK(Connection c) throws Exception{
         
            this.preparePk("PRS","GETSEQLOGPERSONNEL");
            this.setId(makePK(c));
    }
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPermis_conduire() {
        return Utilitaire.champNull(permis_conduire);
    }

    public void setPermis_conduire(String permis_conduire) {
        this.permis_conduire = permis_conduire;
    }

    public String getChemin_permis() {
        return Utilitaire.champNull(chemin_permis);
    }

    public void setChemin_permis(String chemin_permis) {
        this.chemin_permis = chemin_permis;
    }

    public String getRemarque() {
        return Utilitaire.champNull(remarque);
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getId_pers() {
        return Utilitaire.champNull(id_pers);
    }

    public void setId_pers(String id_pers) throws Exception {
        if(getMode().compareTo("modif")!=0)
        {
            this.id_pers = id_pers;
            return;
        }
        if(id_pers==null || id_pers.compareToIgnoreCase(" ")==0)throw new Exception ("Personne invalide car vide");
        this.id_pers = id_pers;
    }

    public String getNom() {
        return Utilitaire.champNull(nom);
    }

    public void setNom(String nom)throws Exception {
        if(getMode().compareTo("modif")!=0)
        {
            this.nom = nom;
            return;
        }
        if(nom==null || nom.compareToIgnoreCase("")==0)throw new Exception ("Nom invalide car vide");
        this.nom = nom;
    }

    public String getPrenom() {
        return Utilitaire.champNull(prenom);
    }

    public void setPrenom(String prenom) throws Exception{
        if(getMode().compareTo("modif")!=0)
        {
            this.prenom = prenom;
            return;
        }
        if(prenom==null || prenom.compareToIgnoreCase(" ")==0)throw new Exception ("Prenom invalide car vide");
        this.prenom = prenom;
    }

    public Date getDate_naissance() {
        return date_naissance;
    }

    public void setDate_naissance(Date date_naissance) throws Exception {
        if(getMode().compareTo("modif")!=0)
        {
            this.date_naissance = date_naissance;
            return;
        }
        if(date_naissance==null)throw new Exception("Date de naissance invalide car vide");
        if(date_naissance.compareTo(Utilitaire.dateDuJourSql())>0) throw new Exception("Date de naissance Invalide doit etre inferieur a date du jour");
        if(Utilitaire.calculeAge(date_naissance) < 18) throw new Exception("Date de naissance invalide : �ge doit �tre sup�rieur a 18 ans");
        this.date_naissance = date_naissance;
    }

    public String getSexe() {
        return Utilitaire.champNull(sexe);
    }

    public void setSexe(String sexe) throws Exception {
        if(getMode().compareTo("modif")!=0)
        {
            this.sexe = sexe;
            return;
        }
        //if(sexe.length()>1) throw new Exception("Sexe Invalide"); comment� satria ho an'ireo mappage libell�
        this.sexe = sexe;
    }

    public String getNumero_cin() {
        return Utilitaire.champNull(numero_cin);
    }

    public void setNumero_cin(String numero_cin) throws Exception {
        if(getMode().compareTo("modif")!=0)
        {
            this.numero_cin = numero_cin;
            return;
        }
        if(numero_cin==null || numero_cin.compareToIgnoreCase(" ")==0)throw new Exception ("CIN invalide car vide");
        if(numero_cin.length()!=12) throw new Exception("Numero CIN doit comporter 12 caracteres");
        this.numero_cin = numero_cin;
    }

    public Date getDate_cin() {
        return date_cin;
    }

    public void setDate_cin(Date date_cin)throws Exception {
        if(getMode().compareTo("modif")!=0)
        {
            this.date_cin = date_cin;
            return;
        }
        if(date_cin==null)throw new Exception("Date de delivrance CIN invalide car vide");
        if(date_cin.compareTo(Utilitaire.dateDuJourSql())>0) throw new Exception("Date de delivrance CIN Invalide doit etre inferieur a date du jour");
        this.date_cin = date_cin;
    }

    public Date getDate_dupl_cin() {
        return date_dupl_cin;
    }

    public void setDate_dupl_cin(Date date_dupl_cin) throws Exception {
        if(getMode().compareTo("modif")!=0)
        {
            this.date_dupl_cin = date_dupl_cin;
            return;
        }
        if(date_dupl_cin==null)
        {
            return;
        }
        if(date_dupl_cin.compareTo(date_cin)<0) throw new Exception("Date duplicata CIN inferieur a Date CIN");
        this.date_dupl_cin = date_dupl_cin;
    }

    public String getNationalite() {
        return Utilitaire.champNull(nationalite);
    }

    public void setNationalite(String nationalite) throws Exception{
        if(getMode().compareTo("modif")!=0)
        {
            this.nationalite = nationalite;
            return;
        }
        if(nationalite==null || nationalite.compareToIgnoreCase(" ")==0)throw new Exception ("Nationalite invalide car vide");
        this.nationalite = nationalite;
    }

    public String getAdresse() {
        return Utilitaire.champNull(adresse);
    }

    public void setAdresse(String adresse)throws Exception {
        if(getMode().compareTo("modif")!=0)
        {
            this.adresse = adresse;
            return;
        }
        if(adresse==null || adresse.compareToIgnoreCase(" ")==0)throw new Exception ("Adresse invalide car vide");
        this.adresse = adresse;
    }

    public String getFokotany() {
        return Utilitaire.champNull(fokotany);
    }

    public void setFokotany(String fokotany) throws Exception{
        if(getMode().compareTo("modif")!=0)
        {
            this.fokotany = fokotany;
            return;
        }
        if(fokotany==null || fokotany.compareToIgnoreCase(" ")==0)throw new Exception ("Fokotany invalide car vide");
        this.fokotany = fokotany;
    }

    public String getActe_naissance() {
        return Utilitaire.champNull(acte_naissance);
    }

    public void setActe_naissance(String acte_naissance) {
        this.acte_naissance = acte_naissance;
    }

    public String getDirection() {
        return Utilitaire.champNull(direction);
    }

    public void setDirection(String direction) throws Exception {
        if(getMode().compareTo("modif")!=0)
        {
            this.direction = direction;
            return;
        }
        if(direction=="") throw new Exception("Champ Direction manquant");
        this.direction = direction;
    }

    public String getService() {
        return Utilitaire.champNull(service);
    }

    public void setService(String service) throws Exception {
        if(getMode().compareTo("modif")!=0)
        {
            this.service = service;
            return;
        }
        if(service==null || service.compareToIgnoreCase(" ")==0)throw new Exception ("Service invalide car vide");
        this.service = service;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    
    @Override
    public String[] getMotCles() {
        // TODO Auto-generated method stub
        String[] motCles={"id","nom","prenom"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
	String[] motCles={"id", "nom", "prenom"};
        return motCles;
    }

}
