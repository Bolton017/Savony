/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.node;

import bean.CGenUtil;
import java.sql.Connection;

/**
 *
 * @author Sambatra Rakotondrainibe
 */

public class NodePersonnelFin extends Node{
    private String nom,prenom,direction,service,code_dr,matricule,indicegrade,indice_fonctionnel,categorieval,numero_cnaps,numero_ostie,temporaire,etat;
    private int idtemporaire,rang;

 
    public int getIdtemporaire() {
        return idtemporaire;
    }

    public void setIdtemporaire(int idtemporaire) {
        this.idtemporaire = idtemporaire;
    }

    public int getRang() {
        return rang;
    }

    public void setRang(int rang) {
        this.rang = rang;
    }

    public NodePersonnelFin [] findall(Connection c) throws Exception{
        NodePersonnelFin[] result = (NodePersonnelFin[])CGenUtil.rechercher(new NodePersonnelFin(), null, null, c, "");
        if(result.length > 0) return result;
        return null;
    }

    public NodePersonnelFin() {
        this.setNomTable("NODE_PERSONNEL_FIN");
    }

    public NodePersonnelFin findpremier( NodePersonnelFin obj ) throws Exception{
        NodePersonnelFin[] ls = null ;
        try {
            ls =(NodePersonnelFin[]) CGenUtil.rechercher(obj, null, null, null, "  and rang=1" );
            if( ls.length == 0 ){
                throw new Exception("Secretaire non trouver!"); 
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ls[0] ;
    }
    public NodePersonnelFin(String nom, String prenom, String direction, String service, String code_dr,
            String matricule, String indicegrade, String indice_fonctionnel, String categorieval, String numero_cnaps,
            String numero_ostie, String temporaire, String etat) {
                this.setNomTable("NODE_PERSONNEL_FIN");
        this.nom = nom;
        this.prenom = prenom;
        this.direction = direction;
        this.service = service;
        this.code_dr = code_dr;
        this.matricule = matricule;
        this.indicegrade = indicegrade;
        this.indice_fonctionnel = indice_fonctionnel;
        this.categorieval = categorieval;
        this.numero_cnaps = numero_cnaps;
        this.numero_ostie = numero_ostie;
        this.temporaire = temporaire;
        this.etat = etat;
    }


    public NodePersonnelFin(String id, String idpers, String parent, String nom, String prenom, String direction,
            String service, String code_dr, String matricule, String indicegrade, String indice_fonctionnel,
            String categorieval, String numero_cnaps, String numero_ostie, String temporaire, String etat) {
        super(id, idpers, parent);
        this.nom = nom;
        this.prenom = prenom;
        this.direction = direction;
        this.service = service;
        this.code_dr = code_dr;
        this.matricule = matricule;
        this.indicegrade = indicegrade;
        this.indice_fonctionnel = indice_fonctionnel;
        this.categorieval = categorieval;
        this.numero_cnaps = numero_cnaps;
        this.numero_ostie = numero_ostie;
        this.temporaire = temporaire;
        this.etat = etat;
        this.setNomTable("NODE_PERSONNEL_FIN");
    }


    public String getNom() {
        return nom;
    }


    public void setNom(String nom) {
        this.nom = nom;
    }


    public String getPrenom() {
        return prenom;
    }


    public void setPrenom(String prenom) {
        this.prenom = prenom;
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


    public String getCode_dr() {
        return code_dr;
    }


    public void setCode_dr(String code_dr) {
        this.code_dr = code_dr;
    }


    public String getMatricule() {
        return matricule;
    }


    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }


    public String getIndicegrade() {
        return indicegrade;
    }


    public void setIndicegrade(String indicegrade) {
        this.indicegrade = indicegrade;
    }


    public String getIndice_fonctionnel() {
        return indice_fonctionnel;
    }


    public void setIndice_fonctionnel(String indice_fonctionnel) {
        this.indice_fonctionnel = indice_fonctionnel;
    }


    public String getCategorieval() {
        return categorieval;
    }


    public void setCategorieval(String categorieval) {
        this.categorieval = categorieval;
    }


    public String getNumero_cnaps() {
        return numero_cnaps;
    }


    public void setNumero_cnaps(String numero_cnaps) {
        this.numero_cnaps = numero_cnaps;
    }


    public String getNumero_ostie() {
        return numero_ostie;
    }


    public void setNumero_ostie(String numero_ostie) {
        this.numero_ostie = numero_ostie;
    }


    public String getTemporaire() {
        return temporaire;
    }


    public void setTemporaire(String temporaire) {
        this.temporaire = temporaire;
    }


    public String getEtat() {
        return etat;
    }


    public void setEtat(String etat) {
        this.etat = etat;
    }

    
}
