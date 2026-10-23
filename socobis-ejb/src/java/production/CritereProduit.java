package production;

import bean.ClassMAPTable;
import bean.CGenUtil;
import java.sql.Connection;

import annexe.Point;

public class CritereProduit extends ClassMAPTable {
    private String id;
    private String idcritere;
    private String idTypeProduit;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdcritere() {
        return idcritere;
    }

    public void setIdcritere(String idcritere) {
        this.idcritere = idcritere;
    }

    public String getIdTypeProduit() {
        return idTypeProduit;
    }

    public void setIdTypeProduit(String idTypeProduit) {
        this.idTypeProduit = idTypeProduit;
    }



    public CritereProduit() throws Exception {
        this.setNomTable("CRITEREPRODUIT");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CRP","GET_SEQ_CritereProduit");
        this.setId(makePK(c));
    }
    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        CritereProduit crd = new CritereProduit();
        CritereProduit[] ret = (CritereProduit[]) CGenUtil.rechercher(crd, null, null, " and idcritere= '"+this.getIdcritere()+"' and idTypeProduit= '"+this.getIdTypeProduit()+"'");
        if(ret.length > 0) {
            Exception e = new Exception("Ce critere de produit existe deja");
            throw e;
        }
        else{
            crd = (CritereProduit) super.createObject(u, c);
        }
        return crd;
    }
    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
}

