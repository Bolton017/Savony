package budget;

import bean.CGenUtil;
import historique.MapUtilisateur;
import utilitaire.UtilDB;

import java.sql.Connection;

public class UtilisateurService extends MapUtilisateur {
    private String idService;
    private String refuserStr;
    private String idDepartement;

    public String getRefuserStr() {
        return refuserStr;
    }

    public void setRefuserStr(String refuserStr) {
        this.refuserStr = refuserStr;
    }

    public String getIdDepartement() {
        return idDepartement;
    }

    public void setIdDepartement(String idDepartement) {
        this.idDepartement = idDepartement;
    }

    public UtilisateurService() {
        this.setNomTable("UTILISATEURSTR");
    }

    public String getIdService() {
        return idService;
    }

    public void setIdService(String idService) {
        this.idService = idService;
    }

    public UtilisateurService getUserService(Connection c) throws Exception {
        boolean canClose = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                canClose = true;
            }
            UtilisateurService u = new UtilisateurService();
            UtilisateurService[] users = (UtilisateurService[]) CGenUtil.rechercher(u,null,null,c," AND refuser = "+this.getRefuser());
            if (users.length > 0) {
                return users[0];
            }
            return null;
        } finally {
            if (canClose) c.close();
        }
    }

    @Override
    public String[] getMotCles() {
        return new String[]{"refuser","nomuser"};
    }

    @Override
    public String[] getValMotCles() {
        return new String[]{"nomuser"};
    }

    public String getAttributIDName() {
        return "refuserStr";
    }

    public String getTuppleID() {
        return this.refuserStr;
    }

}
