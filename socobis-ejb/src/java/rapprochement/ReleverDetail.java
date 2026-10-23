package rapprochement;

import bean.CGenUtil;
import bean.ClassFille;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;

public class ReleverDetail extends ClassFille {
    private String id;
    private String idMere;
    private Date daty;
    private String designation;
    private double debit;
    private double credit;
    private Date datyvaleur;
    private double solde;

    public static ReleverDetailCpl[] getReleveDetail(String[] ids) throws Exception{
        ReleverDetailCpl[] res = (ReleverDetailCpl[]) CGenUtil.rechercher(new ReleverDetailCpl(), null,null,null," and id in ("+ Utilitaire.tabToString(ids, "'", ",")+" )");
        return res;
    }

    public double getSolde() {
        return solde;
    }

    public void setSolde(double solde) {
        this.solde = solde;
    }

    public Date getDatyvaleur() {   return datyvaleur;  }

    public void setDatyvaleur(Date datyvaleur) {    this.datyvaleur = datyvaleur;}

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdMere() {
        return idMere;
    }

    public void setIdMere(String idMere) {
        this.idMere = idMere;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public double getDebit() {
        return debit;
    }

    public void setDebit(double debit) {
        this.debit = debit;
    }

    public double getCredit() {
        return credit;
    }

    public void setCredit(double credit) {
        this.credit = credit;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("RED", "getSeqReleverDetail");
        this.setId(makePK(c));
    }


    public ReleverDetail() {
        this.setNomTable("ReleverDetail");
        this.setLiaisonMere("rapprochement.Relever");
        this.setLiaisonMere("idMere");
    }

    @Override
    public String getLiaisonMere() {
        return "idMere";
    }

    @Override
    public String getNomClasseMere() {
        return "rapprochement.Relever";
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public Relever getRelever(Connection c) throws Exception{
        Relever [] rel = (Relever []) CGenUtil.rechercher(new Relever(), null,null,null," and id='"+this.getIdMere()+"'");
        return rel[0];
    }
}
