package vente;

import bean.ClassMere;
import bean.CGenUtil;
import faturefournisseur.FactureFournisseur;

import java.sql.Connection;
import java.sql.Date;
import java.util.Vector;

public class Carton extends ClassMere {
    String id, idBC, idBL;
    Date dateCreation;
    String remarque;
    String numero;
    int etat;

    public Carton() throws Exception {
        super.setNomTable("CARTON");
        setLiaisonFille("idMere");
        setNomClasseFille("vente.CartonFille");
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CRT", "getseqCarton");
        this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdBC() {
        return idBC;
    }

    public void setIdBC(String idBC) throws Exception {
        if(this.getMode().equals("modif") && (idBC == null || idBC.equals("")))
            throw new Exception("Bon de commande manquant");
        this.idBC = idBC;
    }

    public String getIdBL() {
        return idBL;
    }

    public void setIdBL(String idBL) {
        this.idBL = idBL;
    }

    public Date getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(Date dateCreation) {
        this.dateCreation = dateCreation;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }
    public As_BondeLivraisonClient genererLivraisonCarton(Connection conn, String[] ids, String idbc) throws Exception {
        As_BondeLivraisonClient client = new As_BondeLivraisonClient();
        Vector<As_BondeLivraisonClientFilleInsertion> listFilles = new Vector<>();

        for (int i = 0; i < ids.length; i++) {
            System.out.println("idss " + ids[i]);
            Carton c = (Carton) this.getById(ids[i], this.getNomTable(), conn);

            BonDeCommande com = new BonDeCommande();
            BonDeCommande bc = (BonDeCommande) com.getById(idbc, "BONDECOMMANDE_CLIENT", conn);
            BoncommandeDetailsCarton cf = new BoncommandeDetailsCarton();
            cf.setNomTable("VUE_SUIVI_CARTON_LIVRAISON");
            cf.setIdCartonMere(c.getId());

            BoncommandeDetailsCarton[] details = (BoncommandeDetailsCarton[]) CGenUtil.rechercher(cf, null, null, conn, "");
            if (details.length > 0) {
                client.setMode("modif");
                client.setIdbc(c.getIdBC());
                client.setEtat(c.getEtat());
                client.setRemarque("Livraison des cartons pour le BC " + c.getIdBC());
                System.out.println("idclient " + bc.getIdClient());
                client.setIdClient(bc.getIdClient());

                for (int j = 0; j < details.length; j++) {
                    As_BondeLivraisonClientFilleInsertion a = new As_BondeLivraisonClientFilleInsertion();
                    a.setProduit(details[j].getProduit());
                    a.setProduitLib(details[j].getProduit());
                    a.setQuantite(details[j].getQuantiteCartonFille());
                    a.setUnite(details[j].getUnite());
                    a.setUniteLib(details[j].getUniteLib());
                    a.setIdbc_fille(details[j].getId()  );

                    listFilles.add(a);
                }

            } else {
                throw new Exception("Pas de carton à livrer");
            }
        }

        As_BondeLivraisonClientFilleInsertion[] tabFilles = listFilles.toArray(new As_BondeLivraisonClientFilleInsertion[0]);
        client.setFille(tabFilles);

        return client;
    }

    public int getEtat() {
        return etat;
    }

    public void setEtat(int etat) {
        this.etat = etat;
    }
}
