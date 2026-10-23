/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.log;

import bean.ClassMAPTable;

/**
 *
 * @author Axel
 */
public class Fiche_poste   extends ClassMAPTable {
    private String id,idposte,tache1,tache2,tache3,tache4,tache5,idorganigramme,condition_travail,competence,idformation_diplome,idfonction,remarque ;

    public Fiche_poste() {
        setNomTable("fiche_poste");
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

    public String getIdposte() {
        return idposte;
    }

    public void setIdposte(String idposte) {
        this.idposte = idposte;
    }

    public String getTache1() {
        return tache1;
    }

    public void setTache1(String tache1) {
        this.tache1 = tache1;
    }

    public String getTache2() {
        return tache2;
    }

    public void setTache2(String tache2) {
        this.tache2 = tache2;
    }

    public String getTache3() {
        return tache3;
    }

    public void setTache3(String tache3) {
        this.tache3 = tache3;
    }

    public String getTache4() {
        return tache4;
    }

    public void setTache4(String tache4) {
        this.tache4 = tache4;
    }

    public String getTache5() {
        return tache5;
    }

    public void setTache5(String tache5) {
        this.tache5 = tache5;
    }

    public String getIdorganigramme() {
        return idorganigramme;
    }

    public void setIdorganigramme(String idorganigramme) {
        this.idorganigramme = idorganigramme;
    }

    public String getCondition_travail() {
        return condition_travail;
    }

    public void setCondition_travail(String condition_travail) {
        this.condition_travail = condition_travail;
    }

    public String getCompetence() {
        return competence;
    }

    public void setCompetence(String competence) {
        this.competence = competence;
    }

    public String getIdformation_diplome() {
        return idformation_diplome;
    }

    public void setIdformation_diplome(String idformation_diplome) {
        this.idformation_diplome = idformation_diplome;
    }

    public String getIdfonction() {
        return idfonction;
    }

    public void setIdfonction(String idfonction) {
        this.idfonction = idfonction;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }
    
    
    
    
}
