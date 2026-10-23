/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.avancement;

import bean.ClassEtat;
import paie.employe.PaieInfoPersonnel;

import java.sql.Connection;
import java.sql.Date;

/**
 *
 * @author ACER
 */
public class PaieAvancement extends ClassEtat {
    private String id,id_logpers,direction,service,idfonction,idcategorie,ctg,remarque,refdecision,motif;
    private Date date_application, datedecision;
    private int echelon,indicegrade,indice_fonctionnel, indice_ct;
    private String classee,matricule_patron,statut,droit_hs, mode_paiement, code_banque;
    private int vehiculee;
    private String region;
    private String contrat;
    private String typePersonnel;
    private int dureeContrat;
    private String modePaiement;

    public PaieAvancement(){
        super.setNomTable("PAIE_AVANCEMENT");
    }

    public PaieAvancement(String id_logpers, String direction, String service, String idfonction, String idcategorie, String remarque, String refdecision, Date date_application, Date datedecision, int echelon, int indicegrade, int indice_fonctionnel, String classee, String matricule_patron, String statut, String droit_hs) {
        this.id_logpers = id_logpers;
        this.direction = direction;
        this.service = service;
        this.idfonction = idfonction;
        this.idcategorie = idcategorie;
        this.remarque = remarque;
        this.refdecision = refdecision;
        this.date_application = date_application;
        this.datedecision = datedecision;
        this.echelon = echelon;
        this.indicegrade = indicegrade;
        this.indice_fonctionnel = indice_fonctionnel;
        this.classee = classee;
        this.matricule_patron = matricule_patron;
        this.statut = statut;
        this.droit_hs = droit_hs;
        super.setNomTable("PAIE_AVANCEMENT");
    }
    
    
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("RNAT", "getSeqPaie_avancement");
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

    public String getContrat() {
        return contrat;
    }

    public void setContrat(String contrat) {
        this.contrat = contrat;
    }

    public String getTypePersonnel() {
        return typePersonnel;
    }

    public void setTypePersonnel(String typePersonnel) {
        this.typePersonnel = typePersonnel;
    }

    public int getDureeContrat() {
        return dureeContrat;
    }

    public void setDureeContrat(int dureeContrat) {
        this.dureeContrat = dureeContrat;
    }

    public String getModePaiement() {
        return modePaiement;
    }

    public void setModePaiement(String modePaiement) {
        this.modePaiement = modePaiement;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public int getIndicegrade() {
        return indicegrade;
    }

    public String getCtg() {
        return ctg;
    }

    public void setCtg(String ctg) {
        this.ctg = ctg;
    }

    public void setIndicegrade(int indicegrade) {
        this.indicegrade = indicegrade;
    }

    public int getIndice_fonctionnel() {
        return indice_fonctionnel;
    }

    public void setIndice_fonctionnel(int indicefonctionnel) {
        this.indice_fonctionnel = indicefonctionnel;
    }

    public String getClassee() {
        return classee;
    }

    public void setClassee(String classee) {
        this.classee = classee;
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
    
    
    public void setId(String id) {
        this.id = id;
    }

    public void setId_logpers(String id_logpers) throws Exception {
        if ((getMode().compareToIgnoreCase("modif") == 0) && id_logpers.isEmpty()) {
	    throw new Exception("Champ personnel obligatoire");
        }
        this.id_logpers = id_logpers;
    }

    @Override
    public void setService(String service) {
        this.service = service;
    }

    public void setIdfonction(String idfonction) {
        this.idfonction = idfonction;
    }

    public void setIdcategorie(String idcategorie) throws Exception{
        try{
            if(getMode().compareTo("modif")!=0){
                this.idcategorie = idcategorie;
                return;
            }
            if(idcategorie==null || idcategorie.compareToIgnoreCase("")==0){
                throw new Exception("Categorie obligatoire");
            }
            this.idcategorie = idcategorie;
        }catch(Exception e){
        
        }
    }

    @Override
    public PaieAvancement validerObject(String u, Connection c) {
        PaieInfoPersonnel paie = new PaieInfoPersonnel();
        try {
            paie.setNomTable("PAIE_INFO_PERSONNEL");
            paie.setId(this.getId_logpers());

            if (this.getIdfonction() != null) {
                paie.setIdfonction(this.getIdfonction());
            }

            if (this.getService() != null) {
                paie.setService(this.getService());
            }

            if (this.getCode_banque() != null) {
                paie.setCode_agence_banque(this.getCode_banque());
            }

            if (this.getModePaiement() != null) {
                paie.setMode_paiement(this.getModePaiement());
            }

            if (this.getTypePersonnel() != null) {
                paie.setCategorie_qualificationlib(this.getTypePersonnel());
            }

            paie.updateToTableWithHisto(u, c);
            super.validerObject(u, c);
        } catch(Exception e){
            e.printStackTrace();
        }

        return this;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public void setRefdecision(String refdecision) {
        this.refdecision = refdecision;
    }

    public void setDate_application(Date date_application) throws Exception {
        if ((getMode().compareToIgnoreCase("modif") == 0) && date_application == null) {
	    throw new Exception("Champ date application obligatoire");
        }
        this.date_application = date_application;
    }

    public void setDatedecision(Date datedecision) {
        this.datedecision = datedecision;
    }

    public void setEchelon(int echelon) throws Exception{
        if(getMode().compareTo("modif")!=0)
        {
            this.echelon = echelon;
            return;
        }
        //if(echelon<0) throw new Exception("Echelon invalide car <0");
        this.echelon = echelon;
    }

    @Override
    public void setDirection(String direction) {
        this.direction = direction;
    }
    
    @Override
    public String getDirection(){
        return this.direction;
    }

    public String getId() {
        return id;
    }

    public String getId_logpers() {
        return id_logpers;
    }

    @Override
    public String getService() {
        return service;
    }

    public String getIdfonction() {
        return idfonction;
    }

    public String getIdcategorie() {
        return idcategorie;
    }

    public String getRemarque() {
        return remarque;
    }

    public String getRefdecision() {
        return refdecision;
    }

    public Date getDate_application() {
        return date_application;
    }

    public Date getDatedecision() {
        return datedecision;
    }

    public int getEchelon() {
        return echelon;
    }

    public int getVehiculee() {
        return vehiculee;
    }

    public void setVehiculee(int vehiculee) {
        this.vehiculee = vehiculee;
    }
    
    public String getMotif() {
        return motif;
    }

    public void setMotif(String motif) throws Exception {
        if ((getMode().compareToIgnoreCase("modif") == 0) && motif.isEmpty()) {
	    throw new Exception("Champ motif obligatoire");
        }
        this.motif = motif;
    }

    public int getIndice_ct() {
        return indice_ct;
    }

    public void setIndice_ct(int indice_ct) {
        this.indice_ct = indice_ct;
    }

    public String getMode_paiement() {
        return mode_paiement;
    }

    public void setMode_paiement(String mode_paiement) {
        this.mode_paiement = mode_paiement;
    }

    public String getCode_banque() {
        return code_banque;
    }

    public void setCode_banque(String code_banque) {
        this.code_banque = code_banque;
    }
    
}
