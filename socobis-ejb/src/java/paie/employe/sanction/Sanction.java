package paie.employe.sanction;

import bean.ClassEtat;

import java.sql.Connection;
import java.sql.Date;


public class Sanction extends ClassEtat {
    private String id, idPersonne, matricule, typeFaute, descriptionFaute, idRegleEnfreinte, typeSanction, libelleFaute, sanction;
    private Date daty, dateDebut;
    private double duree;
    private int niveauSanction;
    private int etat;

    public Sanction() {
        this.setNomTable("SANCTION");
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
    public void construirePK(Connection c) throws Exception {
        this.preparePk("STC", "GET_SEQ_SANCTION");
        this.setId(makePK(c));
    }

    public int getEtat() { return this.etat; }

    public void setEtat(int etat)  { this.etat = etat; }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdPersonne() {
        return idPersonne;
    }

    public void setIdPersonne(String idPersonne) {
        this.idPersonne = idPersonne;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getTypeFaute() {
        return typeFaute;
    }

    public void setTypeFaute(String typeFaute) {
        this.typeFaute = typeFaute;
    }

    public String getDescriptionFaute() {
        return descriptionFaute;
    }

    public void setDescriptionFaute(String descriptionFaute) {
        this.descriptionFaute = descriptionFaute;
    }

    public String getIdRegleEnfreinte() {
        return idRegleEnfreinte;
    }

    public void setIdRegleEnfreinte(String idRegleEnfreinte) {
        this.idRegleEnfreinte = idRegleEnfreinte;
    }

    public String getTypeSanction() {
        return typeSanction;
    }

    public void setTypeSanction(String typeSanction) {
        this.typeSanction = typeSanction;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public Date getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(Date dateDebut) {
        this.dateDebut = dateDebut;
    }

    public double getDuree() {
        return duree;
    }

    public void setDuree(double duree) {
        this.duree = duree;
    }

    public int getNiveauSanction() {
        return niveauSanction;
    }

    public void setNiveauSanction(int niveauSanction) {
        this.niveauSanction = niveauSanction;
    }

    public String getLibelleFaute() {
        return libelleFaute;
    }

    public void setLibelleFaute(String libelleFaute) {
        this.libelleFaute = libelleFaute;
    }

    public String getSanction() {
        return sanction;
    }

    public void setSanction(String sanction) {
        this.sanction = sanction;
    }
}
