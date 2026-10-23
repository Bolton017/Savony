package paie.paiement;

public class PaiementSalaireLib extends PaiementSalaire {
    String bu;
    String buLib;
    String matricule;
    String modePaiementLib;
    String etatLib;
    String nomPersonnel;
    private String uniteLib;
    private String idSectionLib;
    private String directionLib;
    private String idSocete, idSocieteLib;

    public String getBu() {
        return bu;
    }

    public void setBu(String bu) {
        this.bu = bu;
    }

    public String getBuLib() {
        return buLib;
    }

    public void setBuLib(String buLib) {
        this.buLib = buLib;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getModePaiementLib() {
        return modePaiementLib;
    }

    public void setModePaiementLib(String modePaiementLib) {
        this.modePaiementLib = modePaiementLib;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }

    public PaiementSalaireLib() throws Exception {
        this.setNomTable("PAIEMENT_SALAIRE_LIB");
    }

    public String getNomPersonnel() {
        return nomPersonnel;
    }

    public void setNomPersonnel(String nomPersonnel) {
        this.nomPersonnel = nomPersonnel;
    }

    public String getUniteLib() {
        return uniteLib;
    }

    public void setUniteLib(String uniteLib) {
        this.uniteLib = uniteLib;
    }

    public String getIdSectionLib() {
        return idSectionLib;
    }

    public void setIdSectionLib(String idSectionLib) {
        this.idSectionLib = idSectionLib;
    }

    public String getDirectionLib() {
        return directionLib;
    }

    public void setDirectionLib(String directionLib) {
        this.directionLib = directionLib;
    }

    public String getIdSocete() {
        return idSocete;
    }

    public void setIdSocete(String idSocete) {
        this.idSocete = idSocete;
    }

    public String getIdSocieteLib() {
        return idSocieteLib;
    }

    public void setIdSocieteLib(String idSocieteLib) {
        this.idSocieteLib = idSocieteLib;
    }
}
