/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.log;

import bean.CGenUtil;
import bean.ClassMAPTable;
import paie.conge.CongeDroit;
import paie.conge.CongeMoins;
import paie.conge.CongeReste;
import paie.archive.PaieArchive;
import paie.employe.PaieInfoPersonnel;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.Arrays;

/**
 *
 * @author Finaritra
 */

public class LogPersonnel extends ClassMAPTable {

    private String id, permis_conduire, chemin_permis, remarque, id_pers, nom, prenom, idDirection;
    private Date date_naissance;
    private String sexe, numero_cin;
    private Date date_cin, date_dupl_cin;
    private String nationalite, adresse, fokotany, acte_naissance, direction, service,serviceLib;
    private String cheminImage, matricule;
    private int refUser;
    private String mere, pere, idCivilite;
    private String nomDusage;
    private String adresse2;
    private String commune;
    private String pays;
    private double distance;
    private  String bu;
    String image;
    String congeReste;
    String permissionReste;
    private String mode_paiement,modePaiementLib;
    private String code_banque,banque_numero_compte,banque_compte_cle,code_agence_banque;

    public String getCongeReste() {
        return congeReste;
    }

    public void setCongeReste(String congeReste) {
        this.congeReste = congeReste;
    }

    public String getPermissionReste() {
        return permissionReste;
    }

    public void setPermissionReste(String permissionReste) {
        this.permissionReste = permissionReste;
    }

    public String getBu() {
        return bu;
    }

    public void setBu(String bu) {
        this.bu = bu;
    }

    public double getDistance() {
        return distance;
    }

    public void setDistance(double distance) {
        this.distance = distance;
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

    public int getRefUser() {
        return refUser;
    }

    public void setRefUser(int refUser) {
        this.refUser = refUser;
    }

    @Override
    public String toString() {
        return "LogPersonnel{" + "id=" + id + ", permis_conduire=" + permis_conduire + ", chemin_permis=" + chemin_permis + ", remarque=" + remarque + ", id_pers=" + id_pers + ", nom=" + nom + ", prenom=" + prenom + ", date_naissance=" + date_naissance + ", sexe=" + sexe + ", numero_cin=" + numero_cin + ", date_cin=" + date_cin + ", date_dupl_cin=" + date_dupl_cin + ", nationalite=" + nationalite + ", adresse=" + adresse + ", fokotany=" + fokotany + ", acte_naissance=" + acte_naissance + ", direction=" + direction + ", service=" + service + '}';
    }

    @Override
    public boolean getEstIndexable() {
        return true;
    }

    public LogPersonnel() {
        super.setNomTable("log_personnel");
    }

    public LogPersonnel(String nom, String prenom, String direction, String service) throws Exception {
        super.setNomTable("log_personnel");
        this.setNom(nom);
        this.setPrenom(prenom);
        this.setDirection(direction);
        this.setService(service);
    }

    public LogPersonnel(String permis_conduire, String chemin_permis, String remarque, String id_pers, String nom, String prenom, Date date_naissance, String sexe, String numero_cin, Date date_cin, Date date_dupl_cin, String nationalite, String adresse, String fokotany, String acte_naissance, String direction, String service, String cheminImage) throws Exception {
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
        this.setCheminImage(cheminImage);
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

    private void controlCIN(Connection c) throws Exception {
        LogPersonnel[] tmp = (LogPersonnel[]) CGenUtil.rechercher(new LogPersonnel(), null, null, c, String.format(" and numero_cin = '%s'", this.getNumero_cin()));

        if(tmp != null && tmp.length > 0) {
            throw new Exception("Doublon de CIN");
        }
    }

    @Override
    public void controler(Connection c) throws Exception {
        controlCIN(c);
    }

    @Override
    public void construirePK(Connection c) throws Exception {

        this.preparePk("PRS", "GET_SEQ_LOGPERSONNEL");
        this.setId(makePK(c));
    }

    @Override
    public int updateObject(String u, Connection c) throws Exception {
        LogPersonnel base = new LogPersonnel();
        base.setId(this.getId());
        LogPersonnel[] log = (LogPersonnel[]) CGenUtil.rechercher(base,null,null,c,"");
        if(log!=null && log.length>0){
            LogPersonnel toUpdate = log[0];
            if(this.getService()!=null && !this.getService().trim().isEmpty()){
                toUpdate.setService(this.getService());
            }
            return toUpdate.updateToTableWithHisto(u,c);
        }
        else {
            throw new Exception("Aucun employe trouve pour l'id "+this.getId());
        }
    }

    public String getCheminImage() {
        return cheminImage;
    }

    public void setCheminImage(String cheminImage) {
        this.cheminImage = cheminImage;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdDirection() {
        return idDirection;
    }

    public void setIdDirection(String idDirection) {
        this.idDirection = idDirection;
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

    public String getNomDusage() {
        return nomDusage;
    }

    public void setNomDusage(String nomDusage) {
        this.nomDusage = nomDusage;
    }

    public void setId_pers(String id_pers) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.id_pers = id_pers;
            return;
        }
        if (id_pers == null || id_pers.compareToIgnoreCase(" ") == 0) {
            throw new Exception("Personne invalide car vide");
        }
        this.id_pers = id_pers;
    }

    public String getNom() {
        //return Utilitaire.champNull(nom);
        return nom;
    }

    public String[] getPersonnelsByDirection(String idDirection, Connection c) throws Exception {
        try {
            if(c == null) {
                c = new UtilDB().GetConn();
            }
            LogPersonnel log = new LogPersonnel();
            log.setNomTable("LOG_PERSONNEL_V2");
            log.setIdDirection(idDirection);
            LogPersonnel[] resultats = (LogPersonnel[]) CGenUtil.rechercher(log, null, null, c, "");
            String[] ids = Arrays.stream(resultats)
                    .map(LogPersonnel::getId)
                    .toArray(String[]::new);
            return ids;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void setNom(String nom) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.nom = nom;
            return;
        }
        if (nom == null || nom.compareToIgnoreCase("") == 0) {
            throw new Exception("Nom invalide car vide");
        }
        this.nom = nom;
    }

    public String getPrenom() {
        //return Utilitaire.champNull(prenom);
        return prenom;
    }

    public void setPrenom(String prenom) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.prenom = prenom;
            return;
        }
        if (prenom == null || prenom.compareToIgnoreCase(" ") == 0) {
            throw new Exception("Prenom invalide car vide");
        }
        this.prenom = prenom;
    }

