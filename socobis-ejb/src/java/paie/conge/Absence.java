/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.conge;

import bean.CGenUtil;
import bean.ClassEtat;
import java.sql.Connection;
import java.sql.Date;
import paie.log.LogPersonnelFin;
import paie.employe.PaieInfoPersonnel;
import utils.ConstantePaie;
import utilitaire.ConstanteEtatPaie;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

/**
 *
 * @author ASUS
 */
public class Absence extends ClassEtat{

    String id;
    String idpersonnel,idpersonnellib;
    String type,typelib;
    String motif, etatlib, matricule;
    double valeur;
    Date daty,datyfin, datesaisie;
    private double resteconge;
    private String rangorg;
    @Override
    public void controler(Connection c) throws Exception {
        if(this.getType().equalsIgnoreCase(ConstantePaie.absenceConge)) {
            double dureeAnc = getDureeAnciennete(this.getIdpersonnel(), c);
            
            if(dureeAnc < 12) {
                throw new Exception("Vous n'avez pas encore droit � un cong�");
            }
        }
    }

    public PaieInfoPersonnel getMatricule(String matricule ) throws Exception {
        PaieInfoPersonnel pInfo = new PaieInfoPersonnel();
        PaieInfoPersonnel[] tmp = (PaieInfoPersonnel[]) CGenUtil.rechercher(pInfo, null, null,  " and matricule like '"+matricule+"' ");        
        if(tmp.length > 0){
            return tmp[0];
        }
        return null;
    }
    
    public LogPersonnelFin getInfoPers(String matricule ) throws Exception {
        LogPersonnelFin base = new LogPersonnelFin();
        base.setNomTable("log_personnel_fin");
        LogPersonnelFin[] tmp = (LogPersonnelFin[]) CGenUtil.rechercher(base, null, null,  " and matricule like '"+matricule+"' ");        
        if(tmp.length > 0){
            return tmp[0];
        }
        return null;
    }
    
    public double getDureeAnciennete(String idpersonnel, Connection c) throws Exception {
        PaieInfoPersonnel pInfo = new PaieInfoPersonnel();
        pInfo.setId(idpersonnel);
        PaieInfoPersonnel[] tmp = (PaieInfoPersonnel[]) CGenUtil.rechercher(pInfo, null, null, c, "");
        double duree = 0;
        
        if(tmp != null && tmp.length  > 0) {
            pInfo = tmp[0];
            
            duree = Utilitaire.diffMoisDaty(Utilitaire.dateDuJourSql(), pInfo.getDateembauche());
        }
        
        return duree;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getEtatlib() {
//        return getEtatText(getEtat());
        return this.etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }
    
    public Date getDatesaisie() {
        return datesaisie;
    }

    public void setDatesaisie(Date datesaisie) {
        if(this.getMode().compareToIgnoreCase("modif")==0)this.datesaisie = Utilitaire.dateDuJourSql();
        this.datesaisie = datesaisie;
    }
    int annee_cible;

    public String getTypelib() {
        return typelib;
    }

    public void setTypelib(String typelib) {
        this.typelib = typelib;
    }
    
    public String getIdpersonnellib() {
        return idpersonnellib;
    }

    public void setIdpersonnellib(String idpersonnellib) {
        this.idpersonnellib = idpersonnellib;
    }
    
    public Absence(){
        super.setNomTable("Absence");
    }
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDatyfin() {
        return datyfin;
    }

    public void setDatyfin(Date datyfin) {
        this.datyfin = datyfin;
    }

    public String getIdpersonnel() {
        return idpersonnel;
    }

    public void setIdpersonnel(String idpersonnel) {
        this.idpersonnel = idpersonnel;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getMotif() {
        return motif;
    }

    public void setMotif(String motif) {
        this.motif = motif;
    }

    public double getValeur() {
        return valeur;
    }

    public void setValeur(double valeur) {
        this.valeur = valeur;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public int getAnnee_cible() {
        return annee_cible;
    }

    public void setAnnee_cible(int annee_cible) {
        this.annee_cible = annee_cible;
    }
    
    
    @Override
    public String getTuppleID() {
        return this.getId();
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    @Override
    public void construirePK(Connection c) throws Exception {
	this.preparePk("AB", "GET_SEQ_SEQ_ABSENCE");
	this.setId(makePK(c));
    }
    
    public String viserAbsence(String iduser,Connection c)throws Exception{
        if(getEtat() != 1){
            throw new Exception("l'�tat doit �tre egal � cr��");
        }
        int indice = 0;
        String retour = null;
        try{
            if(c==null){
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                indice = 1;
            }
            
            CongeMoins moins = new CongeMoins();
            moins.setAnnee(getAnnee_cible());
            moins.setConge(getValeur());
            moins.setIdpersonnel(getIdpersonnel());
            moins.construirePK(c);
            moins.setRefdobject(getId());
            moins.insertToTableWithHisto(iduser, c);
            setEtat(ConstanteEtatPaie.etatPreValide);
            updateToTableWithHisto(iduser, c);
            if(indice == 1)c.commit();
        }catch(Exception e){
            c.rollback();
            e.printStackTrace();
            throw e;
        }finally{
            if(indice == 1 && c!=null)c.close();
        }
        return retour;
        
    }
    
    public static Absence[] visaMultiple(String[] tab,Connection c,String iduser)throws Exception{
        int indice = 0;
        Absence[] retour = null;
        try{
            if(c==null){
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                indice = 1;
            }
            if(tab.length>0){
                String where = utilitaire.Utilitaire.tabToString(tab, "'", ",");
                where = " and id in ("+where+")";
                retour = (Absence[])CGenUtil.rechercher(new Absence(), null, null, c, where);
                if(retour.length>0){
                    for(int i = 0;i<retour.length;i++){
                        retour[i].viserAbsence(iduser, c);
                    }
                }
            }
            if(indice == 1)c.commit();
       }catch(Exception e){
            c.rollback();
            e.printStackTrace();
            throw e;
        }finally{
            if(indice == 1 && c!=null)c.close();
        }
        return retour;
    }

    public double getResteconge() {
        return resteconge;
    }

    public void setResteconge(double resteconge) {
        this.resteconge = resteconge;
    }

    public String getRangorg() {
        return rangorg;
    }

    public void setRangorg(String rangorg) {
        this.rangorg = rangorg;
    }
    
    
}
