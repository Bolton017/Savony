package personnel;

import bean.CGenUtil;
import utilitaire.UtilDB;

import java.sql.Connection;

public class PersonnelIdUser extends Personnel{
    private String refUser;

    public String getRefUser() {
        return refUser;
    }

    public void setRefUser(String refUser) {
        this.refUser = refUser;
    }

    public PersonnelIdUser() {
        this.setNomTable("LOG_PERSONNEL_VEN");
    }

    public PersonnelIdUser getByIdUser(String u, Connection c) throws Exception{
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            PersonnelIdUser p = new PersonnelIdUser();

            PersonnelIdUser[] tab = (PersonnelIdUser[]) CGenUtil.rechercher(new PersonnelIdUser(),null,null,c, " and refUser = '"+u+"'");
            if (tab != null && tab.length > 0) {
                return tab[0];
            }
            return null;
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
}
