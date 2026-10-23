package rapprochement;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMere;
import mg.cnaps.compta.ComptaEcriture;
import mg.cnaps.compta.ComptaSousEcriture;
import utilitaire.ConstanteEtat;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;

public class RapprochementDBMere extends ClassMere {
    private String id;
    private String idBanque;
    private double valeur;
    private Date daty;

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("RAP", "getSeqRapprochementBCMERE");
        this.setId(makePK(c));
    }

    public RapprochementDBMere() throws Exception {
        this.setNomTable("RAPPROCHEMENTBCMERE");
        this.setLiaisonFille("idmere");
        this.setNomClasseFille("rapprochement.RapprochementBC");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdBanque() {
        return idBanque;
    }

    public void setIdBanque(String idBanque) {
        this.idBanque = idBanque;
    }

    public double getValeur() {
        return valeur;
    }

    public void setValeur(double valeur) {
        this.valeur = valeur;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    @Override
    public String getTuppleID() {
        return this.id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }


    public double controleRapprochement(String [] idEcriture, String [] idRelever,Connection c) throws Exception{
        boolean canClose=false;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                canClose=true;
            }
            String awhereIdEcriture = " and id in (" + Utilitaire.tabToString(idEcriture, "'", ",") + ")";
            String awhereIdRelever = " and id in (" + Utilitaire.tabToString(idRelever, "'", ",") + ")";

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
                throw new Exception("Les montants des \u00E9critures et des relev\u00E9s ne correspondent pas !");
            }
            return debitRelever>0?debitRelever:creditRelever;
        } finally {
            if(canClose){
                c.close();
            }
        }
    }

    public RapprochementDBMere rapprochement(String u, String [] idEcriture, String [] idRelever, Connection c) throws Exception {
        boolean canClose=false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                canClose = true;
            }
            if(idEcriture.length<=0 || idRelever.length<=0){
                throw new Exception("Aucune \u00E9criture ou relev\u00E9 n'a \u00E9t\u00E9 choisi !");
            }
            ReleverDetailCpl [] rel0 = (ReleverDetailCpl[]) CGenUtil.rechercher(new ReleverDetailCpl(), null,null,c," AND ID='"+idRelever[0]+"'");
            double valeur = controleRapprochement(idEcriture, idRelever, c);
            this.setDaty(Utilitaire.dateDuJourSql());
            this.setIdBanque(rel0[0].getIdCaisse());
            this.setValeur(valeur);
            RapprochementDBMere mere = (RapprochementDBMere) this.createObject(u, c);
            for (String idEcr : idEcriture) {
                ComptaSousEcriture [] sousEcriture = (ComptaSousEcriture [] ) CGenUtil.rechercher(new ComptaSousEcriture(), null,null,c," AND ID='"+idEcr+"'");
                if (sousEcriture.length < 1) {
                    throw new Exception("Aucun sous-\u00E9criture trouv\u00E9");
                }
                ComptaEcriture[] comptaEcriture = (ComptaEcriture[]) CGenUtil.rechercher(new ComptaEcriture(),null,null,c," AND id = '"+sousEcriture[0].getIdMere()+"'");
                if (comptaEcriture.length < 1) {
                    throw new Exception("Aucune \u00E9criture trouv\u00E9");
                }
                if (comptaEcriture[0].getEtat() == ConstanteEtat.getEtatCreer()) {
                    comptaEcriture[0].validerObject(u,c);
                    sousEcriture[0].validerObject(u,c);
                }
                for (String idRev : idRelever) {
                    ReleverDetailCpl [] releverDetail = (ReleverDetailCpl[]) CGenUtil.rechercher(new ReleverDetailCpl(), null,null,c," AND ID='"+idRev+"'");
                    RapprochementBC rb = new RapprochementBC();
                    rb.setIdSousEcriture(idEcr);
                    rb.setIdReleverDetail(idRev);
                    rb.setValeurReleverDetail(releverDetail[0].getCredit()>0?releverDetail[0].getCredit():releverDetail[0].getDebit());
                    rb.setValeurSousEcriture(sousEcriture[0].getCredit()>0?sousEcriture[0].getCredit():sousEcriture[0].getDebit());
                    rb.setDaty(Utilitaire.dateDuJourSql());
                    rb.setIdmere(mere.getId());
                    rb.createObject(u, c);
                }
            }
            if(canClose) c.commit();
            return mere;
        }catch (Exception e) {
            if(canClose) c.rollback();
            throw e;
        } finally {
            if(canClose) c.close();
        }
    }

    public void checkRapprochementExist(RapprochementBC [] filles, Connection c) throws Exception{
        for(RapprochementBC rb : filles){
            String awhere = " AND ( IDSOUSECRITURE='"+rb.getIdSousEcriture()+"' OR IDRELEVERDETAIL='"+rb.getIdReleverDetail()+"' ) AND IDMERE!='"+this.getId()+"' AND etat>=11";
            RapprochementBC temp = new RapprochementBC();
            temp.setNomTable("RapprochementBCETAT");
            RapprochementBC [] autreFilles = (RapprochementBC []) CGenUtil.rechercher(temp, null,null,null,awhere);
            if(autreFilles.length>0){
                throw new Exception("Un autre rapprochement est d\u00E9ja valid\u00E9 pour l' \u00E9criture "+rb.getIdSousEcriture()+" ou le relev\u00E9 "+rb.getIdReleverDetail()+" !");
            }
        }
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        RapprochementBC [] filles = (RapprochementBC []) this.getFille("RapprochementBC",c," AND idmere='"+this.getId()+"'");
        this.checkRapprochementExist(filles,c);
        return super.validerObject(u, c);
    }
}
