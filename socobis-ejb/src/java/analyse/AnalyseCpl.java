package analyse;

public class AnalyseCpl extends Analyse {
    
    String idfabricationlib;
    String idcriterelib;
    String idresponsablelib;
    String etatlib;

    public AnalyseCpl() throws Exception {
        super.setNomTable("ANALYSECPL");
    }

    public String getIdfabricationlib() {
        return idfabricationlib;
    }

    public void setIdfabricationlib(String idfabricationlib) {
        this.idfabricationlib = idfabricationlib;
    }

    public String getIdcriterelib() {
        return idcriterelib;
    }

    public void setIdcriterelib(String idcriterelib) {
        this.idcriterelib = idcriterelib;
    }

    public String getIdresponsablelib() {
        return idresponsablelib;
    }

    public void setIdresponsablelib(String idresponsablelib) {
        this.idresponsablelib = idresponsablelib;
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    

}
