package fabrication;

public class CommentaireOFLib extends CommentaireOF {

    String nomUser;

    public CommentaireOFLib() throws Exception {
        this.setNomTable("COMMENTAIREOF_LIB");
    }

    public String getNomUser() {
        return nomUser;
    }

    public void setNomUser(String nomUser) {
        this.nomUser = nomUser;
    }

}
