/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.log;

import bean.CGenUtil;
import bean.ClassMAPTable;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;

/**
 *
 * @author ASUS
 */
public class SigPersonnes extends ClassMAPTable {

    private String id;
    private String pers_nom;
    private String pers_prenom;
    private String pers_sexe;
    private String pers_numero_cin;
    private Date pers_date_cin;
    private Date pers_date_dupl_cin;
    private String pers_lieu_cin;
    private String pers_acte_nais;
    private Date pers_date_nais;
    private String pers_nationalite;
    private String pers_nom_pere;
    private String pers_nom_mere;
    private Date pers_date_deces;
    private Date pers_date_retraite;
    private String code_fkt_nais;
    private String pers_code_fkt;
    private String pers_adresse_lot;
    private String boite_postal, pere, mere;
    private String pers_telephone;

    private void controlCIN(Connection c) throws Exception {
        SigPersonnes[] tmp = (SigPersonnes[]) CGenUtil.rechercher(new SigPersonnes(), null, null, c, String.format(" and pers_numero_cin = '%s'", this.getPers_numero_cin()));
        
        if(tmp != null && tmp.length > 0) {
            throw new Exception("Doublon de CIN");
        }
    }
    
    @Override
    public void controler(Connection c) throws Exception {
        controlCIN(c);
    }

    public String getPers_telephone() {
        return pers_telephone;
    }

    public void setPers_telephone(String pers_telephone) {
        this.pers_telephone = pers_telephone;
    }

    @Override
    public boolean getEstIndexable() {
        return true;
    }

    /**
     * CONSTRUCTOR*
     */
    public SigPersonnes() {
        super.setNomTable("sig_personnes");
        super.setEstHistorise(true);
    }

    public String getPere() {
        return pere;
    }

    public void setPere(String pere) {
        this.pere = pere;
    }

    public String getMere() {
        return mere;
    }

    public void setMere(String mere) {
        this.mere = mere;
    }

    public SigPersonnes(String pers_nom, String pers_prenom, String pers_sexe, String pers_numero_cin, Date pers_date_cin, Date pers_date_dupl_cin, String pers_lieu_cin, String pers_acte_nais, Date pers_date_nais, String pers_nationalite, String pers_nom_pere, String pers_nom_mere, Date pers_date_deces, Date pers_date_retraite, String code_fkt_nais, String pers_code_fkt, String pers_adresse_lot) throws Exception {
        super.setNomTable("sig_personnes");
        this.pers_nom = pers_nom;
        this.pers_prenom = pers_prenom;
        this.pers_sexe = pers_sexe;
        this.setPers_numero_cin(pers_numero_cin);
        this.setPers_date_cin(pers_date_cin);
        this.setPers_date_dupl_cin(pers_date_dupl_cin);
        this.pers_lieu_cin = pers_lieu_cin;
        this.pers_acte_nais = pers_acte_nais;
        this.setPers_date_nais(pers_date_nais);
        this.pers_nationalite = pers_nationalite;
        this.pers_nom_pere = pers_nom_pere;
        this.pers_nom_mere = pers_nom_mere;
        this.setPers_date_deces(pers_date_deces);
        this.setPers_date_retraite(pers_date_retraite);
        this.code_fkt_nais = code_fkt_nais;
        this.pers_code_fkt = pers_code_fkt;
        this.pers_adresse_lot = pers_adresse_lot;
        super.setEstHistorise(true);
    }

    public SigPersonnes(String pers_nom, String pers_prenom, String pers_sexe, String pers_numero_cin, Date pers_date_cin, Date pers_date_dupl_cin, String pers_lieu_cin, String pers_acte_nais, Date pers_date_nais, String pers_nationalite, String pers_code_fkt, String pers_adresse_lot) throws Exception {
        super.setNomTable("sig_personnes");
        this.pers_nom = pers_nom;
        this.pers_prenom = pers_prenom;
        this.pers_sexe = pers_sexe;
        this.setPers_numero_cin(pers_numero_cin);
        this.setPers_date_cin(pers_date_cin);
        this.setPers_date_dupl_cin(pers_date_dupl_cin);
        this.pers_lieu_cin = pers_lieu_cin;
        this.pers_acte_nais = pers_acte_nais;
        this.setPers_date_nais(pers_date_nais);
        this.pers_nationalite = pers_nationalite;
        this.code_fkt_nais = code_fkt_nais;
        this.pers_code_fkt = pers_code_fkt;
        this.pers_adresse_lot = pers_adresse_lot;
        super.setEstHistorise(true);
    }

