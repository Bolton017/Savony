/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package paie.employe;

/**
 *
 * @author nouta
 */
public class EnfantPersonnelCpl extends EnfantPersonnel{
    private String nomPersonnel , matricule;
    private int age;
    private String genreLib;

    public String getGenreLib() {
        return genreLib;
    }

    public void setGenreLib(String genreLib) {
        this.genreLib = genreLib;
    }

    public EnfantPersonnelCpl() {
        super.setNomTable("ENFANTPERSONNEL_CPL");
    }
    
    public String getNomPersonnel() {
        return nomPersonnel;
    }

    public void setNomPersonnel(String nomPersonnel) {
        this.nomPersonnel = nomPersonnel;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

  
    
    
}
