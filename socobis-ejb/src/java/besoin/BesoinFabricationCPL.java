/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package besoin;

/**
 *
 * @author dell
 */
public class BesoinFabricationCPL extends BesoinFabrication{
    String moisLib;

    public BesoinFabricationCPL() throws Exception {
        this.setNomTable("BESOINFABRICATIONCPL");
    }

    public String getMoisLib() {
        return moisLib;
    }

    public void setMoisLib(String moisLib) {
        this.moisLib = moisLib;
    }
    
    
}
