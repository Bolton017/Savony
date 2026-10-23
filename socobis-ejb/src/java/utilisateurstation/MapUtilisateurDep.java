package utilisateurstation;

import historique.MapUtilisateur;
import utilitaire.Utilitaire;

public class MapUtilisateurDep extends MapUtilisateur {

    private String idService;

    public MapUtilisateurDep(String loginus, String pwdus, String nomus, String adrus, String telus, String idrol, String idService) throws Exception {
        super.setNomTable("utilisateur");
        this.setRefuser(Utilitaire.getMaxSeq("getsequtilisateur"));
        this.setLoginuser(loginus);
        this.setPwduser(pwdus);
        this.setNomuser(nomus);
        this.setAdruser(adrus);
        this.setTeluser(telus);
        this.setIdrole(idrol);
        this.setIdService(idService);
        super.setNomTable("utilisateur");
    }

    public String getIdService() {
        return idService;
    }

    public void setIdService(String idService) {
        this.idService = idService;
    }
}
