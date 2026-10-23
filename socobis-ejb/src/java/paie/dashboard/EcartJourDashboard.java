package paie.dashboard;

import bean.ClassMAPTable;
import paie.MaterniteLib;

public class EcartJourDashboard extends MaterniteLib {
    int ecartdepartjours, ecartretourjours;

    public EcartJourDashboard(){
        super.setNomTable("V_DASH_MATERNITE_ECART_DATE");
    }

    public int getEcartdepartjours() {
        return ecartdepartjours;
    }

    public void setEcartdepartjours(int ecartdepartjours) {
        this.ecartdepartjours = ecartdepartjours;
    }

    public int getEcartretourjours() {
        return ecartretourjours;
    }

    public void setEcartretourjours(int ecartretourjours) {
        this.ecartretourjours = ecartretourjours;
    }
}
