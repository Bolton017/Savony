package declaration;

import bean.ClassMAPTable;
import user.UserEJB;
import utilitaire.UtilDB;

import java.sql.Connection;
import java.util.ArrayList;

public class LiaisonCodeImpot extends ClassMAPTable {
    private String id;
    private String idcodeimpot;
    private String idcompte;
    private String formule;
    private String taxable;

    public String getTaxable() {
        return taxable;
    }

    public void setTaxable(String taxable) {
        this.taxable = taxable;
    }

    public String getFormule() {
        return formule;
    }

    public void setFormule(String formule) {
        this.formule = formule;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdcodeimpot() {
        return idcodeimpot;
    }

    public void setIdcodeimpot(String idcodeimpot) {
        this.idcodeimpot = idcodeimpot;
    }

    public String getIdcompte() {
        return idcompte;
    }

    public void setIdcompte(String idcompte) {
        this.idcompte = idcompte;
    }



    public LiaisonCodeImpot() throws Exception {
        this.setNomTable("LIAISONCODEIMPOT");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("LCP","getSeqLiaisonCodeImpot");
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

    public void updateObjectMultipleSansMere(UserEJB u, ClassMAPTable[] cfille) throws Exception{
        Connection c = null;
        try{
            c = new UtilDB().GetConn();
            c.setAutoCommit(false);
            ArrayList<LiaisonCodeImpot> liste = new ArrayList<>();
            for(int i=0;i<cfille.length;i++){
                String valeur = ((LiaisonCodeImpotSaisie)cfille[i]).getValeur();
                String formule = ((LiaisonCodeImpotSaisie)cfille[i]).getFormule();
                String taxable = ((LiaisonCodeImpotSaisie)cfille[i]).getTaxable();
//                String [] comptes = valeur.split(";");
//                for(int j=0;j<comptes.length;j++){
                LiaisonCodeImpot liaison = new LiaisonCodeImpot();
                liaison.setId(((LiaisonCodeImpotSaisie) cfille[i]).getId());
                liaison.setIdcodeimpot(((LiaisonCodeImpotSaisie)cfille[i]).getIdcodeimpot());
                liaison.setIdcompte(((LiaisonCodeImpotSaisie) cfille[i]).getIdcompte());
                liaison.setFormule(formule);
                liaison.setTaxable(taxable);
                u.updateObject(liaison);
//                }
            }
            c.commit();
        }
        catch(Exception e){
            if(c!=null) c.rollback();
            throw e;
        }
        finally{
            if(c!=null) c.close();
        }

    }

    public void createObjectFilleMultipleSansMere(UserEJB u, ClassMAPTable[] cfille) throws Exception{
        Connection c = null;
        try{
            c = new UtilDB().GetConn();
            c.setAutoCommit(false);
            ArrayList<LiaisonCodeImpot> liste = new ArrayList<>();
            for(int i=0;i<cfille.length;i++){
                String valeur = ((LiaisonCodeImpotSaisie)cfille[i]).getValeur();
                String formule = ((LiaisonCodeImpotSaisie)cfille[i]).getFormule();
                String taxable = ((LiaisonCodeImpotSaisie)cfille[i]).getTaxable();
//                String [] comptes = valeur.split(";");
//                for(int j=0;j<comptes.length;j++){
                LiaisonCodeImpot liaison = new LiaisonCodeImpot();
                liaison.setIdcodeimpot(((LiaisonCodeImpotSaisie)cfille[i]).getIdcodeimpot());
                liaison.setIdcompte(((LiaisonCodeImpotSaisie) cfille[i]).getIdcompte());
                liaison.setFormule(formule);
                liaison.setTaxable(taxable);
                liste.add(liaison);
//                }
            }
            u.createObjectMultipleSansMere(liste.toArray(liste.toArray(new LiaisonCodeImpot[liste.size()])),c);
            c.commit();
        }
        catch(Exception e){
            if(c!=null) c.rollback();
            throw e;
        }
        finally{
            if(c!=null) c.close();
        }

    }
}

