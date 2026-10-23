/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.elementpaie;

import bean.CGenUtil;
import bean.ClassMAPTable;
import java.lang.reflect.Field;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.HashMap;
import paie.employe.PaieInfoPersonnel;
import paie.employe.PaieRubrique;
import paie.generique.UtilitaireFormule;
import utilitaire.Utilitaire;

/**
 *
 * @author Joe
 */
public class PaieInfoPersEltPaieComplet extends PaieInfoPersonnel {



    private String val;
    private String desce;
    private String nationalite;
    private int rang;
    private String comptepcg;
    private String code;
    private String typerubrique,idgroupefonction;
    private String bcs;
    private String bg;
    private String imposable;
    private String nature;
    private String avantage;
    private int isconfeltfixe;
    private String code_rubrique;
    private Date date_debut, date_fin,datedebut,datefin;
    private double gain, retenue;
    private String remarque, idpersonnel,idpersonnellib,idelementpaie,idelementpaielib,coderubrique,idedition;
    private String CPT_GEN_DB,CPT_GEN_CR,CPT_ANA_DB,CPT_ANA_CR;
    private double quantite;
    private String unite,id_objet;
    private int etat,etat_element;
    private String pointindice,moisregularisation,anneeregularisation,remarque_element,formu,mere;
    private int regroupement;
    private int arrondi=2;
    int inserted=1, sommable=1;
    String beneficiaire, remarqueformule,uniteformule,qteformule;
    int majoration;
    double pu;
    String qte;
     private double cnaps12;
    private double cnaps13;
    private double cnaps14;
    private int mois_edition;
    private int annee_edition;
    private int nbjmois = 30;

    String moislib;

    public String getMoislib() {
        return moislib;
    }

    public void setMoislib(String moislib) {
        this.moislib = moislib;
    }

    public int getNbjmois() {
        return nbjmois;
    }

    public void setNbjmois(int nbjmois) {
        this.nbjmois = nbjmois;
    }

    public double getCnaps12() {
        return cnaps12;
    }

    public void setCnaps12(double cnaps12) {
        this.cnaps12 = cnaps12;
    }

    public double getCnaps13() {
        return cnaps13;
    }

    public void setCnaps13(double cnaps13) {
        this.cnaps13 = cnaps13;
    }

    public double getCnaps14() {
        return cnaps14;
    }

    public void setCnaps14(double cnaps14) {
        this.cnaps14 = cnaps14;
    }

    public int getMois_edition() {
        return mois_edition;
    }

    public void setMois_edition(int mois_edition) {
        this.mois_edition = mois_edition;
    }

    public int getAnnee_edition() {
        return annee_edition;
    }

    public void setAnnee_edition(int annee_edition) {
        this.annee_edition = annee_edition;
    }



    private int nbpro = 30;

    private double salaire_base;

    public double getSalaire_Base() {
        return this.salaire_base;
    }

    public void setSalaire_base(double salaire_base) {
        this.salaire_base = salaire_base;
    }

    public int getNbpro() {
        return nbpro;
    }

    public void setNbpro(int nbpro) {
        if(nbpro==0) nbpro = 30;
        this.nbpro = nbpro;
    }



    public Date getDatedebut() {
        return datedebut;
    }

    public void setDatedebut(Date datedebut) {
        this.datedebut = datedebut;
    }

    public Date getDatefin() {
        return datefin;
    }

    public void setDatefin(Date datefin) {
        this.datefin = datefin;
    }

    public String getIdpersonnellib() {
        return idpersonnellib;
    }

    public void setIdpersonnellib(String idpersonnellib) {
        this.idpersonnellib = idpersonnellib;
    }

    public String getIdelementpaie() {
        return idelementpaie;
    }

    public void setIdelementpaie(String idelementpaie) {
        this.idelementpaie = idelementpaie;
    }

    public String getIdelementpaielib() {
        return idelementpaielib;
    }

