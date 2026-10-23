/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package faturefournisseur;


import bean.CGenUtil;
import fichier.AttacherFichier;
import uploadbean.UploadService;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;

public class As_BonDeCommandeCpl extends As_BonDeCommande{
    double montantTVA;
    double montantHT;
    double montantTTC;
    double montantTTCAriary;
    String idDeviselib;
    String etatLib;
    String idMagasin;
    String idMagasinlib;
    private String serviceLib;

    public String getServiceLib() {
        return serviceLib;
    }

    public void setServiceLib(String serviceLib) {
        this.serviceLib = serviceLib;
    }

    public String getIdMagasin() {
        return idMagasin;
    }

    public void setIdMagasin(String idMagasin) {
        this.idMagasin = idMagasin;
    }

    public String getIdMagasinlib() {
        return idMagasinlib;
    }

    public void setIdMagasinlib(String idMagasinlib) {
        this.idMagasinlib = idMagasinlib;
    }

    public As_BonDeCommandeCpl(){
        this.setNomTable("As_BonDeCommande_MERECPL");
    }

    public double getMontantTVA() {
        return montantTVA;
    }

    public void setMontantTVA(double montantTVA) {
        this.montantTVA = montantTVA;
    }

    public double getMontantHT() {
        return montantHT;
    }

    public void setMontantHT(double montantHT) {
        this.montantHT = montantHT;
    }

    public double getMontantTTC() {
        return montantTTC;
    }

    public void setMontantTTC(double montantTTC) {
        this.montantTTC = montantTTC;
    }

    public double getMontantTTCAriary() {
        return montantTTCAriary;
    }

    public void setMontantTTCAriary(double montantTTCAriary) {
        this.montantTTCAriary = montantTTCAriary;
    }

    public String getIdDeviselib() {
        return idDeviselib;
    }

    public void setIdDeviselib(String idDeviselib) {
        this.idDeviselib = idDeviselib;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }
    
    
    public String getHtmlAttacherFichier(String contextPath) throws Exception {
        try (Connection c = new UtilDB().GetConn()) {
            String html = "";
            String dossier = this.getClass().getSimpleName();
            String aWhere = " and mere ='"+this.getId()+"'";
            if (!Utilitaire.champNull(this.getIdOrigine()).isEmpty()) {
                aWhere = aWhere + " or mere = '"+this.getIdOrigine()+"'";
            }
            AttacherFichier[] fichiers = (AttacherFichier[]) CGenUtil.rechercher(new AttacherFichier(), null, null, c, aWhere);
            html = html + "<div class=\"row m-0 attache-fichier\">\n<div class=\"col-md-12 nopadding bottom-vente-fiche\">\n    <div class=\"box\">\n        <h2 class=\"box-title\">Les fichiers attach&eacute;s</h2>\n        <div class=\"box-body\">\n            <table class=\"table table-striped table-bordered table-condensed tree\" style=\"color: #4e4e4e;\">\n                <thead>\n                    <tr>\n                        <th class='contenuetable '></th>\n                        <th class='contenuetable ' style='width:20%'>Aper&ccedil;u</th>\n                        <th class='contenuetable '>Libell&eacute;</th>\n                        <th class='contenuetable '>Fichier</th>\n                        <th class='contenuetable '>Date d`upload</th>\n                        <th class='contenuetable '>T&eacute;l&eacute;charger</th>\n                     </tr>\n                </thead>\n                <tbody>";
            if (fichiers != null && fichiers.length != 0) {
                for (AttacherFichier fichier : fichiers) {
                    if (fichier.getMere().startsWith("DMD")) {
                        dossier = "DmdAchatLib";
                    }
                    html = html + "<tr class=\"treegrid-1 treegrid-expanded\">\n    <td><span class=\"treegrid-expander glyphicon glyphicon-minus\"></span></td>\n    <td><img class='preview-img' onclick=\"openPreview(this.src)\" name=" + fichier.getChemin() + " id=" + fichier.getChemin() + " src=\"/dossier/async/" + dossier + "/" + fichier.getChemin() + "\" style=\"width:100%;\"></td>\n    <td>" + fichier.getChemin() + "</td>\n    <td>" + Utilitaire.champNull(fichier.getLibelle()) + "</td>\n    <td>" + fichier.getDaty() + "</td>\n    <td>\n        <a href=\"" + contextPath + "/FileManager2?parent=/" + dossier + "/" + fichier.getChemin() + "\" class=\"btn btn-success\" >T&eacute;l&eacute;charger</a>\n    </td>\n</tr>";
                    dossier = this.getClass().getSimpleName();
                }
            } else {
                html = html + "<tr>\n    <td colspan=\"3\" style=\"text-align: center;\"><strong>Aucun fichier</strong></td>\n</tr>";
            }

            html = html + "</tbody>\n\n                </table>\n            </div>\n        </div>\n    </div>\n</div>\n<div id=\"imageModal\" class=\"modal\">\n    <span class=\"close\" onclick=\"closePreview()\">&times;</span>\n    <img class=\"modal-content\" id=\"modalImage\">\n</div><script>\nfunction openPreview(src) {\n    const modal = document.getElementById(\"imageModal\");\n    const modalImg = document.getElementById(\"modalImage\");\n\n    modal.style.display = \"flex\";\n    modalImg.src = src;\n}\n\nfunction closePreview() {\n    document.getElementById(\"imageModal\").style.display = \"none\";\n}\ndocument.getElementById(\"imageModal\").onclick = function (e) {\n    if (e.target === this) closePreview();\n};\n</script>\n<style>\n#imageModal {\n    display: none;              /* cachÃ© par dÃ©faut */\n    position: fixed;\n    inset: 0;\n    background: rgba(0,0,0,0.4);\n\n    /* centrage */\n    justify-content: center;\n    align-items: center;\n}</style>";
            return html;
        }
    }
}
