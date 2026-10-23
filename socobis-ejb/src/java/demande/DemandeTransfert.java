package demande;
import bean.AdminGen;
import bean.CGenUtil;
import fabrication.Of;
import produits.Recette;
import stock.*;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Vector;
import bean.ClassMAPTable;
import historique.MapUtilisateur;

public class DemandeTransfert extends TransfertStock {
    private String categorieingredient, idFabrication;

    public String getCategorieingredient() {
        return categorieingredient;
    }

    public void setCategorieingredient(String categorieingredient) {
        this.categorieingredient = categorieingredient;
    }

    public String getIdFabrication() {
        return idFabrication;
    }

    public void setIdFabrication(String idFabrication) {
        this.idFabrication = idFabrication;
    }

    public DemandeTransfert() throws Exception{
        this.setNomTable("demandetransfert");
        this.setLiaisonFille("idDemandeTransfert");
    }
    @Override
    public String getLiaisonFille() {
        return "idDemandeTransfert";
    }
    @Override
    public String getNomClasseFille() {
        return "demande.DemandeTransfertFille";
    }
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("DT", "getSeqdemandetransfert");
        this.setId(makePK(c));
    }

    @Override
    public String[] getMotCles() {
        return new String[]{"id","designation"};
    }

    @Override
    public String[] getValMotCles() {
        return new String[]{"id","designation"};
    }

    public DemandeTransfertFilleCpl[] getDemandeTransfertFilleCpl(String nt, Connection c) throws Exception{
        try{
            String nomTable = "";
            if(nt!=null && !nt.isEmpty()){
                nomTable = nt;
            }else {
                nomTable = "demandetransfertfillecpl";
            }
            DemandeTransfertFilleCpl fille = new DemandeTransfertFilleCpl();
            fille.setNomTable(nomTable);
            fille.setIdDemandeTransfert(this.getId());
            DemandeTransfertFilleCpl[] rep = (DemandeTransfertFilleCpl[]) CGenUtil.rechercher(fille, null, null, c, "");
            return rep;
        }catch (Exception e){
            throw e;
        }
    }

    public TransfertStock genererTransfertStock(Connection c) throws Exception {
        try{
            DemandeTransfert dm = new DemandeTransfert();
            dm = (DemandeTransfert) dm.getById(this.getId(),"demandetransfert",c);
            TransfertStock ts = new TransfertStock();
            ts.setDesignation("Transfert de stock pour "+this.getId());
            ts.setIdMagasinDepart(dm.getIdMagasinDepart());
            ts.setIdMagasinArrive(dm.getIdMagasinArrive());
            ts.setIdOf(this.getIdOf());
            ts.setIdDemande(dm.getId());
            if(dm.getIdFabrication() != null && !dm.getIdFabrication().isEmpty()){
                ts.setIdFabrication(dm.getIdFabrication());
            }
            DemandeTransfertFilleCpl[] recettes = this.getDemandeTransfertFilleCpl(null,c);

            MvtStockEntreeAvecReste depCtr = new MvtStockEntreeAvecReste();
            depCtr.setNomTable("V_ETATSTOCK_ENTREE");
            depCtr.setIdMagasin(dm.getIdMagasinDepart());
            MvtStockEntreeAvecReste[] etatStockDepart = (MvtStockEntreeAvecReste[]) CGenUtil.rechercher(depCtr, null, null, c, "order by daty desc");
            Vector<MvtStockEntreeAvecReste> vect = new Vector<MvtStockEntreeAvecReste>(Arrays.asList(etatStockDepart));
            EtatStock arrCtr = new EtatStock();
            arrCtr.setNomTable("V_ETATSTOCK_ING");
            arrCtr.setIdMagasin(dm.getIdMagasinArrive());
            EtatStock[] etatStockArrive = (EtatStock[])CGenUtil.rechercher(arrCtr, null, null, c, "");
            List<TransfertStockDetails> details = new ArrayList<TransfertStockDetails>();
            for (int i = 0; i < recettes.length; i++) {
                if(recettes[i].getTypeStock()!=null){
                    double reste = 0;
                    EtatStock stockArrive = (EtatStock) AdminGen.findUnique(etatStockArrive,new String[]{"id"},new String[]{recettes[i].getIdProduit()});
                    if(stockArrive != null) {
                        reste = stockArrive.getReste();
                    }
                    double qteATransferer = recettes[i].getQuantite() - reste;

                    while (qteATransferer > 0) {
                        MvtStockEntreeAvecReste stockDepart = (MvtStockEntreeAvecReste) AdminGen.findUnique(vect,new String[]{"idProduit"},new String[]{recettes[i].getIdProduit()});
                        TransfertStockDetails det = new TransfertStockDetails();
                        det.setIdProduit(recettes[i].getIdProduit());
                        det.setRemarque(recettes[i].getIdProduitLib()+" - "+recettes[i].getUnite());

                        if(stockDepart != null && stockDepart.getReste() > 0 ){
                            double qteTransferee = qteATransferer;
                            qteTransferee = Math.min(qteATransferer, stockDepart.getReste());
                            stockDepart.setReste(stockDepart.getReste() - qteTransferee);
                            det.setQuantite(qteTransferee);
                            qteATransferer -= qteTransferee;
                            det.setIdSource(stockDepart.getId());
                            det.setPu(stockDepart.getPu());
                            details.add(det);
                            vect.remove(stockDepart);
                        }else {
                            det.setQuantite(recettes[i].getQuantite());
                            det.setPu(recettes[i].getPu());
                            details.add(det);
                            break;
                        }
                    }

                }
            }
            ts.setFille(details.toArray(new TransfertStockDetails[0]));
            return ts;
        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    public TransfertStock genererTransfertStock(String idMagDepart, String idMagArrive,  Connection c) throws Exception {
        try{
            DemandeTransfert dm = new DemandeTransfert();
            dm = (DemandeTransfert) dm.getById(this.getId(),"demandetransfert",c);
            TransfertStock ts = new TransfertStock();
            ts.setDesignation("Transfert de stock pour "+this.getId());
            ts.setIdMagasinDepart(idMagDepart != null ? idMagDepart : dm.getIdMagasinDepart());
            ts.setIdMagasinArrive(idMagArrive != null ? idMagArrive : dm.getIdMagasinArrive());
            ts.setIdOf(this.getIdOf());
            if(dm.getIdFabrication() != null && !dm.getIdFabrication().isEmpty()){
                ts.setIdFabrication(dm.getIdFabrication());
            }
            DemandeTransfertFilleCpl[] recettes = this.getDemandeTransfertFilleCpl(null,c);

            MvtStockEntreeAvecReste depCtr = new MvtStockEntreeAvecReste();
            depCtr.setNomTable("V_ETATSTOCK_ENTREE");
            depCtr.setIdMagasin(idMagDepart != null ? idMagDepart : dm.getIdMagasinDepart());
            MvtStockEntreeAvecReste[] etatStockDepart = (MvtStockEntreeAvecReste[])CGenUtil.rechercher(depCtr, null, null, c, "order by daty desc");
            Vector<MvtStockEntreeAvecReste> vect = new Vector<MvtStockEntreeAvecReste>(Arrays.asList(etatStockDepart));
            EtatStock arrCtr = new EtatStock();
            arrCtr.setNomTable("V_ETATSTOCK_ING");
            arrCtr.setIdMagasin(idMagArrive != null ? idMagArrive : dm.getIdMagasinArrive());
            EtatStock[] etatStockArrive = (EtatStock[])CGenUtil.rechercher(arrCtr, null, null, c, "");
            List<TransfertStockDetails> details = new ArrayList<TransfertStockDetails>();
            for (int i = 0; i < recettes.length; i++) {
                if(recettes[i].getTypeStock()!=null){
                    double reste = 0;
                    EtatStock stockArrive = (EtatStock) AdminGen.findUnique(etatStockArrive,new String[]{"id"},new String[]{recettes[i].getIdProduit()});
                    if(stockArrive != null) {
                        reste = stockArrive.getReste();
                    }
                    double qteATransferer = recettes[i].getQuantite() - reste;

                    while (qteATransferer > 0) {
                        MvtStockEntreeAvecReste stockDepart = (MvtStockEntreeAvecReste) AdminGen.findUnique(vect,new String[]{"idProduit"},new String[]{recettes[i].getIdProduit()});
                        TransfertStockDetails det = new TransfertStockDetails();
                        det.setIdProduit(recettes[i].getIdProduit());
                        det.setRemarque(recettes[i].getIdProduitLib()+" - "+recettes[i].getUnite());

                        if(stockDepart != null && stockDepart.getReste() > 0 ){
                            double qteTransferee = qteATransferer;
                            qteTransferee = Math.min(qteATransferer, stockDepart.getReste());
                            stockDepart.setReste(stockDepart.getReste() - qteTransferee);
                            det.setQuantite(qteTransferee);
                            qteATransferer -= qteTransferee;
                            det.setIdSource(stockDepart.getId());
                            det.setPu(stockDepart.getPu());
                            details.add(det);
                            vect.remove(stockDepart);
                        }else {
                            det.setPu(recettes[i].getPu());
                            det.setQuantite(recettes[i].getQuantite());
                            details.add(det);
                            break;
                        }
                    }

                }
            }
            ts.setFille(details.toArray(new TransfertStockDetails[0]));
            return ts;
        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        return superValider(u, c);
    }

    @Override
    public ClassMAPTable createObject(MapUtilisateur u, Connection c)throws Exception{
        return superCreateObject(u,c);
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c)throws Exception{
        return superCreateObject(u,c);
    }

    @Override
    public Object validerObject(MapUtilisateur u, Connection c) throws Exception{
        return superValider(u,c);
    }


}
