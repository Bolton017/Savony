package ordredepaiement;

import bean.ClassEtat;
import bean.ClassMAPTable;
import faturefournisseur.FactureFournisseurCpl;
import opfacture.OpFacture;

import java.sql.Connection;
import java.sql.Date;

public class OrdreDePaiement extends ClassEtat {
    private String id;
    private String idfacts;
    private Date daty;
    private double montant;
    private String remarque;
    private String numeroop;
    private String modepaiement;
    private String tiers;
    private String iduser;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdfacts() {
        return idfacts;
    }

    public void setIdfacts(String idfacts) {
        this.idfacts = idfacts;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getNumeroop() {
        return numeroop;
    }

    public void setNumeroop(String numeroop) {
        this.numeroop = numeroop;
    }

    public String getModepaiement() {
        return modepaiement;
    }

    public void setModepaiement(String modepaiement) {
        this.modepaiement = modepaiement;
    }

    public String getTiers() {
        return tiers;
    }

    public void setTiers(String tiers) {
        this.tiers = tiers;
    }

    public String getIduser() {
        return iduser;
    }

    public void setIduser(String iduser) {
        this.iduser = iduser;
    }



    public OrdreDePaiement() throws Exception {
        this.setNomTable("ORDREDEPAIEMENT");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("ORDP","getSeqOrdrePaiement");
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

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        OrdreDePaiement createdOp = (OrdreDePaiement) super.createObject(u, c);
        setId(createdOp.getId());
        OpFacture[] opfs = genererOpFacture(u, c);
        return createdOp;
    }

    public OpFacture genererOpFacture(FactureFournisseurCpl factureFournisseur, String u, Connection c) throws Exception {
        OpFacture opf = new OpFacture();
        opf.setIdfacture(factureFournisseur.getId());
        opf.setDaty(this.getDaty());
        opf.setMontant(factureFournisseur.getMontantreste());
        opf.setIdop(this.getId());
        opf.createObject(u, c);
        return opf;
    }

    public OpFacture[] genererOpFacture(String u, Connection c) throws Exception {
        String[] idfacts = this.getIdfacts().split(";");
        OpFacture[] opfs = new OpFacture[idfacts.length];
        for (int i = 0; i < idfacts.length; i++) {
            FactureFournisseurCpl f = (FactureFournisseurCpl) new FactureFournisseurCpl().getById(idfacts[i],null, c);
            opfs[i] = genererOpFacture(f, u, c);
        }
        return opfs;
    }
}