    public Date getDate_naissance() {
        return date_naissance;
    }

    public void setDate_naissance(Date date_naissance) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.date_naissance = date_naissance;
            return;
        }
//        if (date_naissance == null) {
//            throw new Exception("Date de naissance invalide car vide");
//        }
//        if (date_naissance.compareTo(Utilitaire.dateDuJourSql()) > 0) {
//            throw new Exception("Date de naissance Invalide doit etre inferieur a date du jour");
//        }
//        if (Utilitaire.calculeAge(date_naissance) < 18) {
//            throw new Exception("Date de naissance invalide : age doit etre sup&eacute;rieur a 18 ans");
//        }
        this.date_naissance = date_naissance;
    }

    public String getSexe() {
        return Utilitaire.champNull(sexe);
    }

    public void setSexe(String sexe) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.sexe = sexe;
            return;
        }
        //if(sexe.length()>1) throw new Exception("Sexe Invalide"); comment? satria ho an'ireo mappage libell?
        this.sexe = sexe;
    }

    public String getNumero_cin() {
        //return Utilitaire.champNull(numero_cin);
        return numero_cin;
    }

    public void setNumero_cin(String numero_cin) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.numero_cin = numero_cin;
            return;
        }
        if (numero_cin == null || numero_cin.compareToIgnoreCase(" ") == 0) {
            throw new Exception("Le num\\u00E9ro CIN ou Num\\u00E9ro de passeport ne peut pas \\u00EAtre vide");
        }

        this.numero_cin = numero_cin;
    }

    public Date getDate_cin() {
        return date_cin;
    }

    public void setDate_cin(Date date_cin) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.date_cin = date_cin;
            return;
        }