    public void setIdelementpaielib(String idelementpaielib) {
        this.idelementpaielib = idelementpaielib;
    }

    public String getCoderubrique() {
        return coderubrique;
    }

    public void setCoderubrique(String coderubrique) {
        this.coderubrique = coderubrique;
    }

    public String getIdedition() {
        return idedition;
    }

    public void setIdedition(String idedition) {
        this.idedition = idedition;
    }

    public int getMajoration() {
        return majoration;
    }

    public void setMajoration(int majoration) {
        this.majoration = majoration;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) {
        this.pu = pu;
    }

    public String getQte() {
        return qte;
    }

    public void setQte(String qte) {
        this.qte = qte;
    }

    public String getRemarqueformule() {
        return remarqueformule;
    }

    public void setRemarqueformule(String remarqueformule) {
        this.remarqueformule = remarqueformule;
    }

    public String getUniteformule() {
        return uniteformule;
    }

    public void setUniteformule(String uniteformule) {
        this.uniteformule = uniteformule;
    }

    public String getQteformule() {
        return qteformule;
    }

    public void setQteformule(String qteformule) {
        this.qteformule = qteformule;
    }

    public String getBeneficiaire() {
        return beneficiaire;
    }

    public void setBeneficiaire(String beneficiaire) {
        this.beneficiaire = beneficiaire;
    }

    public int getSommable() {
        return sommable;
    }

    public void setSommable(int sommable) {
        this.sommable = sommable;
    }

    public int getArrondi() {
        return arrondi;
    }

    public void setArrondi(int arrondi) {
        this.arrondi = arrondi;
    }


    public Date getDateDebutEditon()  {
        Date dateDebut = Utilitaire.stringDate("01/"+this.getMois()+"/"+this.getAnnee());
        return dateDebut;
    }

    public int getRegroupement() {
        return regroupement;
    }

    public void setRegroupement(int regroupement) {
        this.regroupement = regroupement;
    }
    public Date getDateFinEdition() throws Exception{
        Date dateFin= Utilitaire.getFinDuMoisByMoisAnnee(this.getMois(), this.getAnnee());
        return dateFin;
    }

    public String getMere() {

        return mere;
    }

    public void setMere(String mere) {
        this.mere = mere;
    }

    public String getFormu() {
        return formu;
    }

    public void setFormu(String formuu) {
        this.formu = formuu;
    }
    int israppel;



    public int getInserted() {
        return inserted;
    }

    public void setInserted(int inserted) {
        this.inserted = inserted;
    }

    public String getRemarque_element() {
        return remarque_element;
    }

    public void setRemarque_element(String remarque_element) {
        this.remarque_element = remarque_element;
    }



    public int getEtat_element() {
        return etat_element;
    }

