/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package caisse;

import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;
import java.sql.Connection;
import java.sql.Date;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteAsync;
import utils.ConstanteSavonnerie;

/**
 *
 * @author nouta
 */
public class ReportCaisse extends ClassEtat{
    private String id, remarque ,idCaisse ;
    private double montant ,montantTheorique;
    private Date daty;
    String heure;
    String typeReport;
    String idUser;
    String caisseLib;
    String idSession;
    String idCategorieCaisse;
    String billetage;
    String idOrigine;

    public String getHeure() {
        return heure;
    }

    public void setHeure(String heure) {
        if((this.getMode().compareToIgnoreCase("modif")==0||this.getMode().compareToIgnoreCase("insert")==0)&&(heure==null||heure.equals(""))){
            heure=Utilitaire.heureCouranteHMS();
        }
        this.heure = heure;
    }
    public ReportCaisse() {
        super.setNomTable("REPORTCAISSE");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

   
    public String getIdCaisse() {
        return idCaisse;
    }

    public void setIdCaisse(String idCaisse) throws Exception {
        if (getMode().equals("modif") && (idCaisse == null || idCaisse.isEmpty() || idCaisse.equals(ConstanteAsync.CAISSE_DEFAUT))) {
            throw new Exception("Caisse Obligatoire");
        }
        this.idCaisse = idCaisse;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) throws Exception {
        if (getMode().equals("modif") && montant < 0) {
            throw new Exception("Montant non Valide !");
        }
        this.montant = montant;
    }

    public double getMontantTheorique() {
        return montantTheorique;
    }

    public void setMontantTheorique(double montantTheorique) {
        this.montantTheorique = montantTheorique;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    @Override
    public String getTuppleID() {
       return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("REC", "GETSEQREPORTCAISSE");
        this.setId(makePK(c));
    }
    
    protected void calculateMontantTheorique(Connection c) throws Exception{
        EtatCaisse et=new EtatCaisse();
        et.setId(this.getIdCaisse());
        EtatCaisse[] listetat=(EtatCaisse[]) CGenUtil.rechercher(et, null,null, c,"");
        double mt=0;
        if (listetat.length==1) {
            mt=listetat[0].getReste();
        }
        this.setMontantTheorique(mt);
    }
    
   @Override
    public ClassMAPTable createObject (String u, Connection c) throws Exception {
        if (getReportCaisseDuJours(c).length > 0){
            throw new Exception("Le report de caisse du jour existe d\\u00e9j\\u00e0 pour cette caisse");
        }
      this.calculateMontantTheorique(c);
      return super.createObject(u, c);
    }

    @Override
    public ClassMAPTable createObjectBatch(String u, Statement st) throws Exception {
        this.calculateMontantTheorique(st.getConnection());
        ClassMAPTable res = super.createObjectBatch(u, st);
        this.insertBilletage(u, st);
        return res;
    }

    private void insertBilletage(String u, Statement st) throws Exception {
        for (Billetage b : parseBilletage(this.getBilletage())) {
            b.setIdCloture(this.getIdOrigine());
            b.createObjectBatch(u, st);
        }
    }

    private Billetage[] parseBilletage(String billetage) throws Exception {
        List<Billetage> list = new ArrayList<>();
        if (billetage == null || billetage.trim().isEmpty()) return new Billetage[0];

        for (String part : billetage.split(";")) {
            part = part.trim();
            if (part.isEmpty()) continue;

            String[] kv = part.split(":");
            if (kv.length != 2) {
                throw new Exception("Billetage invalide : " + part);
            }
            int nombre;
            try {
                nombre = Integer.parseInt(kv[1].trim());
            } catch (NumberFormatException e) {
                throw new Exception("Nombre invalide dans le billetage : " + part);
            }
            if (nombre <= 0) continue;

            Billetage b = new Billetage();
            b.setDesce(kv[0].trim());
            b.setNombre(nombre);
            list.add(b);
        }
        return list.toArray(new Billetage[0]);
    }

    public  void genererMvtCaisse (String u, Connection c) throws Exception{
        MvtCaisse mvtcaisse = new MvtCaisse();
        boolean canClose=false;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                canClose=true;
            }
            double montantTheorique = this.getMontantTheorique();
            mvtcaisse.setIdReport(this.getId());
            mvtcaisse.setDesignation("Mouvement pour ecart du report "+this.getId());
            mvtcaisse.setIdDevise("AR");
            mvtcaisse.setIdOrigine(this.getId());
            mvtcaisse.setTaux(1);
            LocalDate localDate = this.getDaty().toLocalDate();
            LocalDate hier = localDate.minusDays(1);
            mvtcaisse.setDaty(Date.valueOf(hier));
            mvtcaisse.setIdCaisse(this.getIdCaisse());
            if(this.getMontant() > montantTheorique){
                mvtcaisse.setDebit(0);
                mvtcaisse.setCredit(this.getMontant()  - montantTheorique);
            }
            if(this.getMontant() < montantTheorique){
                mvtcaisse.setDebit(montantTheorique- this.getMontant());
                mvtcaisse.setCredit(0);
            }
            mvtcaisse.createObject(u, c);
            mvtcaisse.validerObject(u, c);

        } catch(Exception e){
            throw e;
        } finally {
            if(canClose){
                c.close();
            }
        }

    }

