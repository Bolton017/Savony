/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package paie.employe;

import java.sql.Date;
import bean.ClassMAPTable;
import java.sql.Connection;

/**
 *
 * @author nouta
 */
public class EnfantPersonnel extends ClassMAPTable{
    private String id,idPersonnel,nom;
    private Date dateNaissance;
    private int genre;

    public EnfantPersonnel() {
        super.setNomTable("ENFANTPERSONNEL");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdPersonnel() {
        return idPersonnel;
    }

    public void setIdPersonnel(String idPersonnel) {
        this.idPersonnel = idPersonnel;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public Date getDateNaissance() {
        return dateNaissance;
    }

    public void setDateNaissance(Date dateNaissance) {
        this.dateNaissance = dateNaissance;
    }

    public int getGenre() {
        return genre;
    }

    public void setGenre(int genre) {
        this.genre = genre;
    }
    
    @Override
    public void construirePK(Connection c) throws Exception {
	this.preparePk("ENP", "getseqenfantpers");
	this.setId(makePK(c));
    }
    @Override
    public String getTuppleID() {
      return  this.getId();
    }

    @Override
    public String getAttributIDName() {
     return "id";   
    }
}