    public void setEtat_element(int etat_element) {
        this.etat_element = etat_element;
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



    public int getEtat() {
        return etat;
    }

    public void setEtat(int etat) {
        this.etat = etat;
    }
    public PaieInfoPersEltPaieComplet contrer() throws Exception
    {
        PaieInfoPersEltPaieComplet retour=new PaieInfoPersEltPaieComplet();
        retour.copier(this);
        double ancienGain=retour.getGain();
        retour.setGain(retour.getRetenue());
        retour.setRetenue(ancienGain);
        return retour;
    }

    public void ajoutMois(int aAjouter)throws Exception
    {
        int valinyMois=(this.getMois()+aAjouter)%12;
        int annee=this.getAnnee()+((this.getMois()+aAjouter)/12);
        this.setMois(valinyMois);
        this.setAnnee(annee);
        this.setDate_debut(Utilitaire.stringDate("01/"+valinyMois+"/"+annee));
        this.setDate_fin(Utilitaire.getFinDuMoisByMoisAnnee(valinyMois, annee));
    }

    public double[] getGainRetenue(String nomColonne,String valeur) throws Exception
    {
        double[]retour=new double[2];
        try
        {
            retour[0]=0;
            retour[1]=0;
            String valeurInterne="";
            if(CGenUtil.getValeurFieldByMethod(this, nomColonne)!=null)
                valeurInterne=CGenUtil.getValeurFieldByMethod(this, nomColonne).toString();

            boolean estContenu=Utilitaire.contientIgnoreCase(valeurInterne,valeur);
            if(valeur!=null&&(valeur.compareToIgnoreCase("%")==0 || estContenu))
            {
                if(this.getGain()>0)
                {
                    retour[0]=this.getGain();
                }
                if(this.getRetenue()>0){
                    retour[1]=this.getRetenue();

                }
            }
            //if(valeur.compareToIgnoreCase("%")==0)System.out.println("retour anaty fonction "+retour[0]+ " gain "+retour[1]);
            //return retour;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            throw e;
        }
        finally
        {
            return retour;
        }
    }
    public boolean verifieCondition(String nomColonne,String valeur) throws Exception
    {
        String valeurInterne=CGenUtil.getValeurFieldByMethod(this, nomColonne).toString();
        boolean estContenu=Utilitaire.contientIgnoreCase(valeurInterne,valeur);
        if(valeur!=null&&(valeur.compareToIgnoreCase("%")==0 || estContenu))
        {
            return true;
        }
        return false;
    }

    public boolean estFormuleRemarque() throws Exception
    {
        boolean retour = false;
        if (this.getRemarqueformule().compareTo("")==0){
            retour= true;
        }
        return retour;
    }
    public boolean estFormuleqte() throws Exception
    {

        if (this.getQteformule()==null || this.getQteformule().compareTo("")==0){
            return false;
        }
        return true;

    }


    public String getId_objet() {
        return id_objet;
    }

    public void setId_objet(String id_objet) {
        this.id_objet = id_objet;
    }

    public double getQuantite() {
        return quantite;
    }

    public void setQuantite(double quantite) {
        this.quantite = quantite;
    }

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }




    public String getCPT_GEN_DB() {
        return CPT_GEN_DB;
    }

    public void setCPT_GEN_DB(String CPT_GEN_DB) {
        this.CPT_GEN_DB = CPT_GEN_DB;
    }

    public String getCPT_GEN_CR() {
        return CPT_GEN_CR;
    }

    public void setCPT_GEN_CR(String CPT_GEN_CR) {
        this.CPT_GEN_CR = CPT_GEN_CR;
    }

    public String getCPT_ANA_DB() {
        return CPT_ANA_DB;
    }

    public void setCPT_ANA_DB(String CPT_ANA_DB) {
        this.CPT_ANA_DB = CPT_ANA_DB;
    }

    public String getCPT_ANA_CR() {
        return CPT_ANA_CR;
    }

    public void setCPT_ANA_CR(String CPT_ANA_CR) {
        this.CPT_ANA_CR = CPT_ANA_CR;
    }

    public PaieInfoPersEltPaieComplet() {
        this.setNomTable("PAIEINFOPERSELTPAIECOMPLET2");
    }



    public String getVal() {
        return val;
    }

    public void setVal(String val) {
        this.val = val;
    }

    public String getDesce() {
        return desce;
    }

    public void setDesce(String desce) {
        this.desce = desce;
    }

    public int getRang() {
        return rang;
    }

    public void setRang(int rang) {
        this.rang = rang;
    }

    public String getComptepcg() {
        return comptepcg;
    }

    public void setComptepcg(String comptepcg) {
        this.comptepcg = comptepcg;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        if(code.startsWith("PRU"))
        {
            this.setCode_rubrique(code);
            return;
        }
        this.code = code;
    }

    public String getTyperubrique() {
        return typerubrique;
    }

    public void setTyperubrique(String typerubrique) {
        this.typerubrique = typerubrique;
    }

    public String getBcs() {
        return bcs;
    }

    public void setBcs(String bcs) {
        this.bcs = bcs;
    }

