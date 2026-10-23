package vente;

import bean.ClassMAPTable;
import utils.ConstanteAsync;

import java.util.List;

public class PaiementInfo extends ClassMAPTable {
    private String reference;
    private double montant;
    private String modePaiement;
    private String idCaisse;

    @Override
    public String getTuppleID() {
        return getReference();
    }

    @Override
    public String getAttributIDName() {
        return "reference";
    }

    public PaiementInfo(String modePaiement, double montant, String reference) {
        this.modePaiement = modePaiement;
        this.montant = montant;
        this.reference = reference;
    }

    public PaiementInfo(double montant, String reference) {
        this.montant = montant;
        this.reference = reference;
    }

    public PaiementInfo() {
    }

    public void ajouterPaiement(
            List<PaiementInfo> liste,
            String mode,
            String idCaisse,
            String montantStr,
            String reference) {

        if (montantStr == null || montantStr.trim().isEmpty()) {
            return;
        }

        double montant = Double.parseDouble(montantStr);

        if (montant <= 0) {
            return;
        }

        PaiementInfo p = new PaiementInfo();
        p.setMontant(montant);
        p.setReference(reference);
        p.setIdCaisse(idCaisse);

        liste.add(p);
    }

    public String getReference() { return reference; }
    public double getMontant() { return montant; }

    public String getModePaiement() {
        return modePaiement;
    }

    public void setModePaiement(String modePaiement) {
        this.modePaiement = modePaiement;
    }

    public void setIdCaisse(String idCaisse) {
        this.idCaisse = idCaisse;

        if (ConstanteAsync.caisseCategEspeece.equals(idCaisse)) {
            this.modePaiement = ConstanteAsync.PAIEMENT_ESPECE;
        } else if (ConstanteAsync.caisseCategMvola.equals(idCaisse)
                || ConstanteAsync.caisseCategOrange.equals(idCaisse)
                || ConstanteAsync.caisseCategAirtel.equals(idCaisse)) {
            this.modePaiement = ConstanteAsync.PAIEMENT_MOBILEMONEY;
        } else if (ConstanteAsync.caisseCategCheque.equals(idCaisse)) {
            this.modePaiement = ConstanteAsync.PAIEMENT_CHEQUE;
        } else if (ConstanteAsync.caisseCategTpe.equals(idCaisse)) {
            this.modePaiement = ConstanteAsync.PAIEMENT_CARTE;
        } else if (ConstanteAsync.caisseBonAchat.equals(idCaisse)) {
            this.modePaiement = ConstanteAsync.PAIEMENT_BONACHAT;
        } else if (ConstanteAsync.caisseCadeaux.equals(idCaisse)) {
            this.modePaiement = ConstanteAsync.PAIEMENT_CARTECADEUAX;
        }
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public String getIdCaisse() {
        return idCaisse;
    }

    public static String getIdCaisseFromModePaiement(String modePaiement) {

        if ("mvola".equals(modePaiement)) {
            return ConstanteAsync.caisseCategMvola;
        } else if ("airtel".equals(modePaiement)) {
            return ConstanteAsync.caisseCategAirtel;
        } else if ("orange".equals(modePaiement)) {
            return ConstanteAsync.caisseCategOrange;
        } else if ("visa".equals(modePaiement)) {
            return ConstanteAsync.caisseCategTpe;
        } else if ("cheque".equals(modePaiement)) {
            return ConstanteAsync.caisseCategCheque;
        } else if ("especes".equals(modePaiement)) {
            return ConstanteAsync.caisseCategEspeece;
        } else if ("bonAchat".equals(modePaiement)) {
            return ConstanteAsync.caisseBonAchat;
        } else if ("cadeaux".equals(modePaiement)) {
            return ConstanteAsync.caisseCadeaux;
        }

        return null;
    }






}