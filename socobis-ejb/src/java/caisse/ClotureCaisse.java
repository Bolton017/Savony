package caisse;

import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;
import bean.ClassMere;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;
import java.sql.Statement;
import java.util.Arrays;

public class ClotureCaisse extends ClassEtat {

    private String id,remarque,idPoint, pointLib, explication, idCaisse;
    private Date daty;
    private int etat;
    private String idUser;
    private ReportCaisse[] reportCaisse;
    //    double montantTheorique, montant;
    public ClotureCaisse()throws Exception {
        super.setNomTable("CLOTURECAISSE");
    }


    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        Statement st = null;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                estOuvert = true;
            }
            st = c.createStatement();

            this.setDaty(Utilitaire.dateDuJourSql());
            this.setRemarque("Cloture de caisse du " + Utilitaire.dateDuJour());
            this.setIdUser(u);

            ClotureCaisse res = (ClotureCaisse) super.createObjectBatch(u, st);
            System.out.println(" res +++++++++++++== " + res );
            res.validerObjectBatch(u, st);

            ReportCaisse[] reports = this.getReportCaisse();
            if (reports != null) {
                for (ReportCaisse rc : reports) {
                    if (rc == null) continue;
                    rc.setIdOrigine(res.getId());
                    rc.createObjectBatch(u, st);
                    rc.validerObjectBatch(u, st);
                }
            }

            st.executeBatch();
            if (estOuvert) c.commit();
            return res;
        } catch (Exception e) {
            if (estOuvert && c != null) c.rollback();
            throw e;
        } finally {
            if (st != null) st.close();
            if (estOuvert && c != null) c.close();
        }
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CCA", "getseqcloturecaisse");
        this.setId(makePK(c));
    }
    @Override
    public String getAttributIDName() {
        return "id";
    }
    @Override
    public String getTuppleID() {
        return id;
    }

    public double getMontantTheoriqueCaisse(String idCaisse) throws Exception {
        Connection c = null;
        double montantTheorique = 0;
        try {
            ClotureCaisse clotureCaisse = new ClotureCaisse();
            clotureCaisse.setNomTable("MONTANTCAISSE");
            clotureCaisse.setIdCaisse(idCaisse);
            ClotureCaisseFille[] fille = (ClotureCaisseFille[]) CGenUtil.rechercher(clotureCaisse, null, null, c, "");
            if (fille != null && fille.length>0) {
                return fille[0].getMontantTheorique();
            }
        } catch (Exception e) {
            e.printStackTrace();
            c.rollback();
            throw e;
        } finally {
            c.close();
        }
        return montantTheorique;
    }

    public ClotureCaisseFille[] getCaisseAvecMontantTheorique(Date date) throws Exception {
        Connection c = null;
        ClotureCaisseFille[] fille = null;
        try {
            ClotureCaisseFille clotureCaisseFille = new ClotureCaisseFille();
            clotureCaisseFille.setNomTable("MONTANTCAISSE");
            String apresWhere = "";
            if(date!=null) {
                apresWhere = "WHERE datedernierreport <= TO_DATE('" + date + "','YYYY-MM-DD')";
            }
            fille = (ClotureCaisseFille[]) CGenUtil.rechercher(clotureCaisseFille, null, null, c, apresWhere);
            System.out.println(" filles clotures " + fille.length);
            if (fille != null && fille.length>0) {
                return fille;
            }
        } catch (Exception e) {
            e.printStackTrace();
            c.rollback();
            throw e;
        } finally {
            if(c != null) c.close();
        }
        return fille;
    }
    public ClotureCaisseFille[] genererCaisseACloturer(Caisse[] caisseCloture, Connection c) throws Exception {
        Caisse cai = new Caisse();
        cai.setNomTable("caisseCloture");
        caisseCloture = (Caisse[]) CGenUtil.rechercher(cai, null,null, "");
        ClotureCaisseFille[] fille = new ClotureCaisseFille[caisseCloture.length];
        for(int i=0; i < caisseCloture.length; i++) {
            if (caisseCloture[i] == null) continue;
            String idCaisseCloture = caisseCloture[i].getId();
            fille[i] = new ClotureCaisseFille();
            fille[i].setIdCaisse(idCaisseCloture);
            fille[i].setMontantTheorique(this.getMontantTheoriqueFromEtatCaisse(idCaisseCloture, c));
            fille[i].setCaisseLib(caisseCloture[i].getVal());
            fille[i].setMontant(0);
        }
        return fille;
    }
    public double getMontantTheoriqueFromEtatCaisse(String idCaisse,Connection c)throws Exception{
        double montanttheorique = 0;
        EtatCaisse etatCaisse = new EtatCaisse();
        etatCaisse.setIdCaisse(idCaisse);
        EtatCaisse[] le = etatCaisse.getEtatCaisseByDate(null);
        System.out.println("le " + le.length);
        if(le.length>0){
            montanttheorique = le[0].getReste();
        }
        return montanttheorique;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public int getEtat() {
        return etat;
    }

    public void setEtat(int etat) {
        this.etat = etat;
    }


    public void checkClotureCaisseExistant(String idCaisse, Date daty, Connection c) throws Exception {
        ClotureCaisseFille cloture = new ClotureCaisseFille();
        cloture.setNomTable("CAISSECLOTURECPL_VISEE");
        String apresWhere = " AND IDCAISSE='"+idCaisse+"' AND DATY=TO_DATE('"+daty+"','YYYY-MM-DD')";
        ClotureCaisseFille[] res = (ClotureCaisseFille[]) CGenUtil.rechercher(cloture, null, null, c, apresWhere);
        if(res != null && res.length>0) {
            throw new Exception("Vous ne pouvez pas effectuer une cl\\u00F4ture de la m\\u00EAme caisse pour la m\\u00EAme date.");
        }
    }

    public String getIdPoint() {
        return idPoint;
    }

    public void setIdPoint(String idPoint) {
        this.idPoint = idPoint;
    }

    public String getPointLib() {
        return pointLib;
    }

    public void setPointLib(String pointLib) {
        this.pointLib = pointLib;
    }

    public String getIdCaisse() {
        return idCaisse;
    }

    public void setIdCaisse(String idCaisse) {
        this.idCaisse = idCaisse;
    }

    public String getExplication() {
        return explication;
    }

    public void setExplication(String explication) {
        this.explication = explication;
    }

    public String getIdUser() {
        return idUser;
    }

    public void setIdUser(String idUser) {
        this.idUser = idUser;
    }

    public ReportCaisse[] getReportCaisse() {
        return reportCaisse;
    }

    public void setReportCaisse(ReportCaisse[] reportCaisse) {
        this.reportCaisse = reportCaisse;
    }

//    public double getMontantTheorique() {
//        return montantTheorique;
//    }
//
//    public void setMontantTheorique(double montantTheorique) {
//        this.montantTheorique = montantTheorique;
//    }
//
//    public double getMontant() {
//        return montant;
//    }
//
//    public void setMontant(double montant) {
//        this.montant = montant;
//    }
}
