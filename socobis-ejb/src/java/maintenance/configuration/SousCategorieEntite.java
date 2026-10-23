package maintenance.configuration;

import bean.TypeObjet;

import java.sql.Connection;

public class SousCategorieEntite extends TypeObjet {
    private String idEntite;
    private String idEntiteLib;

    public SousCategorieEntite() {
        this.setNomTable("SousCategorieEntite");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("SCE", "getseqSouscategorieentite");
        this.setId(makePK(c));
    }

    public String getIdEntite() {
        return idEntite;
    }

    public void setIdEntite(String idEntite) {
        this.idEntite = idEntite;
    }

    public String getIdEntiteLib() {
        return idEntiteLib;
    }

    public void setIdEntiteLib(String idEntiteLib) {
        this.idEntiteLib = idEntiteLib;
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","val","idEntiteLib"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] valMotCles={"id","val","idEntiteLib"};
        return valMotCles;
    }
}