    public SigPersonnes(String pers_nom, String pers_prenom, String pers_sexe, String pers_numero_cin, String pers_date_cin, String pers_date_dupl_cin, String pers_lieu_cin, String pers_acte_nais, String pers_date_nais, String pers_nationalite, String pers_nom_pere, String pers_nom_mere, String pers_date_deces, String pers_date_retraite, String code_fkt_nais, String pers_code_fkt, String pers_adresse_lot) throws Exception {
        super.setNomTable("sig_personnes");
        this.setPers_nom(pers_nom);
        this.setPers_prenom(pers_prenom);
        this.setPers_sexe(pers_sexe);
        this.setPers_numero_cin(pers_numero_cin);
        this.setPers_date_cin(pers_date_cin);
        this.setPers_date_dupl_cin(pers_date_dupl_cin);
        this.setPers_lieu_cin(pers_lieu_cin);
        this.setPers_acte_nais(pers_acte_nais);
        this.setPers_date_nais(pers_date_nais);
        this.setPers_nationalite(pers_nationalite);
        this.pers_nom_pere = pers_nom_pere;
        this.pers_nom_mere = pers_nom_mere;
        this.setPers_date_deces(pers_date_deces);
        this.setPers_date_retraite(pers_date_retraite);
        this.code_fkt_nais = code_fkt_nais;
        this.pers_code_fkt = pers_code_fkt;
        this.pers_adresse_lot = pers_adresse_lot;
        super.setEstHistorise(true);
    }

    /**
     * FUNCTIONS*
     */
    public String getTuppleID() {
        return id;
    }

    public String getAttributIDName() {
        return "id";
    }

    public void construirePK(Connection c) throws Exception {

        this.preparePk("PERS", "getSeqsigpersonnes");
        this.setId(makePK(c));
    }

    /**
     * GETTERS*
     */
    public String getId() {
        return id;
    }

    public String getPers_nom() {
        return Utilitaire.champNull(pers_nom);
    }

    public String getPers_prenom() {
        return Utilitaire.champNull(pers_prenom);
    }

    public String getPers_sexe() {
        return Utilitaire.champNull(pers_sexe);
    }

    public String getPers_numero_cin() {
        return Utilitaire.champNull(pers_numero_cin);
    }

    public Date getPers_date_cin() {
        return pers_date_cin;
    }

    public Date getPers_date_dupl_cin() {
        return pers_date_dupl_cin;
    }

    public String getPers_lieu_cin() {
        return Utilitaire.champNull(pers_lieu_cin);
    }

    public String getPers_acte_nais() {
        return Utilitaire.champNull(pers_acte_nais);
    }

    public Date getPers_date_nais() {
        return pers_date_nais;
    }

    public String getPers_nationalite() {
        return Utilitaire.champNull(pers_nationalite);
    }

    public String getPers_nom_pere() {
        return Utilitaire.champNull(pers_nom_pere);
    }

    public String getPers_nom_mere() {
        return Utilitaire.champNull(pers_nom_mere);
    }

    public Date getPers_date_deces() {
        return pers_date_deces;
    }

    public Date getPers_date_retraite() {
        return pers_date_retraite;
    }

    public String getCode_fkt_nais() {
        return Utilitaire.champNull(code_fkt_nais);
    }

    public String getPers_code_fkt() {
        return Utilitaire.champNull(pers_code_fkt);
    }

    public String getPers_adresse_lot() {
        return Utilitaire.champNull(pers_adresse_lot);
    }

