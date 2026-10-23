package rapport.mapping;

public class CRContentFilleLib extends CRContentFille{

    private String colSommeLib;
    private String colDateLib;

    public CRContentFilleLib() throws Exception {
        this.setNomTable("CRCONTENTFILLELIB");
    }

    public String getColSommeLib() {
        return colSommeLib;
    }

    public void setColSommeLib(String colSommeLib) {
        this.colSommeLib = colSommeLib;
    }

    public String getColDateLib() {
        return colDateLib;
    }

    public void setColDateLib(String colDateLib) {
        this.colDateLib = colDateLib;
    }
}
