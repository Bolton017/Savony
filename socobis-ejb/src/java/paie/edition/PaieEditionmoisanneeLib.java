/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.edition;
import java.sql.Date;

/**
 *
 * @author Sanda
 */
public class PaieEditionmoisanneeLib extends PaieEditionmoisannee{
    private String mois_string;
    private Date datedebut;
    private Date datefin;
    private String categorie;

    public PaieEditionmoisanneeLib() throws Exception{
        super.setNomTable("PAIE_EDITIONMOISANNEE_LIB_3");
    }
    public String getMois_string() {
        return mois_string;
    }

    public void setMois_string(String mois_string) {
        this.mois_string = mois_string;
    }

    public Date getDatedebut() {
        return datedebut;
    }
    public void setDatedebut(Date datedebut) {
        this.datedebut = datedebut;
    }
    public Date getDatefin() {
        return datefin;
    }
    public void setDatefin(Date datefin) {
        this.datefin = datefin;
    }
    public String getCategorie() {
        return categorie;
    }
    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }
    
}
