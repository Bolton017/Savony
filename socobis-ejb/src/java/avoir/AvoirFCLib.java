/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package avoir;

import bean.CGenUtil;
import java.sql.Connection;

import constante.ConstanteEtat;
import utilitaire.UtilDB;
import vente.Vente;
import vente.VenteDetails;

/**
 *
 * @author randr
 */
public class AvoirFCLib extends AvoirFC {

    String idMagasinLib;
    String idVenteLib;
    String idMotifLib;
    String idCategorieLib;
    String idtypeavoirlib;
    String clientlib;
    String iddevise;
    double tauxdechange;
    double montantHT;
    double montantTVA;
    double montantTTC;
    double montantHTAr;
    double montantTVAAr;
    double montantTTCAr;
    double resteapayer;
    double resteapayerar;
    String typeavoir;
    String numfact;
    String etatLib;

    public String getNumfact() {
        return numfact;
    }

    public void setNumfact(String numfact) {
        this.numfact = numfact;
    }
    
    public AvoirFCLib(){
        this.setNomTable("avoirFCLib");
    }

    public String getTypeavoir() {
        return typeavoir;
    }

    public void setTypeavoir(String typeavoir) {
        this.typeavoir = typeavoir;
    }

    public AvoirFCLib(String nomtable){
        this.setNomTable(nomtable);
    }

    public String getIdMagasinLib() {
        return idMagasinLib;
    }

    public void setIdMagasinLib(String idMagasinLib) {
        this.idMagasinLib = idMagasinLib;
    }

    public String getIdVenteLib() {
        return idVenteLib;
    }

    public void setIdVenteLib(String idVenteLib) {
        this.idVenteLib = idVenteLib;
    }

    public String getIdMotifLib() {
        return idMotifLib;
    }

    public void setIdMotifLib(String idMotifLib) {
        this.idMotifLib = idMotifLib;
    }

    public String getIdCategorieLib() {
        return idCategorieLib;
    }

    public void setIdCategorieLib(String idCategorieLib) {
        this.idCategorieLib = idCategorieLib;
    }

    public String getIddevise() {
        return iddevise;
    }

    public void setIddevise(String iddevise) {
        this.iddevise = iddevise;
    }

    public double getTauxdechange() {
        return tauxdechange;
    }

    public void setTauxdechange(double tauxdechange) {
        this.tauxdechange = tauxdechange;
    }

    public double getMontantHT() {
        return montantHT;
    }

    public void setMontantHT(double montantHT) {
        this.montantHT = montantHT;
    }

    public double getMontantTVA() {
        return montantTVA;
    }

    public void setMontantTVA(double montantTVA) {
        this.montantTVA = montantTVA;
    }

    public double getMontantTTC() {
        return montantTTC;
    }

    public void setMontantTTC(double montantTTC) {
        this.montantTTC = montantTTC;
    }

    public double getMontantHTAr() {
        return montantHTAr;
    }

    public void setMontantHTAr(double montantHTAr) {
        this.montantHTAr = montantHTAr;
    }

    public double getMontantTVAAr() {
        return montantTVAAr;
    }

    public void setMontantTVAAr(double montantTVAAr) {
        this.montantTVAAr = montantTVAAr;
    }

    public double getMontantTTCAr() {
        return montantTTCAr;
    }

    public void setMontantTTCAr(double montantTTCAr) {
        this.montantTTCAr = montantTTCAr;
    }

    public String getClientlib() {
        return clientlib;
    }

    public void setClientlib(String clientlib) {
        this.clientlib = clientlib;
    }

    public double getResteapayer() {
        return resteapayer;
    }

    public void setResteapayer(double resteapayer) {
        this.resteapayer = resteapayer;
    }

    public double getResteapayerar() {
        return resteapayerar;
    }

    public void setResteapayerar(double resteapayerar) {
        this.resteapayerar = resteapayerar;
    }
    
    
    public static AvoirFCLib getById(Connection c, String id) throws Exception{
        AvoirFCLib afl = new AvoirFCLib();
        boolean canClose=false;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                canClose=true;
            }
            afl.setNomTable("avoirfclib_cpl");
            afl.setId(id);
            afl = ((AvoirFCLib[]) CGenUtil.rechercher(afl, null, null, c, "")).length > 0 ? (AvoirFCLib)((AvoirFCLib[]) CGenUtil.rechercher(afl, null, null, c, ""))[0] : null;
        } catch(Exception e){
            throw e;
        } finally {
            if(canClose){
                c.close();
            }
        }
        return afl;
    }

    public String getIdtypeavoirlib() {
        return idtypeavoirlib;
    }

    public void setIdtypeavoirlib(String idtypeavoirlib) {
        this.idtypeavoirlib = idtypeavoirlib;
    }

    @Override
    public String chaineEtat(int value) {
        if (value == ConstanteEtat.getEtatCreer()) {
            return "<b style='color:lightskyblue' multi-lang>CR&Eacute;&Eacute;</b>";
        } else if (value == ConstanteEtat.getEtatValider()) {
            return "<b style='color:green' multi-lang>VALID&Eacute;</b>";
        } else if (value == ConstanteEtat.getEtatAnnuler()) {
            return "<b style='color:orange' multi-lang>ANNUL&Eacute;</b>";
        } else if (value == ConstanteEtat.getEtatCloture()) {
            return "<b style='color:orange' multi-lang>CLOTUR&Eacute;</b>";
        } else if (value == ConstanteEtat.getEtatPlanifie()) {
            return "<b style='color:lightskyblue' multi-lang>PLANIFI&Eacute;</b>";
        } else {
            return value == ConstanteEtat.getEtatInterviewe() ? "<b style='color:lightskyblue' multi-lang>INTERVIEW&Eacute;</b>" : "<b style='color:lightskyblue' multi-lang>AUTRE</b>";
        }
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }
}
