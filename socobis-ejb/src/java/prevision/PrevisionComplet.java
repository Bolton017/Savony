package prevision;

import bean.CGenUtil;
import caisse.MvtCaisse;

import java.sql.Connection;

import chatbot.AiTabDesc;
import chatbot.ClassIA;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteAsync;
@AiTabDesc("La structure de ma table de prévision, si ma question inclu prevu ou n'importe qui parle de prevision, dans ma table de prévision, la colonne 'credit' represente la recette prevu et 'debit' le depense prevu.: ")
public class PrevisionComplet extends PrevisionCPL implements ClassIA {
    double depenseEcart;
    double recetteEcart;
    double effectifDebit;
    double effectifCredit;
    String idFactureMere;

    @Override
    public String getNomTableIA() {
        return "PREVISION_COMPLET_CPL";
    }
    @Override
    public String getUrlListe() {
        return "/savonnerie/pages/module.jsp?but=prevision/prevision-liste.jsp&currentMenu=MENUDYN0020002";
    }
    @Override
    public String getUrlAnalyse() {
        return "/savonnerie/pages/module.jsp?but=prevision/resultat-prevision.jsp&currentMenu=MENUDYN0020003";
    }
    @Override
    public String getUrlSaisie() {
        return "/savonnerie/pages/module.jsp?but=prevision/prevision-saisie.jsp&currentMenu=MENUDYN0020001";
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

    public String getIdFactureMere() {
        return idFactureMere;
    }

    public void setIdFactureMere(String idFactureMere) {
        this.idFactureMere = idFactureMere;
    }

    public PrevisionComplet(){
        this.setNomTable("PREVISION_COMPLET_CPL");
    }

    
    public void attacherFacture(String[] ids, String u, Connection c)throws Exception{
        boolean canClose=false;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                canClose=true;
            }
            if(this.getDaty() == null){
                ((PrevisionComplet)this.getById(this.getId(), "PREVISION_COMPLET_CPL", c)).attacherFacture(ids,u,c);
            }
        MvtCaisse[] mvtCaisses =  MvtCaisse.getAll(ids, c);
        PrevisionComplet[] previsions = {this};
        for (int i = 0; i < mvtCaisses.length; i++) {
            MvtCaissePrevision[] mvts = mvtCaisses[0].attacherPrevision(previsions, u, c);
            if(mvts.length >0){
                mvts[0].createObject(u,c);
            }
        }
        }catch(Exception e){
            throw e;
        } finally {
            if(canClose){
                c.close();
            }
        }  
    }
    
    public double getEcart() { 
        return this.isDepense() ? this.getDepenseEcart() : this.getRecetteEcart();
    }

    public double getDepenseEcart() {
        return depenseEcart;
    }
    public void setDepenseEcart(double depenseEcart) {
        this.depenseEcart = depenseEcart;
    }
    public double getRecetteEcart() {
        return recetteEcart;
    }
    public void setRecetteEcart(double recetteEcart) {
        this.recetteEcart = recetteEcart;
    }
    public double getEffectifDebit() {
        return effectifDebit;
    }
    public void setEffectifDebit(double effectifDebit) {
        this.effectifDebit = effectifDebit;
    }
    public double getEffectifCredit() {
        return effectifCredit;
    }
    public void setEffectifCredit(double effectifCredit) {
        this.effectifCredit = effectifCredit;
    }
    public double getRestePrevision()throws Exception
    {
        if(this.isDepense())return this.getDebit()-this.getEffectifDebit();
        if(this.isRecette()) return this.getCredit()-this.getEffectifCredit();
        return 0;
    }

    public static PrevisionComplet[] getAll(String[] ids, Connection co)throws Exception{
        PrevisionComplet previsions = new PrevisionComplet();
        PrevisionComplet[] bls = (PrevisionComplet[]) CGenUtil.rechercher(previsions, null, null,co, " and id in ("+Utilitaire.tabToString(ids, "'", ",")+" ) ORDER BY DATY ASC ");
        return bls;
    }

}
