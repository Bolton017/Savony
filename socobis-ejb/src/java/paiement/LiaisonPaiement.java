package paiement;

import bean.ClassEtat;
import caisse.MvtCaisse;
import caisse.MvtCaisseCpl;
import facture.tr.Traite;
import utilitaire.Utilitaire;
import vente.VenteLib;
import java.sql.Connection;
import java.util.ArrayList;

import avoir.AvoirFCLib;
import utilitaire.*;
import bean.*;
public class LiaisonPaiement extends ClassEtat {

    String id,id1,id2;
    double montant;

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
    public void construirePK(Connection c) throws Exception {
        this.preparePk("LP", "getseqLiaisonPaiement");
        this.setId(makePK(c));
    }

    public LiaisonPaiement() {
        setNomTable("LiaisonPaiement");
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public void creerPaiementFacture(String u,Connection c) throws Exception{
        boolean canClose=false;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                canClose=true;
            }
            c.setAutoCommit(false);
            String[] ids = this.getId1().split(";");
            VenteLib[] v = (VenteLib[]) CGenUtil.rechercher(new VenteLib(), null, null,c, " and id ='"+this.id2+"'");
            if(v.length<1) throw new Exception("Facture non existante!");
            double montantTtcArFacture = v[0].getMontantreste();
            AvoirFCLib ffcpl = new AvoirFCLib();
            ffcpl.setNomTable("AVOIRFCLIB_CPL");
            AvoirFCLib[] bls = (AvoirFCLib[]) CGenUtil.rechercher(ffcpl, null, null,c, " and id in ("+Utilitaire.tabToString(ids, "'", ",")+" ) order by id asc");
            double totalAvoirs = 0.0;
            for (AvoirFCLib bl : bls) {
                if (v[0].getIdClient().compareToIgnoreCase(bl.getIdClient()) != 0) {
                    throw new Exception("Impossible car client different pour le Avoir : " + bl.getId());
                }
                double resteavoir = bl.getResteapayerar();
                LiaisonPaiement p = new LiaisonPaiement();
                p.setId1(bl.getId());
                p.setId2(this.getId2());
                if (resteavoir > montantTtcArFacture) {
                    p.setMontant(montantTtcArFacture);
                    p.createObject(u, c);
                    p.validerObject(u, c);
                    break;
                } else {
                    p.setMontant(resteavoir);
                    p.createObject(u, c);
                    p.validerObject(u, c);
                    montantTtcArFacture -= resteavoir;
                }
//                if (totalAvoirs + resteavoir > montantTtcArFacture) {
//                    break;
//                }
                //totalAvoirs += resteavoir;
            }
            c.commit();
        } catch(Exception e){
            if(canClose){
                c.rollback();
            }
            throw e;
        } finally {
            if(canClose){
                c.close();
            }
        }
    }

    public int solderTraite(String u,Connection c,Traite t, VenteLib[] ventes, int indice) throws Exception {
        for (int i=indice ; i<ventes.length;i++){
             if (ventes[0].getIdClient().compareToIgnoreCase(t.getIdtiers()) != 0) {
                throw new Exception("Impossible : clients diff\u00E9rents.");
             }
            LiaisonPaiement liaisonPaiement = new LiaisonPaiement();
            liaisonPaiement.setId2(ventes[i].getId());
            liaisonPaiement.setId1(t.getId());

            double resteTraite = t.getMontantreste();
            double montantApayer = ventes[i].getMontantreste();
            indice = -1;
            if (montantApayer<=0) throw new Exception("La vente "+ventes[i].getId()+" est d\u00E9j\u00E0 sold\u00E9e.");

            if (montantApayer < resteTraite) {
                liaisonPaiement.setMontant(montantApayer);
                resteTraite = resteTraite-montantApayer;
                montantApayer = 0;
            } else if (montantApayer > resteTraite) {
                liaisonPaiement.setMontant(resteTraite);
                montantApayer = montantApayer-resteTraite;
                resteTraite = 0;
                indice = i; // indice vente non couvert par la traite
            } else {
                liaisonPaiement.setMontant(resteTraite);
                //resteTraite = 0;
                montantApayer = 0;
                indice = i+1; // indice vente suivant
            }
            t.setMontantreste(resteTraite);
            ventes[i].setMontantreste(montantApayer);
            liaisonPaiement.createObject(u,c);
            liaisonPaiement.validerObject(u,c);
            if (indice != -1) {
                return indice;
            }
        }
        return indice;
    }

    public void creerPaiementFactureParTraite(String u,Connection c) throws Exception{
        boolean canClose=false;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                canClose=true;
            }
            c.setAutoCommit(false);
            Traite t = new  Traite();
            t.setNomTable("TRAITEMTTRESTE");
            String[] venteIds = this.getId1().split(";");
            String[] traiteIds = this.getId2().split(";");

            String queryVente = " and id in ("+Utilitaire.tabToString(venteIds, "'", ",")+" ) order by id desc";
            String queryTraite = " and id in ("+Utilitaire.tabToString(traiteIds, "'", ",")+" ) order by id desc";
            VenteLib[] ventes = (VenteLib[]) CGenUtil.rechercher(new VenteLib(), null, null,c, queryVente);
            Traite[] traites = (Traite[]) CGenUtil.rechercher(t,null,null,c,queryTraite);

            int indice = 0;
            for (Traite traite : traites) {
                indice = solderTraite(u,c,traite, ventes, indice);
            }
            c.commit();
        } catch(Exception e){
            if(canClose){
                c.rollback();
            }
            throw e;
        } finally {
            if(canClose){
                c.close();
            }
        }
    }
