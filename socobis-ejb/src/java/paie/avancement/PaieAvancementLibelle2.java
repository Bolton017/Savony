package paie.avancement;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author hp
 */
public class PaieAvancementLibelle2 extends PaieAvancementLibelle {
    private String vehiculee_str;
    private String regionlib;
    private String code_banque, fonctionLib;

    public String getCode_banque() {
        return code_banque;
    }

    public void setCode_banque(String code_banque) {
        this.code_banque = code_banque;
    }

    public String getRegionlib() {
        return regionlib;
    }

    public void setRegionlib(String region) {
        this.regionlib = region;
    }

    public PaieAvancementLibelle2() {
        this.setNomTable("PAIE_AVANCEMENT_LIBELLE3");
    }

    /**
     * @return the vehiculee_str
     */
    public String getVehiculee_str() {
        return vehiculee_str;
    }

    /**
     * @param vehiculee_str the vehiculee_str to set
     */
    public void setVehiculee_str(String vehiculee_str) {
        this.vehiculee_str = vehiculee_str;
    }

    @Override
    public String getFonctionLib() {
        return fonctionLib;
    }

    @Override
    public void setFonctionLib(String fonctionLib) {
        this.fonctionLib = fonctionLib;
    }
}

