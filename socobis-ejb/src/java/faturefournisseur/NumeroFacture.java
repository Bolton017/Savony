package faturefournisseur;
import java.sql.Date;
import bean.ClassMAPTable;
import bean.ClassEtat;

public class NumeroFacture extends ClassEtat {
    private String prefixe;
    private Date date_facture;
    private String nextnum;

    @Override
    public String getAttributIDName() {
        return "prefixe";
    }

    public String getTuppleID() {
        return prefixe;
    }
    public NumeroFacture() {
        this.setNomTable("v_next_facture_fournisseur");
    }

    public String getPrefixe() {
        return prefixe;
    }

    public void setPrefixe(String prefixe) {
        this.prefixe = prefixe;
    }

    public Date getDate_facture() {
        return date_facture;
    }

    public void setDate_facture(Date date_facture) {
        this.date_facture = date_facture;
    }

    public String getNextnum() {
        return nextnum;
    }

    public void setNextnum(String nextnum) {
        this.nextnum = nextnum;
    }

    

}
