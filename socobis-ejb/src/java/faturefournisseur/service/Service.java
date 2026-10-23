package faturefournisseur.service;

import bean.CGenUtil;
import bean.ClassMAPTable;
import utilitaire.UtilDB;

import java.sql.Connection;

public class Service extends ClassMAPTable {
    private String id;
    private String libelle;
    private String code;
    private String compte;
    private String departement;

    public Service() {
        this.setNomTable("SERVICE");
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

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getCompte() {
        return compte;
    }

    public void setCompte(String compte) {
        this.compte = compte;
    }

    public String getDepartement() {
        return departement;
    }

    public void setDepartement(String departement) {
        this.departement = departement;
    }

    public Service[] servicesImpliques(String source, String cible) throws Exception {
        Connection c = new UtilDB().GetConn();
        Service[] services = new Service[2];
        if (source!=null){
            this.setCompte(source);
            services[0] = (Service) CGenUtil.rechercher(this, null, null, c, "")[0];
            services[1] = services[0];
        }
        if (cible != null) {
            assert source != null;
            if (!source.equalsIgnoreCase(cible)) {
                this.setCompte(cible);
                services[1] = (Service) CGenUtil.rechercher(this, null, null, c, "")[0];
            }
        }
        return services;
    }
}
