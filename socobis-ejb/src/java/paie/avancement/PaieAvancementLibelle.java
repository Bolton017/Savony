/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.avancement;

import bean.CGenUtil;
import bean.ClassEtat;
import java.sql.Date;

/**
 *
 * @author ACER
 */
public class PaieAvancementLibelle extends ClassEtat {
   private String id,id_logpers,matricule,idpers,direction,service,idfonction,idcategorie,ctg,remarque,refdecision,motif,idmotif;
    private Date date_application, datedecision;
    private int echelon,indicegrade,indice_fonctionnel, indice_ct;
    private String classee,matricule_patron,statut,droit_hs,sexe;
    private int vehiculee;
    private String fonctionLib;
    
    public PaieAvancementLibelle(){
        super.setNomTable("PAIE_AVANCEMENT_LIBELLE2");
    }
    
    public PaieAvancementLibelle [] findbymotif( PaieAvancementLibelle obj ) throws Exception{
        PaieAvancementLibelle[] ls = null ;
        PaieAvancementLibelle tt=new PaieAvancementLibelle();
        tt.setNomTable("paie_avancement_libelle5");
        try {
            ls =(PaieAvancementLibelle[]) CGenUtil.rechercher(tt, null, null, null, "  and idmotif='"+obj.getIdmotif()+"' and idpers='"+obj.getIdpers()+"'" );

        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("Erreur recherche PaieAvancement=>"+e.getMessage()); 
        }
        return ls ;
    }
    
    @Override
    public String getTuppleID() {
        return id; 
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getId_logpers() {
        return id_logpers;
    }

    public void setId_logpers(String id_logpers) {
        this.id_logpers = id_logpers;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getIdpers() {
        return idpers;
    }

    public void setIdpers(String idpers) {
        this.idpers = idpers;
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

    public String getIdcategorie() {
        return idcategorie;
    }

    public void setIdcategorie(String idcategorie) {
        this.idcategorie = idcategorie;
    }

    public String getCtg() {
        return ctg;
    }

    public void setCtg(String ctg) {
        this.ctg = ctg;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getRefdecision() {
        return refdecision;
    }

    public void setRefdecision(String refdecision) {
        this.refdecision = refdecision;
    }

    public String getMotif() {
        return motif;
    }

    public void setMotif(String motif) {
        this.motif = motif;
    }

    public Date getDate_application() {
        return date_application;
    }

    public void setDate_application(Date date_application) {
        this.date_application = date_application;
    }

    public Date getDatedecision() {
        return datedecision;
    }

    public void setDatedecision(Date datedecision) {
        this.datedecision = datedecision;
    }

    public int getEchelon() {
        return echelon;
    }

    public void setEchelon(int echelon) {
        this.echelon = echelon;
    }

    public int getIndicegrade() {
        return indicegrade;
    }

    public void setIndicegrade(int indicegrade) {
        this.indicegrade = indicegrade;
    }

    public int getIndice_fonctionnel() {
        return indice_fonctionnel;
    }

    public void setIndice_fonctionnel(int indice_fonctionnel) {
        this.indice_fonctionnel = indice_fonctionnel;
    }

    public int getIndice_ct() {
        return indice_ct;
    }

    public void setIndice_ct(int indice_ct) {
        this.indice_ct = indice_ct;
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

    public int getVehiculee() {
        return vehiculee;
    }

    public void setVehiculee(int vehiculee) {
        this.vehiculee = vehiculee;
    }

    public String getIdmotif() {
        return idmotif;
    }

    public void setIdmotif(String idmotif) {
        this.idmotif = idmotif;
    }

    public String getSexe() {
        return sexe;
    }

    public void setSexe(String sexe) {
        this.sexe = sexe;
    } 
    public String getFonctionLib() {
        return fonctionLib;
    }
    public void setFonctionLib(String fonctionLib) {
        this.fonctionLib = fonctionLib;
    } 
}