    /**
     * SETTERS*
     */
    public void setId(String id) {
        this.id = id;
    }

    public void setPers_nom(String pers_nom) throws Exception {
        this.pers_nom = pers_nom;
    }

    public void setPers_prenom(String pers_prenom) throws Exception {
        this.pers_prenom = pers_prenom;
    }

    public void setPers_sexe(String pers_sexe) throws Exception {
        this.pers_sexe = pers_sexe;
    }

    public void setPers_numero_cin(String pers_numero_cin) throws Exception {
        if (this.getMode().compareToIgnoreCase("modif") != 0) {
            this.pers_numero_cin = pers_numero_cin;
            return;
        }
        if (pers_numero_cin != null && pers_numero_cin.compareToIgnoreCase("") != 0 && pers_numero_cin.length() != 12) {
            throw new Exception("Le num?ro du CIN doit comporter exactement 12 caract?res.");
        }
        this.pers_numero_cin = pers_numero_cin;
    }

    public void setPers_date_cin(Date pers_date_cin) throws Exception {
        this.pers_date_cin = pers_date_cin;
    }

    public void setPers_date_cin(String pers_date_cin) throws Exception {
        setPers_date_cin(Utilitaire.stringDate(pers_date_cin));
    }

    public void setPers_date_dupl_cin(Date pers_date_dupl_cin) throws Exception {
        this.pers_date_dupl_cin = pers_date_dupl_cin;
    }

    public void setPers_date_dupl_cin(String pers_date_dupl_cin) throws Exception {
        setPers_date_dupl_cin(Utilitaire.stringDate(pers_date_dupl_cin));
    }

    public void setPers_lieu_cin(String pers_lieu_cin) throws Exception {
        this.pers_lieu_cin = pers_lieu_cin;
    }

    public void setPers_acte_nais(String pers_acte_nais) throws Exception {
        this.pers_acte_nais = pers_acte_nais;
    }

    public void setPers_date_nais(Date pers_date_nais) throws Exception {
        if (pers_date_nais != null) {
            int anneeEnCours = Utilitaire.getAneeEnCours();
            int anneeDate = Utilitaire.getAnnee(pers_date_nais);
            int diffJourdate = Utilitaire.diffJourDaty(pers_date_nais, Utilitaire.dateDuJourSql());
            if (this.getMode().compareToIgnoreCase("modif") == 0 && pers_date_nais == null) {
                throw new Exception("Date de naissance obligatoire");
            }
            if (this.getMode().compareToIgnoreCase("modif") == 0 && anneeEnCours - anneeDate > 200) {
                throw new Exception("date de naissance trop ancienne");
            }
            if (this.getMode().compareToIgnoreCase("modif") == 0 && diffJourdate > 0) {
                throw new Exception("Naissance superieur a la date du jour");
            }
            this.pers_date_nais = pers_date_nais;
        } else {
            throw new Exception("Date de naissance ne doit pas etre vide");
        }
    }

    public void setPers_date_nais(String pers_date_nais) throws Exception {
        setPers_date_nais(Utilitaire.stringDate(pers_date_nais));
    }

    public void setPers_nationalite(String pers_nationalite) throws Exception {
        this.pers_nationalite = pers_nationalite;
    }

    public void setPers_nom_pere(String pers_nom_pere) throws Exception {
        this.pers_nom_pere = pers_nom_pere;
    }

    public void setPers_nom_mere(String pers_nom_mere) throws Exception {
        this.pers_nom_mere = pers_nom_mere;
    }

    public void setPers_date_deces(Date pers_date_deces) throws Exception {
        if (pers_date_deces != null) {
            int anneeEnCours = Utilitaire.getAneeEnCours();
            int anneeDate = Utilitaire.getAnnee(pers_date_deces);
            int diffJourdate = Utilitaire.diffJourDaty(pers_date_deces, Utilitaire.dateDuJourSql());
            int diffJourDecesNaissance = Utilitaire.diffJourDaty(pers_date_deces, getPers_date_nais());
            if (this.getMode().compareToIgnoreCase("modif") == 0 && diffJourDecesNaissance <= 0 && pers_date_deces != null) {
                throw new Exception("date de deces inferieur a la date de naissance");
            }
            if (this.getMode().compareToIgnoreCase("modif") == 0 && diffJourdate > 0 && pers_date_deces != null) {
                throw new Exception("Deces superieur a la date du jour");
            }
        }
        this.pers_date_deces = pers_date_deces;
    }

