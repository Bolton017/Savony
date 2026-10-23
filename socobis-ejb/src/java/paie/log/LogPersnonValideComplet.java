/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.log;

/**
 *
 * @author ASUS
 */
public class LogPersnonValideComplet extends LogPersonnelNonValide{
    private String matricule,sexe,personnelid,typedebauche,passationlib,etatLib;

    public String getTypedebauche() {
        return typedebauche;
    }

    public void setTypedebauche(String TYPEDEBAUCHE) {
        this.typedebauche = TYPEDEBAUCHE;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }

    public LogPersnonValideComplet() {
        this.setMode("select");
        this.setNomTable("LOG_PERSNON_VALIDE_Complet");
    }

    public String getPersonnelid() {
        return personnelid;
    }

    public void setPersonnelid(String personnelid) {
        this.personnelid = personnelid;
    }

    public String getSexe() {
        return sexe;
    }

    public void setSexe(String sexe) {
        this.sexe = sexe;
    }
    
    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getPassationlib() {
        return passationlib;
    }

    public void setPassationlib(String passationlib) {
        this.passationlib = passationlib;
    }
}
