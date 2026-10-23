/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mg.cnaps.paie;

import bean.CGenUtil;
import bean.ClassEtat;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import paie.elementpaie.PaieInfoPersEltPaieComplet;

/**
 *
 * @author rickyblondel
 */
 public class PaiePersonnelElementpaie extends ClassEtat {

    private String id, code_rubrique;
    private Date date_debut, date_fin;
    private String moisregularisation, anneeregularisation;
    private double gain, retenue;
    private String remarque, idpersonnel;
    private int etat;
    private String id_objet;
    private double quantite , hs_30_NI , hs_30_I , hs_50_NI ,hs_50_I;
    private String unite;
    private String nomPersonnel, nomRubrique, matricule, etatLib;

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

    public double getHs_30_NI() {
        return hs_30_NI;
    }

    public void setHs_30_NI(double hs_30_NI) {
        this.hs_30_NI = hs_30_NI;
    }

    public double getHs_30_I() {
        return hs_30_I;
    }

    public void setHs_30_I(double hs_30_I) {
        this.hs_30_I = hs_30_I;
    }

    public double getHs_50_NI() {
        return hs_50_NI;
    }

    public void setHs_50_NI(double hs_50_NI) {
        this.hs_50_NI = hs_50_NI;
    }

    public double getHs_50_I() {
        return hs_50_I;
    }

    public void setHs_50_I(double hs_50_I) {
        this.hs_50_I = hs_50_I;
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
    
    

    public String getIdpersonnel() {
        return idpersonnel;
    }

    public void setIdpersonnel(String idpersonnel) throws Exception {
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
                        //tab[i].completeInformationWithinfoPers(map.get(tab[i].getCode_rubrique()));
                        //retour.add(tab[i]);
                    }
                }
                
            }
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }
        return retour;
    }


    public String getNomPersonnel() {
        return nomPersonnel;
    }

    public void setNomPersonnel(String nomPersonnel) {
        this.nomPersonnel = nomPersonnel;
    }

    public String getNomRubrique() {
        return nomRubrique;
    }

    public void setNomRubrique(String nomRubrique) {
        this.nomRubrique = nomRubrique;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }
}
