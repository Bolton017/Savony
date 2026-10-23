package rapprochement;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassFille;
import bean.ClassMAPTable;
import mg.cnaps.compta.ComptaSousEcriture;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import java.sql.Connection;
import java.sql.Date;

public class RapprochementBC extends ClassFille {
    private  String id;
    private  String idSousEcriture;
    private  String idReleverDetail;
    private  double valeurSousEcriture;
    private  double valeurReleverDetail;
    private Date daty;
    private String idmere;

    public String getIdmere() {
        return idmere;
    }

    public void setIdmere(String idmere) {
        this.idmere = idmere;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdSousEcriture() {
        return idSousEcriture;
    }

    public void setIdSousEcriture(String idSousEcriture) {
        this.idSousEcriture = idSousEcriture;
    }

    public String getIdReleverDetail() {
        return idReleverDetail;
    }

    public void setIdReleverDetail(String idReleverDetail) {
        this.idReleverDetail = idReleverDetail;
    }

    public double getValeurSousEcriture() {
        return valeurSousEcriture;
    }

    public void setValeurSousEcriture(double valeurSousEcriture) {
        this.valeurSousEcriture = valeurSousEcriture;
    }

    public double getValeurReleverDetail() {
        return valeurReleverDetail;
    }

    public void setValeurReleverDetail(double valeurReleverDetail) {
        this.valeurReleverDetail = valeurReleverDetail;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("RAPF", "getSeqRapprochementBC");
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

    public RapprochementBC () {
        this.setNomTable("RapprochementBC");
        this.setLiaisonMere("rapprochement.RapprochementBCMERE");
        this.setLiaisonMere("idmere");
    }

    public void controleRapprochement(String [] idEcriture, String [] idRelever,Connection c) throws Exception{
        boolean canClose=false;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                canClose=true;
            }
            String awhereIdEcriture = " and id in (" + Utilitaire.tabToString(idEcriture, "'", ",") + ")";
            String awhereIdRelever = " and id in (" + Utilitaire.tabToString(idRelever, "'", ",") + ")";
            System.err.println(awhereIdEcriture+" "+awhereIdRelever);
            ComptaSousEcriture sousEcriture = new ComptaSousEcriture();
            sousEcriture.setNomTable("SOUSECRITURENR");
            ComptaSousEcriture[] sousEcritures = (ComptaSousEcriture[]) CGenUtil.rechercher(sousEcriture,null,null,c,awhereIdEcriture);
            double debitEcriture = AdminGen.calculSommeDouble(sousEcritures,"debit");
            double creditEcriture = AdminGen.calculSommeDouble(sousEcritures,"credit");

            ReleverDetail releverDetail = new ReleverDetail();
            releverDetail.setNomTable("ReleverDetailNR");
            ReleverDetail[] details = (ReleverDetail[]) CGenUtil.rechercher(releverDetail,null,null,c,awhereIdRelever);
            double debitRelever = AdminGen.calculSommeDouble(details,"debit");
            double creditRelever = AdminGen.calculSommeDouble(details,"credit");

            if(debitEcriture != creditRelever || creditEcriture != debitRelever){
                System.err.println(debitEcriture+"debitEcriture != creditRelever"+creditRelever);
                System.err.println(creditEcriture+"creditEcriture != debitRelever"+debitRelever);
                throw new Exception("Les montants des \u00E9critures et des relev\u00E9s ne correspondent pas !");
            }
        } finally {
            if(canClose){
                c.close();
            }
        }
    }

    public void rapprochement(String u, String [] idEcriture, String [] idRelever, Connection c) throws Exception {
        boolean canClose=false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                canClose = true;
            }
            controleRapprochement(idEcriture, idRelever, c);
            for (String idEcr : idEcriture) {
                ComptaSousEcriture [] sousEcriture = (ComptaSousEcriture [] ) CGenUtil.rechercher(new ComptaSousEcriture(), null,null,c," AND ID='"+idEcr+"'");
                for (String idRev : idRelever) {
                    ReleverDetailCpl [] releverDetail = (ReleverDetailCpl[]) CGenUtil.rechercher(new ReleverDetailCpl(), null,null,c," AND ID='"+idRev+"'");
                    RapprochementBC rb = new RapprochementBC();
                    rb.setIdSousEcriture(idEcr);
                    rb.setIdReleverDetail(idRev);
                    rb.setValeurReleverDetail(releverDetail[0].getCredit()>0?releverDetail[0].getCredit():releverDetail[0].getDebit());
                    rb.setValeurSousEcriture(sousEcriture[0].getCredit()>0?sousEcriture[0].getCredit():sousEcriture[0].getDebit());
                    rb.setDaty(Utilitaire.dateDuJourSql());
                    rb.setIdmere(this.getIdmere());
                    System.err.println("=========================================================================================================="+rb.getIdmere());
                    rb.createObject(u, c);
                }
            }
            if(canClose) c.commit();
        }catch (Exception e) {
            if(canClose) c.rollback();
            throw e;
        } finally {
            if(canClose) c.close();
        }
    }
}
