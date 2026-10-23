package fabrication;

import bean.CGenUtil;
import bean.ClassMAPTable;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import vente.BonDeCommandeFIlleCpl;

import java.sql.Connection;

public class BcGroupeIng extends BonDeCommandeFIlleCpl {
    private String bcList;
    private String clientList;

    public String getBcList() {
        return bcList;
    }

    public void setBcList(String bcList) {
        this.bcList = bcList;
    }

    public String getClientList() {
        return clientList;
    }

    public void setClientList(String clientList) {
        this.clientList = clientList;
    }

    public BcGroupeIng() throws Exception {
        setNomTable("BC_GROUPE_ING");
    }

    public String[] getIdBcFilles() {
        if (bcList == null || bcList.isEmpty()) {
            return new String[0];
        }

        String[] pairs = bcList.split(";");
        String[] ids = new String[pairs.length];

        for (int i = 0; i < pairs.length; i++) {
            String[] parts = pairs[i].split(":");
            ids[i] = parts[0];
        }

        return ids;
    }

    public int[] listQtes() {
        if (bcList == null || bcList.isEmpty()) {
            return new int[0];
        }

        String[] pairs = bcList.split(";");
        int[] qtes = new int[pairs.length];

        for (int i = 0; i < pairs.length; i++) {
            String[] parts = pairs[i].split(":");
            qtes[i] = Integer.parseInt(parts[1]);
        }

        return qtes;
    }

    public String[] splitClientNames() {
        if (clientList == null || clientList.trim().isEmpty()) {
            return new String[0];
        }

        return clientList.split(";");
    }

    public Of generateOf() throws Exception {
        Of of = new Of();
        of.setRemarque("OF generer VIA BC groupe");
        of.setDaty(Utilitaire.dateDuJourSql());
        return of;
    }

    public OfFille[] generateOfFilles() throws Exception {
        String[] listId = getIdBcFilles();
        int[] listQtes = listQtes();
        String[] listClient = splitClientNames();
        int length = listQtes.length;
        OfFille[] ofFilles = new OfFille[length];
        for (int i = 0; i < length; i++) {
            ofFilles[i] = new OfFille();
            ofFilles[i].setIdIngredients(getProduit());
            ofFilles[i].setIdBcFille(listId[i]);
            ofFilles[i].setRemarque(listClient[i]);
            ofFilles[i].setQte(listQtes[i]);
        }

        return ofFilles;
    }

    public BcGroupeIng getBcIng(String idIng) throws Exception {
        BcGroupeIng bc = new BcGroupeIng();
        bc.setProduit(idIng);
        BcGroupeIng[] search = (BcGroupeIng[]) CGenUtil.rechercher(bc,null,null," ");
        bc = search[0];
        return  bc;
    }

    public Of traiterBcGroupe(String[] ings, String u , Connection c) throws Exception {
        Of of = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
                c.setAutoCommit(false);
            }
            of = generateOf();
            of = (Of) of.createObject(u, c);
            for (int i = 0; i < ings.length; i++) {
                BcGroupeIng bc = getBcIng(ings[i]);
                OfFille[] ofFilles = bc.generateOfFilles();
                for (OfFille ofFille : ofFilles) {
                    ofFille.setIdMere(of.getId());
                    ofFille.createObject(u, c);
                }
            }
            if(estOuvert==true){c.commit();}
        } catch (Exception e) {
            c.rollback();
            throw e;
        } finally {
            if (estOuvert == true && c != null) {
                c.close();
            }
        }
        return of;
    }

    @Override
    public String getTuppleID() {
        return getProduit();
    }

    @Override
    public String getAttributIDName() {
        return "produit";
    }

}
