package maintenance.travaux;

import chatbot.ClassIA;
import utilitaire.Utilitaire;

import java.sql.Date;

public class OrdreTravauxFilleCpl extends OrdreTravauxFille implements ClassIA {
    String iduniteLib,libelleMere,idbc;
    double montantentree,montantsortie,pourc;
    double qteFabrique;
    double qteReste;
    Date daty;
    String libelleexacte;
    double pv;
    double tauxRevient;

    @Override
    public String getNomTableIA() {
        return "OfFilleLibStock";
    }
    @Override
    public String getUrlListe() {
        return "/savonnerie/pages/module.jsp?but=fabrication/ordre-fabrication-liste.jsp&currentMenu=MENUDYN0304005";
    }
    @Override
    public String getUrlAnalyse() {
        return "/savonnerie/pages/module.jsp?but=fabrication/ordre-fabrication-liste.jsp&currentMenu=MENUDYN0304005";
    }
    @Override
    public String getUrlSaisie() {
        return "/savonnerie/pages/module.jsp?but=fabrication/ordre-fabrication-liste.jsp&currentMenu=MENUDYN0304005";
    }
    @Override
    public ClassIA getClassListe() {
        return this;
    }
    @Override
    public ClassIA getClassAnalyse() {
        return this;
    }

    @Override
    public ClassIA getClassSaisie() {
        return this;
    }

    public OrdreTravauxFilleCpl() throws Exception {
        super.setNomTable("OTRAVFILLERESTELIB");
    }

    public String getIduniteLib() {
        return iduniteLib;
    }

    public void setIduniteLib(String iduniteLib) {
        this.iduniteLib = iduniteLib;
    }

    public String getIdbc() {
        return idbc;
    }

    public void setIdbc(String idbc) {
        this.idbc = idbc;
    }

    public double getQteFabrique() {
        return qteFabrique;
    }

    public void setQteFabrique(double qteFabrique) {
        this.qteFabrique = qteFabrique;
    }

    public double getQteReste() {
        return qteReste;
    }

    public void setQteReste(double qteReste) {
        this.qteReste = qteReste;
    }

    public String getLibelleMere() {
        return libelleMere;
    }

    public void setLibelleMere(String libelleMere) {
        this.libelleMere = libelleMere;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getLibelleexacte() {
        System.out.println("libexacte =="+libelleexacte);
        return this.libelleexacte;
    }

    public void setLibelleexacte(String libelleexacte) {
        System.out.println("libexacte !!!=="+libelleexacte);
        this.libelleexacte =libelleexacte;
    }

    public double getMontantentree() {
        return montantentree;
    }

    public void setMontantentree(double montantentree) {
        this.montantentree = montantentree;
    }

    public double getMontantsortie() {
        return montantsortie;
    }

    public void setMontantsortie(double montantsortie) {
        this.montantsortie = montantsortie;
    }

    public double getPourc() {
        return pourc;
    }

    public void setPourc(double pourc) {
        this.pourc = pourc;
    }

    public double getPv() {
        return pv;
    }

    public void setPv(double pv) {
        this.pv = pv;
    }

    public double getTauxRevient() {
        return this.getMontantentree()==0 ? 0: Utilitaire.arrondir(this.getMontantsortie() / this.getMontantentree() * 100,2);
    }
    public void setTauxRevient(double tauxRevient) {
        this.tauxRevient = tauxRevient;
    }
    public double getPurevient() {
        return this.getQteFabrique()==0 ? 0 : Utilitaire.arrondir(this.getMontantsortie() / this.getQteFabrique(),2);
    }

    /* public String getLIBELLEEXTACTE(){

       return this.LIBELLEEXTACTE;
    }

    public void setLIBELLEEXTACTE(String LIBELLEEXTACTE){
        this.LIBELLEEXTACTE = LIBELLEEXTACTE;
    }
*/

    @Override
    public String[] getValMotCles() {
        return new String[]{"id", "qte","idunite", "libelleexacte"};
    }

    @Override
    public String[] getMotCles() {
        return new String[]{"id", "qte", "idunite", "libelleexacte"};
    }

}
