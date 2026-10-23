package calculBesoin;

import java.sql.Connection;
import java.sql.Date;

public class CalculBesoinLib extends CalculBesoin {
    private String idMagasinLib;

    public CalculBesoinLib() throws Exception {
        this.setNomTable("CALCULBESOINLIB");
    }

    public String getIdMagasinLib() {
        return idMagasinLib;
    }

    public void setIdMagasinLib(String idMagasinLib) {
        this.idMagasinLib = idMagasinLib;
    }
}

