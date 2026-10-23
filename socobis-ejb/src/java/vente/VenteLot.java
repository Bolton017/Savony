/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vente;
import java.sql.Date;

public class VenteLot extends VenteLib{
        private  String idLot  , remarqueLot;
        private Date datyLot;
    public VenteLot() {
        this.setNomTable("ventelot");
    }

    public String getIdLot() {
        return idLot;
    }

    public void setIdLot(String idLot) {
        this.idLot = idLot;
    }

    public String getRemarqueLot() {
        return remarqueLot;
    }

    public void setRemarqueLot(String remarqueLot) {
        this.remarqueLot = remarqueLot;
    }

    public Date getDatyLot() {
        return datyLot;
    }

    public void setDatyLot(Date datyLot) {
        this.datyLot = datyLot;
    }
    
    
}
