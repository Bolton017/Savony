package caisse;
import java.sql.Connection;
import java.sql.Date;
import java.sql.Statement;
import java.util.ArrayList;

import bean.CGenUtil;
import bean.ClassFille;
import bean.ClassMAPTable;
import constante.ConstanteEtat;
import facture.tr.Traite;
import faturefournisseur.FactureFournisseurCpl;
import paiement.LiaisonPaiement;
import prevision.MvtCaissePrevision;
import prevision.PrevisionComplet;
import utilitaire.UtilDB;
import vente.VenteLib;

public class MouvementCaisseFille extends ClassFille {
    private String id,designation,idCaisse,idVenteDetail,idVirement,idOp,idOrigine, idtraite,idTiers;
    protected String idDevise;
    private double debit,credit,taux;
    private Date daty;
    private String idPrevision;
    private String compte;
    private String idModePaiement;
    private int etatversement;
    private Traite traite;
    private String reference;
    private String idmvtcaissemere;
    private String heure;
    private String idCassier;

    @Override
    public ClassMAPTable createObjectBatch(String u, Statement st) throws Exception {
        if (getDebit() == 0 && getCredit() == 0) {
            throw new Exception("D\u00E9bit et cr\u00E9dit ne doit pas 0 en m\u00EAme temps.");
        }
        return super.createObjectBatch(u, st);
    }

    public MouvementCaisseFille() throws Exception {
        this.setNomTable("mouvementcaisse");
        setLiaisonMere("idmvtcaissemere");
        setNomClasseMere("caisse.MouvementCaisseMere");
    }
     @Override
    public String getNomClasseMere()
    {
        return "caisse.MouvementCaisseMere";
    }
    public String getLiaisonMere() {
        return "idmvtcaissemere";
    }
    @Override
    public String getAttributIDName() {
        return "id";
    }
    @Override
    public String getTuppleID() {
        return id;
    }
     @Override
    public void construirePK(java.sql.Connection c) throws Exception {  
        this.preparePk("MVTF", "GETSEQMOUVEMENTCAISSE");
        this.setId(makePK(c));
    }

    public String getHeure() {
        return heure;
    }

    public void setHeure(String heure) {
        this.heure = heure;
    }

    public String getIdCassier() {
        return idCassier;
    }