public void creerPaiementParCaisse(String[] tabIdmvt, String[] tabVente, String u, Connection c) throws Exception {

    boolean canClose = false;
    try {
        if (c == null) {
            c = new UtilDB().GetConn();
            canClose = true;
        }
        c.setAutoCommit(false);
        String awherevente = " and id in (" + Utilitaire.tabToString(tabVente, "'", ",") + " ) order by id asc";
        VenteLib[] ventes = (VenteLib[]) CGenUtil.rechercher(
                new VenteLib(), null, null, c,
                awherevente);

        double montantTotalFacture = AdminGen.calculSommeDouble(ventes, "montantreste");
        String awheremvtcaisse = " and id in (" + Utilitaire.tabToString(tabIdmvt, "'", ",") + ") order by id asc";
        MvtCaisseCpl[] mvts = (MvtCaisseCpl[]) CGenUtil.rechercher(
                new MvtCaisseCpl(), null, null, c,
                awheremvtcaisse);

        double sommeCredits = 0;
        for (MvtCaisseCpl mvt : mvts) {
            sommeCredits += mvt.getSoldecredit();
        }
        //double coef = montantTotalFacture / sommeCredits;
        if(montantTotalFacture>sommeCredits){
            throw new Exception("Le montant total des facture doit etre inferieur au montant total des mouvements caisse");
        }

        ArrayList<LiaisonPaiement> liste = new ArrayList<>();

        for (VenteLib v : ventes) {
            double coeficient = v.getMontantreste() * 100 / sommeCredits;
            for (MvtCaisseCpl mvt : mvts) {
                LiaisonPaiement lp = new LiaisonPaiement();
                lp.setId1(mvt.getId()); 
                lp.setId2(v.getId());  
                lp.setEtat(11);
                //double montant = (mvt.getSoldecredit() * coef * v.getMontantreste()) / montantTotalFacture;
                double montant = mvt.getSoldecredit() * coeficient / 100;
                lp.setMontant(montant);
                liste.add(lp);
            }
        }

        for (LiaisonPaiement lp : liste) {
            lp.createObject(u,c);
        }
        c.commit();
    } catch (Exception e) {
        if (canClose) c.rollback();
        throw e;
    } finally {
        if (canClose) c.close();
    }
}





}
