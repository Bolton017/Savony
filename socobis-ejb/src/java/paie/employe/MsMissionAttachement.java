/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package paie.employe;

import bean.ClassMAPTable;
import java.sql.Connection;

/**
 *
 * @author user
 */
public class MsMissionAttachement extends ClassMAPTable{

    private String id;
    private String idmission;
    private String idobjet;
    private String lien;
    private String description;

    public MsMissionAttachement(){
        this.setNomTable("MS_MISSION_ATTACHEMENT");
    }

    public MsMissionAttachement(String id,String idmission,String idobjet,String lien) {
        this.setId(id);
        this.setIdmission(idmission);
        this.setIdobjet(idobjet);
        this.setLien(lien);
        this.setNomTable("MS_MISSION_ATTACHEMENT");
    }

    public MsMissionAttachement(String idmission,String idobjet,String lien) {
        this.setIdmission(idmission);
        this.setIdobjet(idobjet);
        this.setLien(lien);
        this.setNomTable("MS_MISSION_ATTACHEMENT");
    }

    @Override
    public String getTuppleID() {
        return this.getId();
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("MMA", "GETSEQMISSIONATTACHEMENT");
        this.setId(makePK(c));
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdmission() {
        return idmission;
    }

    public void setIdmission(String idmission) {
        this.idmission = idmission;
    }

    public String getIdobjet() {
        return idobjet;
    }

    public void setIdobjet(String idobjet) {
        this.idobjet = idobjet;
    }

    public String getLien() {
        return lien;
    }

    public void setLien(String lien) {
        this.lien = lien;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }


}