    public void setIdCassier(String idCassier) {
        this.idCassier = idCassier;
    }

    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }
    public String getDesignation() {
        return designation;
    }
    public void setDesignation(String designation) {
        this.designation = designation;
    }
    public String getIdCaisse() {
        return idCaisse;
    }
    public void setIdCaisse(String idCaisse) {
        this.idCaisse = idCaisse;
    }
    public String getIdVenteDetail() {
        return idVenteDetail;
    }
    public void setIdVenteDetail(String idVenteDetail) {
        this.idVenteDetail = idVenteDetail;
    }
    public String getIdVirement() {
        return idVirement;
    }
    public void setIdVirement(String idVirement) {
        this.idVirement = idVirement;
    }
    public String getIdOp() {
        return idOp;
    }
    public void setIdOp(String idOp) {
        this.idOp = idOp;
    }
    public String getIdOrigine() {
        return idOrigine;
    }
    public void setIdOrigine(String idOrigine) {
        this.idOrigine = idOrigine;
    }
    public String getIdtraite() {
        return idtraite;
    }
    public void setIdtraite(String idtraite) {
        this.idtraite = idtraite;
    }
    public String getIdTiers() {
        return idTiers;
    }
    public void setIdTiers(String idTiers) {
        this.idTiers = idTiers;
    }
    public String getIdDevise() {
        return idDevise;
    }
    public void setIdDevise(String idDevise) {
        this.idDevise = idDevise;
    }
    public double getDebit() {
        return debit;
    }
    public void setDebit(double debit) throws Exception {
        if (getMode().equals("modif") && debit < 0) {
            throw new Exception("Montant Invalide.");
        }
        this.debit = debit;
    }
    public double getCredit() {
        return credit;
    }
    public void setCredit(double credit) throws Exception {
        if (getMode().equals("modif") && credit < 0) {
            throw new Exception("Montant Invalide.");
        }
        this.credit = credit;
    }
    public double getTaux() {
        return taux;
    }
    public void setTaux(double taux) {
        this.taux = taux;
    }
    public Date getDaty() {
        return daty;
    }
    public void setDaty(Date daty) {
        this.daty = daty;
    }
    public String getIdPrevision() {
        return idPrevision;
    }
    public void setIdPrevision(String idPrevision) {
        this.idPrevision = idPrevision;
    }
    public String getCompte() {
        return compte;
    }
    public void setCompte(String compte) {
        this.compte = compte;
    }
    public String getIdModePaiement() {
        return idModePaiement;
    }
    public void setIdModePaiement(String idModePaiement) {
        this.idModePaiement = idModePaiement;
    }
    public int getEtatversement() {
        return etatversement;
    }
    public void setEtatversement(int etatversement) {
        this.etatversement = etatversement;
    }
    public Traite getTraite() {
        return traite;
    }
    public void setTraite(Traite traite) {
        this.traite = traite;
    }
    public String getIdmvtcaissemere() {
        return idmvtcaissemere;
    }
    public void setIdmvtcaissemere(String idmvtcaissemere) {
        this.idmvtcaissemere = idmvtcaissemere;
    }
    public String getReference() {
        return reference;
    }
    public void setReference(String reference) {
        this.reference = reference;
    }

    public void validerSimple(String u, Connection c) throws Exception {
        boolean estOuvert=false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                estOuvert = true;
            }
            MouvementCaisseFille caisse = (MouvementCaisseFille) new MouvementCaisseFille().getById(getId(), null, c);
            caisse.setEtat(ConstanteEtat.getEtatProforma());
            caisse.updateToTableWithHisto(u, c);

            MvtCaissePrevision[] lienMvtPrev = this.attacherPrevisionAutomatique(u, c);
            for(MvtCaissePrevision mvt:lienMvtPrev)
            {
                mvt.createObject(u, c);
            }
        } catch (Exception e) {
            if(estOuvert) c.rollback();
            throw e;
        } finally {
            if(estOuvert) c.close();
        }
    }

    public MvtCaissePrevision[] attacherPrevisionAutomatique(String u, Connection c) throws Exception{
        PrevisionComplet prevision = new PrevisionComplet();
        //Prevision[] previsions = (Prevision[]) CGenUtil.rechercher(prevision, null, null, c, " and IDFACTURE  = '"+this.getIdOrigine()+"'");
        PrevisionComplet[] previsionComplets =  this.getPrevisionLie("PREVISION_COMPLET_CPLPOSITIF", c);
        MvtCaissePrevision[] lien=this.attacherPrevision(previsionComplets, u, c);
        return lien;
    }

    public PrevisionComplet[] getPrevisionLie(String nomT,Connection c) throws Exception
    {
        PrevisionComplet prevision = new PrevisionComplet();
        if(nomT!=null&&nomT.compareToIgnoreCase("")!=0)prevision.setNomTable(nomT);
        //Prevision[] previsions = (Prevision[]) CGenUtil.rechercher(prevision, null, null, c, " and IDFACTURE  = '"+this.getIdOrigine()+"'");
        PrevisionComplet[] previsionComplets = (PrevisionComplet[]) CGenUtil.rechercher(prevision, null, null, c, " and IDFACTUREMERE  = '"+this.getIdOrigine()+"' order by daty ASC");
        return previsionComplets;
    }

    public MvtCaissePrevision[] attacherPrevision(PrevisionComplet[] listePrevision ,String u,Connection c)throws Exception {

        ArrayList<MvtCaissePrevision> attachements = new ArrayList<MvtCaissePrevision>();
        double reste = this.getMontantMouvement();
        double valeur=reste;
        int i=0;
        for(PrevisionComplet prevision : listePrevision){
            if(prevision.getEcart()>0&&i<listePrevision.length-1){
                valeur=Math.min(reste,prevision.getEcart());
            }
            MvtCaissePrevision attachement = new MvtCaissePrevision();
            attachement.setId1(this.getId());
            attachement.setId2(prevision.getId());
            attachement.setMontant(valeur,prevision);
            attachement.setEtat(this.getEtat());
            attachement.setDevise("AR");
            attachement.setTaux(1);
            attachements.add(attachement);
            reste = Math.max(0, reste-valeur);
            valeur=reste;
            if(reste<= 0) break;

            i++;
        }
        return attachements.toArray(new MvtCaissePrevision[attachements.size()]);
    }

    public void validerSimpleBatch(String u, Statement stmt) throws Exception
    {
        try{

            this.setEtat(ConstanteEtat.getEtatValider());
            this.updateToTableWithHistoBatch(u, stmt);

            MvtCaissePrevision[] lienMvtPrev = this.attacherPrevisionAutomatique(u, stmt.getConnection());

            for(MvtCaissePrevision mvt:lienMvtPrev)
            {
                mvt.createObjectBatch(u, stmt);
            }

        } catch (Exception e) {
            throw e;
        }

    }

    public double getMontantMouvement() throws Exception{
        if(this.isDepense()) return this.getDebit()*this.getTaux();
        return this.getCredit()*this.getTaux();
    }
    public boolean isDepense()
    {
        if(this.getDebit()>0&&this.getCredit()<=0) return true;
        return false;
    }
}
