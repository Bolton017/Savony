package mg.cnaps.compta;

import utilitaire.Utilitaire;

public class ComptaSousEcritureLibJournal extends ComptaSousEcritureLib{

    private int jour;
    private String designationmere;
    private boolean estTotal;

    public void setEstTotal(boolean estTotal) {
        this.estTotal = estTotal;
    }

    public boolean getEstTotal() {
        return estTotal;
    }

    public int getJour() {
        return jour;
    }

    public void setJour(int jour) {
        this.jour = jour;
    }

    public String getDesignationmere() {
        return designationmere;
    }

    public void setDesignationmere(String designationmere) {
        this.designationmere = designationmere;
    }

    public ComptaSousEcritureLibJournal() throws Exception {
        this.setNomTable("COMPTA_SOUSECRITURE_LIB_J");
    }

    private String formattage(double value) throws Exception {
        return value != 0 ? Utilitaire.formaterAr(value) : "";
    }

    private String formattagejour(int value) throws Exception {
        return value != 0 ? String.valueOf(value) : "";
    }

    private String makeCell(Object value) {
        String content = (value != null) ? value.toString() : "";
        if (getEstTotal()) {
            content = "<b>" + content + "</b>";
        }
        if(content.startsWith("ECR")){
            return "<td class=\"idmere\" onclick=\"openEcriture('" + content + "')\">" + content + "</td>";
        }
        return "<td>" + content + "</td>";
    }

    public String makeLigne() throws Exception {
        StringBuilder retour = new StringBuilder();
        retour.append("<tr>");
        retour.append(makeCell(getIdMere()));
        retour.append(makeCell(formattagejour(getJour())));
        retour.append(makeCell(getDesignationmere()));
        retour.append(makeCell(getDaty()));
        retour.append(makeCell(getCompte()));
        retour.append(makeCell(formattage(getDebit())));
        retour.append(makeCell(formattage(getCredit())));

        retour.append("</tr>");
        return retour.toString();
    }
}