//        if (date_cin == null) {
//            throw new Exception("Date de delivrance CIN invalide car vide");
//        }
//        if (date_cin.compareTo(Utilitaire.dateDuJourSql()) > 0) {
//            throw new Exception("Date de delivrance CIN Invalide doit etre inferieur a date du jour");
//        }
        this.date_cin = date_cin;
    }

    public Date getDate_dupl_cin() {
        return date_dupl_cin;
    }

    public void setDate_dupl_cin(Date date_dupl_cin) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.date_dupl_cin = date_dupl_cin;
            return;
        }
        if (date_dupl_cin == null) {
            return;
        }
        if (date_dupl_cin.compareTo(date_cin) < 0) {
            throw new Exception("Date duplicata CIN inferieur a Date CIN");
        }
        this.date_dupl_cin = date_dupl_cin;
    }

    public String getNationalite() {
        return Utilitaire.champNull(nationalite);
    }

    public void setNationalite(String nationalite) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.nationalite = nationalite;
            return;
        }
        if (nationalite == null || nationalite.compareToIgnoreCase(" ") == 0) {
            throw new Exception("Nationalite invalide car vide");
        }
        this.nationalite = nationalite;
    }

    public String getAdresse() {
        return Utilitaire.champNull(adresse);
    }

    public void setAdresse(String adresse) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.adresse = adresse;
            return;
        }
        if (adresse == null || adresse.compareToIgnoreCase(" ") == 0) {
            throw new Exception("Adresse invalide car vide");
        }
        this.adresse = adresse;
    }

    public String getFokotany() {
        return Utilitaire.champNull(fokotany);
    }

    public void setFokotany(String fokotany) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.fokotany = fokotany;
            return;
        }
        if (fokotany == null || fokotany.compareToIgnoreCase(" ") == 0) {
            throw new Exception("Fokotany invalide car vide");
        }
        this.fokotany = fokotany;
    }

    public String getActe_naissance() {
        return Utilitaire.champNull(acte_naissance);
    }

    public void setActe_naissance(String acte_naissance) {
        this.acte_naissance = acte_naissance;
    }

    public String getDirection() {
        //return Utilitaire.champNull(direction);
        return direction;
    }

    public void setDirection(String direction) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.direction = direction;
            return;
        }