    public String getBg() {
        return bg;
    }

    public void setBg(String bg) {
        this.bg = bg;
    }

    public String getImposable() {
        return imposable;
    }

    public void setImposable(String imposable) {
        this.imposable = imposable;
    }

    public String getNature() {
        return nature;
    }

    public void setNature(String nature) {
        this.nature = nature;
    }

    public String getAvantage() {
        return avantage;
    }

    public void setAvantage(String avantage) {
        this.avantage = avantage;
    }



    public String getCode_rubrique() {
        return code_rubrique;
    }

    public void setCode_rubrique(String code_rubrique) {
        this.code_rubrique = code_rubrique;
    }

    public Date getDate_debut() {
        return date_debut;
    }

    public void setDate_debut(Date date_debut) {
        this.date_debut = date_debut;
    }

    public Date getDate_fin() {
        return date_fin;
    }

    public void setDate_fin(Date date_fin) {
        this.date_fin = date_fin;
    }

    public double getGain() {
        return gain;
    }

    public void setGain(double gai) {
        //this.gain=gai;
        this.gain = Utilitaire.arrondir(gai, this.getArrondi());
    }

    public double getRetenue() {
        return retenue;
    }

    public void setRetenue(double retenue) {
        //this.retenue=retenue;
        this.retenue = Utilitaire.arrondir(retenue, this.getArrondi());
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getIdpersonnel() {
        return idpersonnel;
    }

    public void setIdpersonnel(String idpersonnel) {
        this.idpersonnel = idpersonnel;
    }



    public String getIdgroupefonction() {
        return idgroupefonction;
    }

    public void setIdgroupefonction(String idgroupefonction) {
        this.idgroupefonction = idgroupefonction;
    }



    public int getIsrappel() {
        return israppel;
    }

    public void setIsrappel(int israppel) {
        this.israppel = israppel;
    }

    public int getIsconfeltfixe() {
        return isconfeltfixe;
    }

    public void setIsconfeltfixe(int isconfeltfixe) {
        this.isconfeltfixe = isconfeltfixe;
    }



    public String getNationalite() {
        return nationalite;
    }

    public void setNationalite(String nationalite) {
        this.nationalite = nationalite;
    }



    public String getPointindice() {
        return pointindice;
    }

    public void setPointindice(String pointindice) {
        this.pointindice = pointindice;
    }


    public void completeInformationWithinfoPers(PaiePersonnelElementpaie element){
        setDate_debut(element.getDate_debut());
        setDate_fin(element.getDate_fin());
        setMoisregularisation(element.getMoisregularisation());
        setAnneeregularisation(element.getAnneeregularisation());
        setGain(element.getGain());
        setRetenue(element.getRetenue());
        setQuantite(element.getQuantite());
        setUnite(element.getUnite());
        setEtat_element(element.getEtat());
        setId_objet(element.getId_objet());
        setRemarque_element(element.getRemarque());

    }

    public PaieInfoPersEltPaieComplet[] PaieInfoToPaieInfoComplet(PaiePersonnelElementpaie[] element){
        PaieInfoPersEltPaieComplet[] liste = new PaieInfoPersEltPaieComplet[element.length];
        for( int i = 0 , l = element.length ;  i < l ;i++ ){
            liste[i] = new PaieInfoPersEltPaieComplet();
            liste[i].completeInformationWithinfoPers( element[i] );
        }
        return liste ;
    }

    public PaieInfoPersEltPaieComplet(String code_rubrique, String idpersonnel, double gain, double retenue) {
        this.setCode_rubrique(code_rubrique);
        this.setIdpersonnel(idpersonnel);
        this.setGain(gain);
        this.setRetenue(retenue);
    }
    public static PaieRubrique findRub(PaieRubrique[] listeRub, String code) // na code na id
    {
        for(PaieRubrique rub:listeRub)
        {
            if(rub.getId().compareToIgnoreCase(code)==0)
                return rub;
            if(rub.getCode().compareToIgnoreCase(code)==0)
                return rub;
        }
        return null;
    }
    public PaieInfoPersEltPaieComplet(PaieRubrique[] listRub,ArrayList<PaieInfoPersEltPaieComplet> listeElt,String codeR, String idpersonnel, double gain, double retenue,String remarque, String imposable) throws Exception {
        if(listeElt.size()>0)
        {
            this.copier((PaieInfoPersEltPaieComplet)listeElt.get(0));
        }

        this.setCode(codeR);
        //this.setIdpersonnel(idpersonnel);


        this.setRetenue(retenue);
        this.setRemarque(remarque);
        this.setImposable(imposable);
        PaieRubrique rub=findRub(listRub,codeR);
        if(rub!=null)
        {
            this.setCode_rubrique(rub.getId());
            this.setCode(rub.getCode());
            this.setComptepcg(rub.getComptepcg());
            this.setRegroupement(rub.getRegroupement());
            this.setImposable(rub.getImposable());
            this.setArrondi(rub.getArrondi());
            this.setInserted(rub.getInserted());
            this.setSommable(rub.getSommable());
            this.setQteformule(rub.getQteFormule());
            this.setRemarqueformule(rub.getRemarqueFormule());
            this.setUniteformule(rub.getUniteFormule());
        }
        this.setGain(gain);
    }
    public PaieInfoPersEltPaieComplet(PaieRubrique rub,ArrayList<PaieInfoPersEltPaieComplet> listeElt,String codeR, String idpersonnel, double gain, double retenue,String remarque, String imposable) throws Exception {
        if(listeElt.size()>0)
        {
            this.copier((PaieInfoPersEltPaieComplet)listeElt.get(0));
        }

        this.setCode(codeR);

        //this.setIdpersonnel(idpersonnel);


        this.setRetenue(retenue);
        this.setRemarque(remarque);
        this.setImposable(imposable);
        if(rub!=null)
        {
            this.setCode_rubrique(rub.getId());
            this.setCode(rub.getCode());
            this.setComptepcg(rub.getComptepcg());
            this.setRegroupement(rub.getRegroupement());
            this.setImposable(rub.getImposable());
            this.setArrondi(rub.getArrondi());
            this.setInserted(rub.getInserted());
            this.setSommable(rub.getSommable());
            this.setQteformule(rub.getQteFormule());
            this.setRemarqueformule(rub.getRemarqueFormule());
            this.setUniteformule(rub.getUniteFormule());
            this.setMajoration(rub.getMajoration());
            this.setPu(rub.getPu());
            this.setQte(rub.getQte());
            this.setRang((int)rub.getRang());
            this.setTyperubrique(rub.getTyperubrique());
        }
        this.setGain(gain);
    }
    public void afficher()
    {
        System.out.println("id pers="+this.getIdpersonnel()+  " direction = "+ this.getDirection()+  " categorie = "+ this.getIdcategorie_paie()+  " qualification = "+ this.getIdqualification()+" numero de compte = "+this.getBanque_numero_compte()+" id = "+this.getId()+" code rubrique = "+this.getCode_rubrique()+" code = "+this.getCode()+" gain = "+this.getGain()+" retenue = "+this.getRetenue()+" qte = "+this.getQuantite()+" unite = "+this.getUnite()+" remarque = "+this.getRemarque()+" mois = "+this.getMois()+" annee = "+this.getAnnee() +  " service = "+ this.getService());
    }


    public void copier(ClassMAPTable aCop) throws Exception
    {
        Field[] listeC=aCop.getFieldList();
        for(Field f:listeC)
        {
            try {
//            this.setValChamp(f, aCop.getValField(f));
                CGenUtil.setValChamp(this, f, CGenUtil.getValeurFieldByMethod(aCop, f));
            } catch (Exception e) {
//                e.printStackTrace();
            }
        }
    }

}