    public EtatCaisse getEtatCaisse(Connection c, String nomTable) throws Exception{
            EtatCaisse caissse = new EtatCaisse();
            caissse.setIdCaisse(this.getIdCaisse());
            if(nomTable!= null && nomTable.equalsIgnoreCase("")) {
                caissse.setNomTable(nomTable);
            }
            String daty = Utilitaire.dateDuJour().toString();
            EtatCaisse[] caisse = (EtatCaisse[]) CGenUtil.rechercher(caissse, caissse.getReqEtatCaisse(daty), c);
            if (caisse.length > 0) {
                return caisse[0];
            }
            return null;
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            EtatCaisse etatCaisse = this.getEtatCaisse(c,null);
            if (etatCaisse == null) {
                this.setMontantTheorique(0);
            } else {
                this.setMontantTheorique(etatCaisse.getReste());
            }
            if(this.getMontant() != this.getMontantTheorique())
                this.genererMvtCaisse(u, c);
            this.setHeure(Utilitaire.heureCouranteHMS());
            super.validerObject(u, c);
            if(estOuvert==true)c.commit();
            return this;

        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    public ReportCaisse[] genererCaisseAOuvrir(Caisse[] caisseCloture,Connection c) throws Exception {
        ReportCaisse[] fille = new ReportCaisse[caisseCloture.length];
        for(int i=0;i<caisseCloture.length;i++) {
            String idCaisseCloture=caisseCloture[i].getId();
            fille[i]=new ReportCaisse();
            fille[i].setIdCaisse(idCaisseCloture);
            fille[i].setMontantTheorique(this.getMontantTheoriqueFromEtatCaisse(idCaisseCloture,c));
            System.out.println(" this.getMontantTheorique +++++++ " + " caisse +++ " + idCaisseCloture+ " montant === " + this.getMontantTheoriqueFromEtatCaisse(idCaisseCloture, c));
            fille[i].setCaisseLib(caisseCloture[i].getVal());
            fille[i].setIdCategorieCaisse(caisseCloture[i].getIdCategorieCaisse());
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



    public String getTypeReport() {
        return typeReport;
    }

    public void setTypeReport(String typeReport) {
        this.typeReport = typeReport;
    }

    public String getIdUser() {
        return idUser;
    }

    public void setIdUser(String idUser) {
        this.idUser = idUser;
    }

    public String getCaisseLib() {
        return caisseLib;
    }

    public void setCaisseLib(String caisseLib) {
        this.caisseLib = caisseLib;
    }

    public String getIdSession() {
        return idSession;
    }

    public void setIdSession(String idSession) {
        this.idSession = idSession;
    }

    public String getIdCategorieCaisse() {
        return idCategorieCaisse;
    }

    public void setIdCategorieCaisse(String idCategorieCaisse) {
        this.idCategorieCaisse = idCategorieCaisse;
    }

    public double getEcartCalc () throws Exception {
        return this.getMontant()-this.getMontantTheorique();
    }

    public ReportCaisse[] getReportCaisseDuJours(Connection c) throws Exception {
        return (ReportCaisse[]) CGenUtil.rechercher( new ReportCaisse(), null, null,c, " and idCaisse = '" + this.getIdCaisse() + "' AND DATY = TO_DATE('"+ this.getDaty().toString() + "', 'YYYY-MM-DD')" );
    }

    public ReportCaisse[] genererCaisseAFermer(Caisse[] caisseCloture,Connection c) throws Exception {
        ReportCaisse[] fille = new ReportCaisse[caisseCloture.length];
        for(int i=0;i<caisseCloture.length;i++) {
            String idCaisseCloture=caisseCloture[i].getId();
            fille[i]=new ReportCaisse();
            fille[i].setIdCaisse(idCaisseCloture);
            fille[i].setMontantTheorique(this.getMontantTheoriqueFromEtatCaisse(idCaisseCloture,c));
            System.out.println(" this.getMontantTheorique +++++++ " + " caisse +++ " + idCaisseCloture+ " montant === " + this.getMontantTheoriqueFromEtatCaisse(idCaisseCloture, c));
            fille[i].setCaisseLib(caisseCloture[i].getVal());
            fille[i].setIdCategorieCaisse(caisseCloture[i].getIdCategorieCaisse());
            fille[i].setMontant(0);
            fille[i].setTypeReport(ConstanteAsync.type_report_fermeture);
        }
        return fille;
    }

    public String getBilletage() {
        return billetage;
    }

    public void setBilletage(String billetage) {
        this.billetage = billetage;
    }

    public String getIdOrigine() {
        return idOrigine;
    }

    public void setIdOrigine(String idOrigine) {
        this.idOrigine = idOrigine;
    }
}
