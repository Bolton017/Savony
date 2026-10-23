package declaration;

import bean.ClassMAPTable;

public class ImprimerDeclaration extends ClassMAPTable {
    private String id;
    private String numero;
    private String rubrique;
    private double montant;
    private double taux;
    private double montantadeclarer;

    public double getMontant() {
        return montant;
    }
    public void setMontant(double montant) {
        this.montant = montant;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public String getRubrique() {
        return rubrique;
    }

    public void setRubrique(String rubrique) {
        this.rubrique = rubrique;
    }

    public ImprimerDeclaration() throws Exception {
        this.setNomTable("IMPRIMEDECLARATION");
    }

    public double getTaux() {
        return taux;
    }

    public void setTaux(double taux) {
        this.taux = taux;
    }

    public double getMontantadeclarer() {
        return montantadeclarer;
    }

    public void setMontantadeclarer(double montantadeclarer) {
        this.montantadeclarer = montantadeclarer;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
}