    public void setPers_date_deces(String pers_date_deces) throws Exception {
        setPers_date_deces(Utilitaire.stringDate(pers_date_deces));
    }

    public void setPers_date_retraite(Date pers_date_retraite) throws Exception {

        if (pers_date_retraite != null && getMode().compareToIgnoreCase("modif") == 0) {
            int anneeEnCours = Utilitaire.getAneeEnCours();

            int anneeDate = Utilitaire.getAnnee(pers_date_retraite);
            int diffJourdate = Utilitaire.diffJourDaty(pers_date_retraite, Utilitaire.dateDuJourSql());
            int diffJourDecesNaissance = Utilitaire.diffJourDaty(pers_date_retraite, getPers_date_nais());
            if (this.getMode().compareToIgnoreCase("modif") == 0 && diffJourDecesNaissance <= 0 && pers_date_retraite != null) {
                throw new Exception("date de retraite inferieur a la date de naissance");
            }
            if (this.getMode().compareToIgnoreCase("modif") == 0 && diffJourdate > 0 && pers_date_retraite != null) {
                throw new Exception("Retraite superieur a la date du jour");
            }
            int diffJourDecesRetraite = Utilitaire.diffJourDaty(pers_date_retraite, getPers_date_deces());
            if (this.getMode().compareToIgnoreCase("modif") == 0 && diffJourDecesRetraite > 0 && pers_date_retraite != null) {
                throw new Exception("Retraite superieur a la date du deces");
            }
        }
        this.pers_date_retraite = pers_date_retraite;
    }

    public void setPers_date_retraite(String pers_date_retraite) throws Exception {
        setPers_date_retraite(Utilitaire.stringDate(pers_date_retraite));
    }

    public void setCode_fkt_nais(String code_fkt_nais) throws Exception {
        this.code_fkt_nais = code_fkt_nais;
    }

    public void setPers_code_fkt(String pers_code_fkt) throws Exception {
        this.pers_code_fkt = pers_code_fkt;
    }

    public void setPers_adresse_lot(String pers_adresse_lot) throws Exception {
        this.pers_adresse_lot = pers_adresse_lot;
    }

    public void setUpdate(String nom, String prenom, String sexe, String numcin, Date datecin, Date dateduplcin, String lieucin, String actenais, Date datenais, String nationalite, String pere, String mere, Date datedeces, Date dateretraite, String code_fkt_nais, String pers_code_fkt, String adresse) throws Exception {
        super.setNomTable("sig_personnes");
        this.pers_nom = nom;
        this.pers_prenom = prenom;
        this.pers_sexe = sexe;
        this.setPers_numero_cin(numcin);
        this.setPers_date_cin(datecin);
        this.setPers_date_dupl_cin(dateduplcin);
        this.pers_lieu_cin = lieucin;
        this.pers_acte_nais = actenais;
        this.setPers_date_nais(datenais);
        this.pers_nationalite = nationalite;
        this.pers_nom_pere = pere;
        this.pers_nom_mere = mere;
        this.setPers_date_deces(datedeces);
        this.setPers_date_retraite(dateretraite);
        this.code_fkt_nais = code_fkt_nais;
        this.pers_code_fkt = pers_code_fkt;
        this.pers_adresse_lot = adresse;
    }

    /**
     * @return the boite_postale
     */
    public String getBoite_postal() {
        return boite_postal;
    }

    /**
     * @param boite_postale the boite_postale to set
     */
    public void setBoite_postal(String boite_postale) {
        this.boite_postal = boite_postale;
    }
}
