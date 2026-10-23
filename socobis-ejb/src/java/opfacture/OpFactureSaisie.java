package opfacture;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMAPTable;
import caisse.MvtCaisse;
import faturefournisseur.FactureFournisseur;
import paiement.LiaisonPaiement;
import utilitaire.UtilDB;

import java.sql.Connection;

public class OpFactureSaisie extends OpFacture {
    private String idCaisse;
    private String designation;

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

    public OpFactureSaisie() throws Exception {
        this.setNomTable("OPFACTURESAISIE");
    }

    public OpFactureSaisie getOpFactureByidOp() throws Exception {
        OpFacture op = new OpFacture();
        op.setIdop(this.getIdop());
        OpFacture[] opFactures = (OpFacture[]) CGenUtil.rechercher(op,null,null,null,"");
        if (opFactures.length == 0) {
            return null;
        }
        double montant = AdminGen.calculSommeDouble(opFactures,"montant");
        String[] idFactures = new String[opFactures.length];
        for (int i = 0; i < opFactures.length; i++) {
            idFactures[i] = opFactures[i].getIdfacture();
        }
        String idFacture = String.join(";",idFactures);
        OpFactureSaisie o = new OpFactureSaisie();
        o.setIdop(this.getIdop());
        o.setIdfacture(idFacture);
        o.setMontant(montant);
        o.setDesignation("R\u00E8glement ordre de paiement : "+this.getIdop());
        return o;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        OpFacture op = new OpFacture();
        op.setIdop(this.getIdop());
        OpFacture[] opFactures = (OpFacture[]) CGenUtil.rechercher(op,null,null,null,"");
        if (opFactures.length == 0) {
            throw new Exception("Aucun ordre de paiement factures");
        }
        FactureFournisseur facture = (FactureFournisseur) new FactureFournisseur().getById(opFactures[0].getIdfacture(),null,c);
        MvtCaisse mc = new MvtCaisse();
        mc.setIdOp(this.getIdop());
        mc.setIdTiers(facture.getTiers());
        mc.setIdOrigine(this.getIdop());
        mc.setIdCaisse(this.getIdCaisse());
        mc.setDaty(this.getDaty());
        mc.setDesignation(this.getDesignation());
        double montant = AdminGen.calculSommeDouble(opFactures,"montant");
        mc.setDebit(montant);
        mc.createObject(u,c);
        mc.validerObject(u,c);

        for (OpFacture opf : opFactures) {
            LiaisonPaiement lp = new LiaisonPaiement();
            lp.setId1(mc.getId());
            lp.setId2(opf.getIdfacture());
            lp.setMontant(opf.getMontant());
            lp.createObject(u,c);
            lp.validerObject(u,c);
        }
        mc.setId(this.getIdop());
        return mc;
    }
}
