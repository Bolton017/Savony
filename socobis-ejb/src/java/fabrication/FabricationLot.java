
package fabrication;

import java.sql.Date;


public class FabricationLot extends FabricationCpl{
    private String idLot , remarqueLot;
    private Date datyLot;

    public FabricationLot() throws Exception {
        this.setNomTable("fabricationLot");
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
