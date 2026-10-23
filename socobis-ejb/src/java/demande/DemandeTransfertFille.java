package demande;
import stock.*;
import java.sql.Connection;
public class DemandeTransfertFille extends TransfertStockDetails{
    private String idDemandeTransfert;
    public DemandeTransfertFille()throws Exception{
        this.setNomTable("demandetransfertfille");
        this.setLiaisonMere("idDemandeTransfert");
        this.setNomClasseMere("demande.DemandeTransfert");
    }
//
//    @Override
//    public String getNomClasseMere() {
//        return "demande.DemandeTransfert";
//    }c
//
//    @Override
//    public String getLiaisonMere() {
//        return "idDemandeTransfert";
//    }

    public String getIdDemandeTransfert() {
        return idDemandeTransfert;
    }

    @Override
    public void setCompteLocalisationArrivee(String compteLocalisationArrivee) throws Exception {
//        super.setCompteLocalisationArrivee(compteLocalisationArrivee);
    }

    @Override
    public void setCompteLocalisationDepart(String compteLocalisationDepart) throws Exception {
//        super.setCompteLocalisationDepart(compteLocalisationDepart);
    }

    public void setIdDemandeTransfert(String idDemandeTransfert) {
        this.idDemandeTransfert = idDemandeTransfert;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("DTFF", "getSeqdemandetransfertfille");
        this.setId(makePK(c));
    }
    @Override
    public void controler(Connection c) throws Exception {
        if(this.getIdProduit()==null || this.getIdProduit().isEmpty()){
            throw new Exception("Le produit est obligatoire");
        }
    }
    @Override
    public String getNomClasseMere() {
        return "demande.DemandeTransfert";
    }
    @Override
    public String getLiaisonMere() {
        return "idDemandeTransfert";
    }
}
