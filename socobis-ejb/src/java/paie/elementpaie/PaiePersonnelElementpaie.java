/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.elementpaie;

import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import javax.swing.RowFilter;

import annexe.HistoriqueProduit;
import utilitaire.Utilitaire;
import paie.employe.PaieRubrique;

/**
 *
 * @author rickyblondel
 */
 public class PaiePersonnelElementpaie extends ClassEtat {

    private String id, code_rubrique, matricule;
    private Date date_debut, date_fin;
    private String moisregularisation, anneeregularisation;
    private double gain, retenue;
    private String remarque, idpersonnel;
    private int etat;
    private String id_objet;
    private double quantite;
    private String unite;
    private double pourcentage;
    private String idcategorie_qualification;
    private String idfonction,moisregularisationlib;
    private String moislib;
    private String rubriqueLib, etatlib;

    public String getMoislib() {
        return this.moislib;
    }

    public void setMoislib(String moislib) {
        this.moislib = moislib;
    }

    public String getRubriqueLib() {
        return rubriqueLib;
    }

    public void setRubriqueLib(String rubriqueLib) {
        this.rubriqueLib = rubriqueLib;
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }


    public PaiePersonnelElementpaie(String idrubrique , String idpers , double debit , double credit , String mois, String annee , String rq ) throws Exception{
        setCode_rubrique(idrubrique);
        setIdpersonnel(idpers);
        setGain( debit );
        setRetenue( credit );
        setMoisregularisation( mois );
        setAnneeregularisation(annee );       
        setRemarque(rq);
        setDate_debut(   Utilitaire.stringDate( "01/"+mois+"/"+annee )   );
        setDate_fin(Utilitaire.stringDate(  Utilitaire.getNombreJourMois( mois , annee)+ "/"+mois+"/"+annee )   );
    }
    
    public PaiePersonnelElementpaie() {
        this.setNomTable("PAIE_PERSONNEL_ELEMENTPAIE");
    }

    @Override
    public String toString() {
        return "PaiePersonnelElementpaie{" + "id=" + id + ", code_rubrique=" + code_rubrique + ", date_debut=" + date_debut + ", date_fin=" + date_fin + ", moisregularisation=" + moisregularisation + ", anneeregularisation=" + anneeregularisation + ", gain=" + gain + ", retenue=" + retenue + ", remarque=" + remarque + ", idpersonnel=" + idpersonnel + ", etat=" + etat + ", id_objet=" + id_objet + '}';
    }

    public String getMatricule() {
        return matricule;
    }
 
    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getMoisregularisationlib() {
        return moisregularisationlib;
    }
 
    public void setMoisregularisationlib(String moisregularisationlib) {
        this.moisregularisationlib = moisregularisationlib;
    }

    public PaiePersonnelElementpaie(String id, String code_rubrique, Date date_debut, Date date_fin, double gain, double retenue, String remarque) throws Exception {
        this.setId(id);
        this.setCode_rubrique(code_rubrique);
        this.setDate_debut(date_debut);
        this.setDate_fin(date_fin);
        this.setGain(gain);
        this.setRetenue(retenue);
        this.setRemarque(remarque);
        this.setNomTable("PAIE_PERSONNEL_ELEMENTPAIE");
    }

    public PaiePersonnelElementpaie(String code_rubrique, Date date_debut, Date date_fin, double gain, double retenue, String idpersonnel) throws Exception {
        this.setCode_rubrique(code_rubrique);
        this.setDate_debut(date_debut);
        this.setDate_fin(date_fin);
        this.setGain(gain);
        this.setRetenue(retenue);
        this.setIdpersonnel(idpersonnel);
        this.setNomTable("PAIE_PERSONNEL_ELEMENTPAIE");
    }

//    (rubrique, datedebut, datefin, gain, retenue, "", idemp);
    public PaiePersonnelElementpaie(String id, String code_rubrique, Date date_debut, Date date_fin, double gain, double retenue, String remarque, String idpersonnel) throws Exception {
        this.setId(id);
        this.setCode_rubrique(code_rubrique);
        this.setDate_debut(date_debut);
        this.setDate_fin(date_fin);
        this.setGain(gain);
        this.setRetenue(retenue);
        this.setRemarque(remarque);
        this.setNomTable("PAIE_PERSONNEL_ELEMENTPAIE");
        this.setIdpersonnel(idpersonnel);
    }

    public PaiePersonnelElementpaie(String code_rubrique, Date date_debut, Date date_fin, double gain, double retenue, String remarque, String idpersonnel, int etat) throws Exception {
        this.setNomTable("PAIE_PERSONNEL_ELEMENTPAIE");
        this.setCode_rubrique(code_rubrique);
        this.setDate_debut(date_debut);
        this.setDate_fin(date_fin);
        this.setGain(gain);
        this.setRetenue(retenue);
        this.setRemarque(remarque);
        this.setIdpersonnel(idpersonnel);
        this.setEtat(etat);
    }

    public PaiePersonnelElementpaie(String code_rubrique, Date date_debut, Date date_fin, String moisregularisation, String anneeregularisation, double gain, double retenue, String remarque, String idpersonnel, int etat) throws Exception {
        this.setNomTable("PAIE_PERSONNEL_ELEMENTPAIE");
        this.setCode_rubrique(code_rubrique);
        this.setDate_debut(date_debut);
        this.setDate_fin(date_fin);
        this.setGain(gain);
        this.setRetenue(retenue);
        this.setMoisregularisation(moisregularisation);
        this.setAnneeregularisation(anneeregularisation);
        this.setRemarque(remarque);
        this.setIdpersonnel(idpersonnel);
        this.setEtat(etat);
    }
    
    public PaiePersonnelElementpaie(String code_rubrique, Date date_debut, Date date_fin, String moisregularisation, String anneeregularisation, double gain, double retenue, String remarque, String idpersonnel, int etat, double quantite, String unite) throws Exception {
        this.setNomTable("PAIE_PERSONNEL_ELEMENTPAIE");
        this.setCode_rubrique(code_rubrique);
        this.setDate_debut(date_debut);
        this.setDate_fin(date_fin);
        this.setGain(gain);
        this.setRetenue(retenue);
        this.setMoisregularisation(moisregularisation);
        this.setAnneeregularisation(anneeregularisation);
        this.setRemarque(remarque);
        this.setIdpersonnel(idpersonnel);
        this.setEtat(etat);
        this.setQuantite(quantite);
        this.setUnite(unite);
    }

    public double getQuantite() {
        return quantite;
    }

    public void setQuantite(double quantite) throws Exception {
        if(quantite < 0){
            throw new Exception("Quantite invalide");
        }
        this.quantite = quantite;
    }

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }

    public String getIdcategorie_qualification() {
        return idcategorie_qualification;
    }

    public void setIdcategorie_qualification(String idcategorie_qualification) {
        this.idcategorie_qualification = idcategorie_qualification;
    }

    public String getIdfonction() {
        return idfonction;
    }

    public void setIdfonction(String idfonction) {
        this.idfonction = idfonction;
    }

    public String getIdpersonnel() {
        return idpersonnel;
    }

    public void setIdpersonnel(String idpersonnel) throws Exception {
        if (getMode().compareTo("modif") == 0) {
            if (idpersonnel == null || idpersonnel.compareToIgnoreCase("") == 0) {
                throw new Exception("Personnel Obligatoire");
            }
        }
        this.idpersonnel = idpersonnel;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PELT", "getSeqPaie_prs_eltpaie");
        this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public String getCode_rubrique() {
        return code_rubrique;
    }

    public Date getDate_debut() {
        return date_debut;
    }

    public Date getDate_fin() {
        return date_fin;
    }

    public double getGain() {
        return gain;
    }

    public double getRetenue() {
        return retenue;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setCode_rubrique(String code_rubrique) throws Exception {
        if (getMode().compareTo("modif") == 0) {
            if (code_rubrique == null || code_rubrique.compareToIgnoreCase("") == 0) {
                throw new Exception("Rubrique Obligatoire");
            }
        }
        this.code_rubrique = code_rubrique;
    }

    public void setDate_debut(Date date_debut) throws Exception {
        this.date_debut = date_debut;
    }

    public void setDate_fin(Date date_fin) throws Exception {
        this.date_fin = date_fin;
    }

    public double getPourcentage() {
        return pourcentage;
    }

    public void setPourcentage(double pourcentage) {
        this.pourcentage = pourcentage;
    }
    public void setGain(double gain) throws Exception {
        if (getMode().compareTo("modif") != 0) {
            this.gain = gain;
            return;
        }
//        if ((getMode().compareTo("modif") == 0) && (gain < 0)) {
//            throw new Exception("Gain invalide car <0");
//        }
        this.gain = gain;
        /*String codeRub=getCode_rubrique();
         PaieRubrique  rubrique=(PaieRubrique) CGenUtil.rechercher(new PaieRubrique(), null, null, " and id='"+codeRub+"'")[0];
         String typeRub=rubrique.getTyperubrique();
         System.out.println("typeRub="+typeRub);
         double g=getGain();
         System.out.println("gain="+g);
         System.out.println("gainsetters="+gain);
         if(rubrique!=null)
         {
         if(typeRub.compareToIgnoreCase("G")==0)
         {
         if(gain==0)
         {
         throw new Exception("montant gain invalide");
         }
         else
         {
         this.gain = gain;
         }
         }
         else if(typeRub.compareToIgnoreCase("R")==0)
         {
         if(gain!=0)
         {
         throw new Exception("montant retenue invalide");
         }
         }
         }*/

    }

    public void setRetenue(double retenue) throws Exception {
//        if (getMode().compareTo("modif") != 0) {
//            this.retenue = retenue;
//            return;
//        }
//        if (retenue < 0) {
//            throw new Exception("Retenue invalide car <0");
//
        this.retenue = retenue;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public int getEtat() {
        return etat;
    }

    public void setEtat(int etat) {
        this.etat = etat;
    }

    /**
     * @return the id_objet
     */
    public String getId_objet() {
        return id_objet;
    }

    /**
     * @param id_objet the id_objet to set
     */
    public void setId_objet(String id_objet) {
        this.id_objet = id_objet;
    }

    public String getMoisregularisation() {
        return moisregularisation;
    }

    public void setMoisregularisation(String moisregularisation) {
        this.moisregularisation = moisregularisation;
    }

    public String getAnneeregularisation() {
        return anneeregularisation;
    }

    public void setAnneeregularisation(String anneeregularisation) {
        this.anneeregularisation = anneeregularisation;
    }
    
    
    public static List<PaieInfoPersEltPaieComplet> convertToPaieInfoPersEltPaieComplet(List<PaiePersonnelElementpaie> listeElt,int mois,int annee,Connection c)throws Exception{
        List<PaieInfoPersEltPaieComplet> retour = null;
       
        try{
            if(listeElt.size()>0){
                HashMap<String,PaiePersonnelElementpaie> map = new HashMap<String,PaiePersonnelElementpaie>();
                retour = new ArrayList<PaieInfoPersEltPaieComplet>();
                String awh = " and code_rubrique in( ";
                for(int i = 0;i<listeElt.size();i++){
                    awh+="'"+listeElt.get(i).getCode_rubrique()+"'";
                    if(i<listeElt.size()-1)awh+=",";
                    map.put(listeElt.get(i).getCode_rubrique(), listeElt.get(i));
//                    System.out.println("R : "+listeElt.get(i).getCode_rubrique()+" / G : "+listeElt.get(i).getGain()+" / R : "+listeElt.get(i).getRetenue());
                }
                awh+=" ) and idpersonnel = '"+listeElt.get(0).getIdpersonnel()+"'";
                
                PaieInfoPersEltPaieComplet find = new PaieInfoPersEltPaieComplet();
                find.setNomTable("elementpers_acompleter");
                PaieInfoPersEltPaieComplet[] tab = (PaieInfoPersEltPaieComplet[])CGenUtil.rechercher(find, null, null, c, awh);
                if(tab.length>0){
//                    System.out.println("nahita personnel à completer : "+tab.length);
                    for(int i = 0;i<tab.length;i++){
                        tab[i].completeInformationWithinfoPers(map.get(tab[i].getCode_rubrique()));
                        retour.add(tab[i]);
                    }
                }
                
            }
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }
        return retour;
    }


    public String getTypeRubrique() throws Exception{
        PaieRubrique paie = new PaieRubrique();
        paie.setId(this.getCode_rubrique());
        PaieRubrique[] pr = (PaieRubrique[]) CGenUtil.rechercher(paie,null,null,null,"");
        if(pr.length<1) throw new Exception("Rubrique Introuvable");
        return pr[0].getTyperubrique();
    }


    @Override
    public ClassMAPTable createObject(String u,Connection c)throws Exception
    {
        String typeRubMere = this.getTypeRubrique();
        System.out.println("typeRubMere===>"+typeRubMere);
        if(typeRubMere.equals("G")){
            this.setGain(this.getGain());
            this.setRetenue(0);
        }else if(typeRubMere.equals("R")){
            this.setRetenue(this.getGain());  
            this.setGain(0);         
        }
        int mois = Integer.valueOf(this.getMoisregularisation());
        int annee = Integer.valueOf(this.getAnneeregularisation());

        Date datedebut = Utilitaire.stringDate("01/"+Utilitaire.completerInt(2, mois)+"/"+annee);
        Date datefin = Utilitaire.stringDate(Utilitaire.getLastJourInMonth(datedebut)+"/"+Utilitaire.completerInt(2, mois)+"/"+annee);         
        this.setDate_debut(datedebut);
        this.setDate_fin(datefin);
        ClassMAPTable o=super.createObject(u,c);
        return o;
    }
 
    
    
}
