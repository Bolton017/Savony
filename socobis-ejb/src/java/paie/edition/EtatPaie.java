package paie.edition;

import bean.CGenUtil;
import bean.ClassMAPTable;

public class EtatPaie extends ClassMAPTable {

    private String id;
    private String matricule;
    private String nom;
    private int mois;
    private int annee;

    private double salaire;
    private double hs_m;
    private double indem;
    private double ancien;
    private double prime;
    private double autres;
    private double total;
    private double cnaps;
    private double ostie;
    private double irsa_e;
    private double irsa_s;
    private double av_spe;
    private double autres2;
    private double a_payer;

    public EtatPaie() {
        this.setNomTable("SITUATION_SALAIRE_EDITION");
    }

    public EtatPaie[] getAllEtatPaies() throws Exception {
        return (EtatPaie[]) CGenUtil.rechercher(this, null, null, " ");
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public double getSalaire() {
        return salaire;
    }

    public void setSalaire(double salaire) {
        this.salaire = salaire;
    }

    public double getHs_m() {
        return hs_m;
    }

    public void setHs_m(double hs_m) {
        this.hs_m = hs_m;
    }

    public double getIndem() {
        return indem;
    }

    public void setIndem(double indem) {
        this.indem = indem;
    }

    public double getAncien() {
        return ancien;
    }

    public void setAncien(double ancien) {
        this.ancien = ancien;
    }

    public double getPrime() {
        return prime;
    }

    public void setPrime(double prime) {
        this.prime = prime;
    }

    public double getAutres() {
        return autres;
    }

    public void setAutres(double autres) {
        this.autres = autres;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public double getCnaps() {
        return cnaps;
    }

    public void setCnaps(double cnaps) {
        this.cnaps = cnaps;
    }

    public double getOstie() {
        return ostie;
    }

    public void setOstie(double ostie) {
        this.ostie = ostie;
    }

    public double getIrsa_e() {
        return irsa_e;
    }

    public void setIrsa_e(double irsa_e) {
        this.irsa_e = irsa_e;
    }

    public double getIrsa_s() {
        return irsa_s;
    }

    public void setIrsa_s(double irsa_s) {
        this.irsa_s = irsa_s;
    }

    public double getAv_spe() {
        return av_spe;
    }

    public void setAv_spe(double av_spe) {
        this.av_spe = av_spe;
    }

    public double getAutres2() {
        return autres2;
    }

    public void setAutres2(double autres2) {
        this.autres2 = autres2;
    }

    public double getA_payer() {
        return a_payer;
    }

    public void setA_payer(double a_payer) {
        this.a_payer = a_payer;
    }
}
