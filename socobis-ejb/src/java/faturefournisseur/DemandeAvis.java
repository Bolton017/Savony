package faturefournisseur;

import bean.ClassMAPTable;
import budget.UtilisateurService;
import historique.MapUtilisateur;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;

public class DemandeAvis extends ClassMAPTable {
    private String id;
    private String demandeur;
    private String personneCible;
    private Date daty;
    private String heure;
    private String idObjet;

    public String getIdObjet() {
        return idObjet;
    }

    public void setIdObjet(String idObjet) {
        this.idObjet = idObjet;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDemandeur() {
        return demandeur;
    }

    public void setDemandeur(String demandeur) {
        this.demandeur = demandeur;
    }

    public String getPersonneCible() {
        return personneCible;
    }

    public void setPersonneCible(String personneCible) {
        this.personneCible = personneCible;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getHeure() {
        return heure;
    }

    public void setHeure(String heure) {
        if((this.getMode().compareToIgnoreCase("modif")==0||this.getMode().compareToIgnoreCase("insert")==0)&&(heure==null||heure.equals(""))){
            heure= Utilitaire.heureCouranteHMS();
        }
        this.heure = heure;
    }

    public DemandeAvis() {
        this.setNomTable("DEMANDEAVIS");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("DAV","GETSEQdemandeAvis");
        this.setId(makePK(c));
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        UtilisateurService user = new UtilisateurService();
        user.setRefuser(u);
        user = user.getUserService(c);
        String lien = "?but=bondecommande/bondecommande-fiche.jsp&id=" + this.getIdObjet();
        this.setMessageNotif("Votre avis est demand&eacute; sur le bon de commande <a href='" + lien + "'>" + this.getIdObjet() + "</a>, &agrave; la demande de "+user.getNomuser()+".");
        this.setNotifAWhere(" AND refuser = '"+this.getPersonneCible()+"'");
        DemandeAvis demandeAvis = (DemandeAvis) super.createObject(u,c);
        demandeAvis.setTuppleId(this.getIdObjet());
        return demandeAvis;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
}

