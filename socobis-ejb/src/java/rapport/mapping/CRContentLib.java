package rapport.mapping;

public class CRContentLib extends CRContent{

    private String grapheLib;

    public CRContentLib() throws Exception {
        this.setNomTable("CRCONTENTLIB");
    }

    public String getGrapheLib() {
        return grapheLib;
    }

    public void setGrapheLib(String grapheLib) {
        this.grapheLib = grapheLib;
    }
}