//        if (direction == "") {
//            throw new Exception("Champ Direction manquant");
//        }
        this.direction = direction;
    }

    public String getService() {
        //return Utilitaire.champNull(service);
        return service;
    }

    public void setService(String service) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.service = service;
            return;
        }
        if (service == null || service.compareToIgnoreCase(" ") == 0) {
            throw new Exception("Service invalide car vide");
        }
        this.service = service;
    }

    public double getResteConge(int annee,Connection c) throws Exception{
        boolean cree = false;
        try{
            if(c==null){
                cree=true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            CongeReste reste = new CongeReste();
            reste.setAnnee(annee);
            reste.setIdpersonnel(this.getId_pers());
            CongeReste[] restes = (CongeReste[]) CGenUtil.rechercher(reste, null, null, c, "");
            if(restes.length==0)
                throw new Exception("Aucun droit de cong� disponible pour ce personnel : "+this.getId_pers());
            else
                return restes[0].getReste();

        }catch(Exception e){
            c.rollback();
            e.printStackTrace();
            throw e;
        }finally{
            if(cree)
                c.close();
        }
    }

    public double getArchiveAnnee(int annee,Connection c) throws Exception{
        boolean cree = false;
        try{
            if(c==null){
                cree=true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }

            double sarchive = 0;

            PaieArchive pa = new PaieArchive();
            pa.setAnnee(annee);
            pa.setIdPersonnel(this.getId_pers());
            PaieArchive[] archive = (PaieArchive[]) CGenUtil.rechercher(pa, null, null, c, "");
            if(archive.length==0)
                throw new Exception("Archive du personnel non trouv�e.");
            for(int i=0;i<archive.length;i++)
                sarchive+=archive[i].getMontant();

            return sarchive;

        }catch(Exception e){
            c.rollback();
            e.printStackTrace();
            throw e;
        }finally{
            if(cree)
                c.close();
        }
    }

    public double getDroitConge(int annee,Connection c) throws Exception{
        boolean cree = false;
        try{
            if(c==null){
                cree=true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }

            CongeDroit cg = new CongeDroit();
            cg.setAnnee(annee);
            cg.setIdpersonnel(this.getId_pers());
            CongeDroit[] cgs = (CongeDroit[]) CGenUtil.rechercher(cg, null, null, c, "");
            if(cgs.length==0)
                throw new Exception("Aucun droit de conge pour l'ann�e "+annee);

            double droit = 0;
            for(int i=0;i<cgs.length;i++)
                droit+=cgs[0].getNombre();

            return droit;
        }catch(Exception e){
            c.rollback();
            e.printStackTrace();
            throw e;
        }finally{
            if(cree)
                c.close();
        }
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }


    //NY ID,IDPERSONNEL, ANNEE, ARY MONTANT NO MIASA ATO
    //AO ANATY MONTANT NO MISY NY SOLDE CONGE
    public PaieArchive[] getDroitCongeVrai(int mois,int annee,Connection c)throws Exception{
        PaieArchive[] retour = null;
        int indice = 0;
        try{
            if(c==null){
                c = new UtilDB().GetConn();
                indice = 1;
            }
            if(mois == 0 && annee==0){
                mois = Utilitaire.getMois(Utilitaire.dateDuJourSql());
                System.out.println("mois = " + mois);
                annee = Integer.valueOf(Utilitaire.getAnneeEnCours()).intValue();
                System.out.println("annee = " + annee);
            }
            String req = "select idpersonnel id, idpersonnel, annee, (count(*) * 2.5) as montant\n" +
                    "from vue_sal_brut_personnel\n" +
                    "where idpersonnel = '"+getId()+"' and to_date(ANNEE||'-'||mois,'yyyy-mm')>=to_date('2019-1','yyyy-mm') and to_date(ANNEE||'-'||mois,'yyyy-mm')<to_date('"+annee+"-"+mois+"','yyyy-mm')\n" +
                    "group by idpersonnel, annee order by annee asc";
            retour = (PaieArchive[])CGenUtil.rechercher(new PaieArchive(), req, c);

        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }finally{
            if(c!=null && indice == 1)c.close();
        }
        return retour;
    }


    @Override
    public String getValColLibelle() {
        return this.getNom() + ";" + this.getPrenom() + ";" + this.getService();
    }


    @Override
    public String[] getMotCles() {
        String[] motCles={"id","nom", "prenom", "matricule"};
//        String[] motCles={"id","nom", "prenom"};
        return motCles;
    }


    public String getMotClesString(LogPersonnel log) throws Exception {
        LogPersonnel ls = this.find(log);
        String[] motCles = this.getMotCles();
        StringBuilder result = new StringBuilder();
        Class<?> clazz = ls.getClass();
        for (String motCle : motCles) {
            String getterName = "get" + motCle.substring(0, 1).toUpperCase() + motCle.substring(1);
            Method getter = clazz.getMethod(getterName);
            Object value = getter.invoke(ls);
            result.append(value != null ? value.toString() : "").append(" ");
        }
        return result.toString().trim();
    }


    public PaieArchive[] getSoldeConge(int mois,int annee,Connection c)throws Exception{
        PaieArchive[] retour = null;
        int indice = 0;
        try{
            if(c==null){
                c = new UtilDB().GetConn();
                indice = 1;
            }
            PaieArchive[] droit = getDroitCongeVrai(mois,annee, c);
            if(droit.length>0){

            }
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }finally{
            if(c!=null && indice == 1)c.close();
        }
        return retour;
    }

    public LogPersonnel find( LogPersonnel obj ) throws Exception{
        LogPersonnel[] ls = null ;
        try {
            ls =(LogPersonnel[]) CGenUtil.rechercher(obj, null, null, null, "  " );
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

    public CongeDroit[] getSoldeConge(Connection c)throws Exception{
        CongeDroit[] retour = null;
        int indice = 0;
        try{
            if(c==null){
                c = new UtilDB().GetConn();
                indice = 1;
            }
            CongeDroit temp = new CongeDroit();
            temp.setNomTable("droitdeconge_parpersonne");
            retour = (CongeDroit[])CGenUtil.rechercher(temp, null, null, c, " and idpersonnel = '"+getId()+"'");
            CongeMoins moins = new CongeMoins();
            moins.setNomTable("congemoins_groupe");
            CongeMoins[] tabCongeMoins = (CongeMoins[])CGenUtil.rechercher(moins, null, null, c, " and idpersonnel = '"+getId()+"'");
            if(retour.length>0){
                if(tabCongeMoins.length>0){
                    double nbMiala = tabCongeMoins[0].getConge();
                    double reste = 0;
                    for(int i = 0;i<retour.length;i++){
                        if(retour[i].getConge()>0){
                            reste = retour[i].getConge() - nbMiala;//-8,5
                        }

                        if(reste<0){
                            retour[i].setConge(0);
                            nbMiala = reste*-1;
                        }else{
                            retour[i].setConge(reste);
                            nbMiala = 0;
                        }
                    }
                }
            }
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }finally{
            if(indice == 1 && c!=null)c.close();
        }
        return retour;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getPere() {
        return pere;
    }

    public void setPere(String pere) {
        this.pere = pere;
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


    public java.util.Map<String, Integer> getPersonnelParTrancheAge(String iddepartement, Connection c) throws Exception {
        boolean cree = false;
        java.util.Map<String, Integer> result = new java.util.LinkedHashMap<>();
        try {
            if(c == null) {
                cree = true;
                c = new UtilDB().GetConn();
            }
            StringBuilder query = new StringBuilder(
                    "SELECT " +
                            "    CASE " +
                            "        WHEN age BETWEEN 18 AND 30 THEN '18-30' " +
                            "        WHEN age BETWEEN 31 AND 40 THEN '31-40' " +
                            "        WHEN age BETWEEN 41 AND 50 THEN '41-50' " +
                            "        WHEN age BETWEEN 51 AND 60 THEN '51-60' " +
                            "        WHEN age BETWEEN 61 AND 70 THEN '61-70' " +
                            "        ELSE 'HORS_TRANCHE' " +
                            "    END AS TRANCHE_AGE, " +
                            "    COUNT(*) AS NOMBRE " +
                            "FROM ( " +
                            "    SELECT " +
                            "        IDDEPARTEMENT, " +
                            "        TRUNC(MONTHS_BETWEEN(SYSDATE, DATE_NAISSANCE)/12) AS age " +
                            "    FROM LOG_PERSONNEL_V2 " +
                            "    WHERE DATE_NAISSANCE IS NOT NULL "
            );
            if(iddepartement != null && !iddepartement.isEmpty()) {
                query.append(" AND IDDEPARTEMENT = '").append(iddepartement).append("' ");
            }
            query.append(
                    ") " +
                            "GROUP BY " +
                            "    CASE " +
                            "        WHEN age BETWEEN 18 AND 30 THEN '18-30' " +
                            "        WHEN age BETWEEN 31 AND 40 THEN '31-40' " +
                            "        WHEN age BETWEEN 41 AND 50 THEN '41-50' " +
                            "        WHEN age BETWEEN 51 AND 60 THEN '51-60' " +
                            "        WHEN age BETWEEN 61 AND 70 THEN '61-70' " +
                            "        ELSE 'HORS_TRANCHE' " +
                            "    END " +
                            "ORDER BY " +
                            "    CASE TRANCHE_AGE " +
                            "        WHEN '18-30' THEN 1 " +
                            "        WHEN '31-40' THEN 2 " +
                            "        WHEN '41-50' THEN 3 " +
                            "        WHEN '51-60' THEN 4 " +
                            "        WHEN '61-70' THEN 5 " +
                            "        ELSE 6 " +
                            "    END"
            );
            System.out.println("REQUETE TRANCHE AGE = " + query.toString());
            java.sql.PreparedStatement pstmt = c.prepareStatement(query.toString());
            java.sql.ResultSet rs = pstmt.executeQuery();
            while(rs.next()) {
                String tranche = rs.getString("TRANCHE_AGE");
                int nombre = rs.getInt("NOMBRE");
                result.put(tranche, nombre);
            }
            rs.close();
            pstmt.close();
        } catch(Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if(cree && c != null) {
                c.close();
            }
        }
        return result;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getModePaiementLib() {
        return modePaiementLib;
    }

    public void setModePaiementLib(String modePaiementLib) {
        this.modePaiementLib = modePaiementLib;
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

    public String getBanque_compte_cle() {
        return banque_compte_cle;
    }

    public void setBanque_compte_cle(String banque_compte_cle) {
        this.banque_compte_cle = banque_compte_cle;
    }

    public String getBanque_numero_compte() {
        return banque_numero_compte;
    }

    public void setBanque_numero_compte(String banque_numero_compte) {
        this.banque_numero_compte = banque_numero_compte;
    }

    public String getCode_banque() {
        return code_banque;
    }

    public void setCode_banque(String code_banque) {
        this.code_banque = code_banque;
    }

    public String getServiceLib() {
        return serviceLib;
    }

    public void setServiceLib(String serviceLib) {
        this.serviceLib = serviceLib;
    }
}

