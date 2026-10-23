package faturefournisseur;

import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;
import caisse.Caisse;
import caisse.MvtCaisse;
import caisse.ReportCaisse;
import faturefournisseur.FactureFournisseur;
import faturefournisseur.FactureFournisseurCpl;
import paiement.PaiementFF;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDateTime;

public class LiaisonIntraTable extends ClassEtat {

    String id;
    String id1;
    String id2;
    double montant;
    public LiaisonIntraTable() {
        this.setNomTable("LIAISONFACTUREFOURNISSEURS");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getId1() {
        return id1;
    }

    public void setId1(String id1) {
        this.id1 = id1;
    }

    public String getId2() {
        return id2;
    }

    public void setId2(String id2) {
        this.id2 = id2;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    @Override
    public String getTuppleID() {
        return this.id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("LIT", "getseqliaisonfacturef");
        this.setId(makePK(c));
    }

    public void lier(String id1, String id2, String u) throws Exception{
        Connection c = null;
        try{
            c=new UtilDB().GetConn();
            c.setAutoCommit(false);
            String [] frais = id2.split(";");
            for(String idfrais: frais){
                if(idfrais.compareToIgnoreCase(id1)==0){
                    c.rollback();
                    throw new Exception("La facture correspond à l’ID des frais divers.");
                }
                FactureFournisseur f = (FactureFournisseur)new FactureFournisseur().getById(idfrais,"FACTUREFOURNISSEURCPL",c);
                LiaisonIntraTable l = new LiaisonIntraTable();
                l.setId1(id1);
                l.setId2(f.getId());
                l.setMontant(f.getMontantttc());
                l.createObject(u,c);
                l.validerObject(u, c);
            }
            c.commit();
        } catch(Exception e){
            c.rollback();
            throw e;
        } finally {
            c.close();
        }
    }
    public void creerPaiementFF(String u,Connection c) throws Exception{
        boolean canClose=false;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                canClose=true;
            }
            String[] ids = this.getId2().split(";");
            FactureFournisseurCpl ffcpl = new FactureFournisseurCpl();
            FactureFournisseurCpl[] bls = (FactureFournisseurCpl[]) CGenUtil.rechercher(ffcpl, null, null,c, " and id in ("+Utilitaire.tabToString(ids, "'", ",")+" ) order by daty asc ");
            for(int i=0;i<bls.length;i++){
                double montantAPayer = Math.min(montant, bls[i].getMontantreste());
                PaiementFF p = new PaiementFF();
                p.setDaty(Utilitaire.dateDuJourSql());
                p.setIdOP(this.getId1());
                p.setIdFF(bls[i].getId());
                p.setMontant(montantAPayer);
                p.createObject(u, c);
                montant -= montantAPayer;
            }
        } catch(Exception e){
            throw e;
        } finally {
            if(canClose){
                c.close();
            }
        }
    }
}
