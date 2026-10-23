package rapport.mapping;

import bean.ClassMAPTable;

import java.sql.Date;

public class CrDateFormu extends ClassMAPTable {

    private Date daty;

    public CrDateFormu(){
        this.setNomTable("CRDATEFORMU");
    }

    @Override
    public String getTuppleID() {
        return null;
    }

    @Override
    public String getAttributIDName() {
        return null;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }
}
