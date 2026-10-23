/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.edition;

import bean.CGenUtil;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import paie.employe.ConstantePaie;
import paie.employe.EmployeCompletPdf;
import utilitaire.UtilDB;

/**
 *
 * @author anthonyandrianaivoravelona
 */
public class FichePaie {

    private List<PaieEditionEltpaie> listeElementPaie;
    private String mois, annee, nom, fonction, section, categorie, matricule_cnaps, cin, matricule, classe, classification,  txhors, code, brutImposable, lieuTravail, totHeures, paiement;
    private int nbenfant;
    private String motif;
    private double net_a_payer ,conger;

    private String modePaiementLib;
    private String departementLib;
    private String categoriePersonnel;
    private String situationMLib;
    private double indice;

    public String getModePaiementLib() {
        return modePaiementLib;
    }

    public void setModePaiementLib(String modePaiementLib) {
        this.modePaiementLib = modePaiementLib;
    }

    public String getDepartementLib() {
        return departementLib;
    }

    public void setDepartementLib(String departementLib) {
        this.departementLib = departementLib;
    }

    public String getCategoriePersonnel() {
        return categoriePersonnel;
    }

    public void setCategoriePersonnel(String categoriePersonnel) {
        this.categoriePersonnel = categoriePersonnel;
    }

    public String getSituationMLib() {
        return situationMLib;
    }

    public void setSituationMLib(String situationMLib) {
        this.situationMLib = situationMLib;
    }

    public String getMotif() {
        return motif;
    }

    public void setMotif(String motif) {
        this.motif = motif;
    }

    public FichePaie(List<PaieEditionEltpaie> listeElementPaie, String mois, String annee, String nom, String fonction, String section, String categorie, String matricule_cnaps, String cin, String matricule, String classe, double indice, String txhors, String code, String totHeures, String paiement) {
        this.listeElementPaie = listeElementPaie;
        this.mois = mois;
        this.annee = annee;
        this.nom = nom;
        this.fonction = fonction;
        this.section = section;
        this.categorie = categorie;
        this.matricule_cnaps = matricule_cnaps;
        this.cin = cin;
        this.matricule = matricule;
        this.classe = classe;
        this.indice = indice;
        this.txhors = txhors;
        this.code = code;
        this.totHeures = totHeures;
        this.setPaiement(paiement);
    }

    public FichePaie() {
    }

    public List<PaieEditionEltpaie> getListeElementPaie() {
        return listeElementPaie;
    }

    public void setListeElementPaie(List<PaieEditionEltpaie> listeElementPaie) {
        this.listeElementPaie = listeElementPaie;
    }

    public String getMois() {
        return mois;
    }

    public void setMois(String mois) {
        this.mois = mois;
    }

    public String getAnnee() {
        return annee;
    }

    public void setAnnee(String annee) {
        this.annee = annee;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getFonction() {
        return fonction;
    }

    public void setFonction(String fonction) {
        this.fonction = fonction;
    }

    public String getSection() {
        return section;
    }

    public void setSection(String section) {
        this.section = section;
    }

    public String getCategorie() {
        return categorie;
    }

    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }

    public String getMatricule_cnaps() {
        return matricule_cnaps;
    }

    public void setMatricule_cnaps(String matricule_cnaps) {
        this.matricule_cnaps = matricule_cnaps;
    }

    public String getCin() {
        return cin;
    }

    public void setCin(String cin) {
        this.cin = cin;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getClasse() {
        return classe;
    }

    public void setClasse(String classe) {
        this.classe = classe;
    }

    public String getTxhors() {
        return txhors;
    }

    public void setTxhors(String txhors) {
        this.txhors = txhors;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getBrutImposable() {
        return brutImposable;
    }

    public void setBrutImposable(String brutImposable) {
        this.brutImposable = brutImposable;
    }

    public String getLieuTravail() {
        return lieuTravail;
    }

    public void setLieuTravail(String lieuTravail) {
        this.lieuTravail = lieuTravail;
    }

    public String getTotHeures() {
        return totHeures;
    }

    public void setTotHeures(String totHeures) {
        this.totHeures = totHeures;
    }

    public String getPaiement() {
        return paiement;
    }

    public void setPaiement(String paiement) {
        this.paiement = paiement;
    }

    public String getClassification() {
        return classification;
    }

    public void setClassification(String classification) {
        this.classification = classification;
    }

//    public List<FichePaie> getListFichePaieEdition(String idedition) throws Exception {
//        Connection con = null;
//        List<FichePaie> ls = new ArrayList<FichePaie>();
//        try {
//            con = new UtilDB().GetConn();
//            EmployeCompletPdf[] ls_emp = (EmployeCompletPdf[]) CGenUtil.rechercher(new EmployeCompletPdf(), null, null, con, " and id in ( select idpersonnel from PAIE_EDITION_ELTPAIE  where idedition='"+ idedition +"'  ) order by matricule asc ");
//            PaieEditionEltpaie[] ls_elm_paie = (PaieEditionEltpaie[]) CGenUtil.rechercher(new PaieEditionEltpaie(), null, null, con, " and  idedition ='" + idedition + "'   ORDER BY CODE ASC, RANG ASC");
//            int mois = ls_elm_paie[0].getMois() ,  annee = ls_elm_paie[0].getAnnee() ;
//            for (EmployeCompletPdf emp : ls_emp) {
//                FichePaie tmp = new FichePaie();
//                tmp.setMois(  utilitaire.Utilitaire.nbToMois(mois)  );
//                tmp.setAnnee(annee+"");
//                tmp.setMatricule(emp.getMatricule());
//                tmp.setNom(emp.getNom()+" "+emp.getPrenom());
//                tmp.setFonction(emp.getIdfonction());
//                tmp.setNbenfant( emp.getNbenfant() );
//                tmp.setCategorie(emp.getEchelon());
//                tmp.setMatricule_cnaps(utilitaire.Utilitaire.separerEnMillier(emp.getNumero_cnaps()));
//                tmp.setMatricule(emp.getMatricule());
//                tmp.setIndice(emp.getIndice_fonctionnel());
//                tmp.setLieuTravail( emp.getCode_dr() );
//                List<PaieEditionEltpaie> ls_paie = new ArrayList<PaieEditionEltpaie>();
//                List<PaieEditionEltpaie> ls_paie_en_nature = new ArrayList<PaieEditionEltpaie>();                
//                double sG=0,sR=0,sT=0,sBrut=0,sNat=0;                
//                for (PaieEditionEltpaie pee : ls_elm_paie) {
//                    if (pee.getIdpersonnel().compareToIgnoreCase(emp.getId()) == 0) {
//                        if (pee.getImposable().compareToIgnoreCase("I") == 0) {
//                            sBrut += pee.getDroits();
//                        }
//                        if (pee.getIdelementpaie().equalsIgnoreCase(ConstantePaie.id_irsa_nature)) {
//
//                            pee.setElement( pee.getElement() +" ( " + pee.getRemarque()+ " )" );
////                            t.setElement( t.getElement() +" ( -- )" );
////                            t.setRetenues(0);
////                            t.setDroits(0);
//                            ls_paie_en_nature.add(pee);
//                        } else {
//                            sG += pee.getDroits();
//                            sR += pee.getRetenues();
//                            ls_paie.add(pee);
//                        }
//                    }
//                }
//                for( int i =  ls_paie.size() + ls_paie_en_nature.size() ; i <  8 ; i++ ){
//                    ls_paie.add( new PaieEditionEltpaie() );
//                }
//                for (PaieEditionEltpaie pee : ls_paie_en_nature) {
//                    ls_paie.add( pee );
//                }
//                PaieEditionEltpaie bi = new PaieEditionEltpaie();
//                bi.setElement("Brut imposable ( "+ utilitaire.Utilitaire.formaterAr(  sBrut ) +" )");
//                ls_paie.add(bi);                
//                setNet_a_payer( sG-sR );
//                tmp.setMotif(  utilitaire.ChiffreLettre.convertRealToStringDevise(getNet_a_payer(),"Ariary") );
//                tmp.setListeElementPaie(ls_paie);
//                tmp.setConger( emp.getConger() );
//                ls.add(tmp);
//            }
//        } catch (Exception ex) {
//            ex.printStackTrace();
//            throw ex;
//        } finally {
//            if (con != null) {
//                con.close();
//            }
//        }
//        return ls;
//    }
    
    public List<FichePaie> getListFichePaieEdition(String idedition) throws Exception {
        Connection con = null;
        List<FichePaie> ls = new ArrayList<FichePaie>();
        try {
            con = new UtilDB().GetConn();
            EmployeCompletPdf[] ls_emp = (EmployeCompletPdf[]) CGenUtil.rechercher(new EmployeCompletPdf(), null, null, con, " and id in ( select idpersonnel from PAIE_EDITION_ELTPAIE  where idedition='"+ idedition +"'  ) order by matricule asc ");
            PaieEditionEltpaie[] ls_elm_paie = (PaieEditionEltpaie[]) CGenUtil.rechercher(new PaieEditionEltpaie(), null, null, con, " and  idedition ='" + idedition + "'   ORDER BY rangbulletin ASC");
            int mois = ls_elm_paie[0].getMois() ,  annee = ls_elm_paie[0].getAnnee() ;
            for (EmployeCompletPdf emp : ls_emp) {
                FichePaie tmp = new FichePaie();
                tmp.setMois(  utilitaire.Utilitaire.nbToMois(mois));
                tmp.setAnnee(annee+"");
                tmp.setMatricule(emp.getMatricule());
                tmp.setNom(emp.getNom()+" "+emp.getPrenom());
                tmp.setFonction(emp.getIdfonction());
                tmp.setNbenfant( emp.getNbenfant() );
                tmp.setCategorie(emp.getEchelon());
                tmp.setMatricule_cnaps(utilitaire.Utilitaire.separerEnMillier(utilitaire.Utilitaire.champNull( emp.getNumero_cnaps())));
                tmp.setMatricule(emp.getMatricule());
                tmp.setIndice(emp.getIndice());
                tmp.setLieuTravail( emp.getCode_dr() );
                List<PaieEditionEltpaie> ls_paie = new ArrayList<PaieEditionEltpaie>();
                List<PaieEditionEltpaie> ls_paie_en_nature = new ArrayList<PaieEditionEltpaie>();                
                double sBrut=0;                
                for (PaieEditionEltpaie pee : ls_elm_paie) {
                    if (pee.getIdpersonnel().compareToIgnoreCase(emp.getId()) == 0) {
//                        System.out.println("ID-->" + pee.getIdpersonnel() + " - " + pee.getIdelementpaie()+"--"+ConstantePaie.id_net_a_payer_virtuel);
                        if (pee.getIdelementpaie().equalsIgnoreCase("PRUNI")) {
                            sBrut = pee.getRetenues();
                            continue;
                        }
                        if (pee.getIdelementpaie().equalsIgnoreCase("PR000210A")) {
                            setNet_a_payer( pee.getDroits());
                            System.out.println("NET A PAYER =====> "+pee.getDroits() );
                            continue;
                        }
                        if( pee.getAfficher() < 1 )continue;
                        if (pee.getIdelementpaie().equalsIgnoreCase(ConstantePaie.id_irsa_nature)) {
                            if(pee.getDroits()>0){
                                pee.setElement( pee.getElement() +" ( " + pee.getDroits()+ " )" );
                                pee.setDroits(0);
                                ls_paie_en_nature.add(pee);
                            }
                        } else {
//                            sG += pee.getDroits();
//                            sR += pee.getRetenues();
                            ls_paie.add(pee);
                        }
                    }
                }
                for( int i =  ls_paie.size() + ls_paie_en_nature.size() ; i <  8 ; i++ ){
                    ls_paie.add( new PaieEditionEltpaie() );
                }
                for (PaieEditionEltpaie pee : ls_paie_en_nature) {
                    ls_paie.add( pee );
                }
                PaieEditionEltpaie bi = new PaieEditionEltpaie();
                bi.setElement("Brut imposable ( "+ utilitaire.Utilitaire.formaterAr(  ( (int)(  sBrut / 100 )) *100  ) +" )");
                ls_paie.add(bi);                
//                setNet_a_payer( sG-sR );
                tmp.setNet_a_payer(getNet_a_payer());
                tmp.setMotif(  utilitaire.ChiffreLettre.convertRealToStringDevise(getNet_a_payer(),"Ariary") );
                tmp.setListeElementPaie(ls_paie);
                tmp.setConger( emp.getConger() );

                tmp.setIndice(emp.getIndice());
                tmp.setModePaiementLib(emp.getModePaiementLib());
                tmp.setDepartementLib(emp.getDepartementLib());
                tmp.setCategoriePersonnel(emp.getCategoriePersonnel());
                tmp.setSituationMLib(emp.getSituationMLib());
                ls.add(tmp);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            throw ex;
        } finally {
            if (con != null) {
                con.close();
            }
        }
        return ls;
    }
    
       
    public List<FichePaie> getListFichePaieEditionStc(String idedition) throws Exception {
        Connection con = null;
        List<FichePaie> ls = new ArrayList<FichePaie>();
        try {
            con = new UtilDB().GetConn();
            EmployeCompletPdf[] ls_emp = (EmployeCompletPdf[]) CGenUtil.rechercher(new EmployeCompletPdf(), null, null, con, " and id in ( select idpersonnel from PAIE_EDITION_STC_ELTPAIE  where idedition='"+ idedition +"'  ) order by matricule asc ");
            PaieEditionEltpaie el = new PaieEditionEltpaie();
            el.setNomTable("PAIE_EDITION_STC_ELTPAIE");
            PaieEditionEltpaie[] ls_elm_paie = (PaieEditionEltpaie[]) CGenUtil.rechercher(el, null, null, con, " and  idedition ='" + idedition + "'   ORDER BY rangbulletin ASC");
            int mois = ls_elm_paie[0].getMois() ,  annee = ls_elm_paie[0].getAnnee() ;
            for (EmployeCompletPdf emp : ls_emp) {
                FichePaie tmp = new FichePaie();
                tmp.setMois(  utilitaire.Utilitaire.nbToMois(mois));
                tmp.setAnnee(annee+"");
                tmp.setMatricule(emp.getMatricule());
                tmp.setNom(emp.getNom()+" "+emp.getPrenom());
                tmp.setFonction(emp.getIdfonction());
                tmp.setNbenfant( emp.getNbenfant() );
                tmp.setCategorie(emp.getEchelon());
                tmp.setMatricule_cnaps(utilitaire.Utilitaire.separerEnMillier(utilitaire.Utilitaire.champNull( emp.getNumero_cnaps())));
                tmp.setMatricule(emp.getMatricule());
                tmp.setIndice(emp.getIndice());
                tmp.setLieuTravail( emp.getCode_dr() );
                List<PaieEditionEltpaie> ls_paie = new ArrayList<PaieEditionEltpaie>();
                List<PaieEditionEltpaie> ls_paie_en_nature = new ArrayList<PaieEditionEltpaie>();                
                double sBrut=0;                
                for (PaieEditionEltpaie pee : ls_elm_paie) {
                    if (pee.getIdpersonnel().compareToIgnoreCase(emp.getId()) == 0) {
//                        System.out.println("ID-->" + pee.getIdpersonnel() + " - " + pee.getIdelementpaie()+"--"+ConstantePaie.id_net_a_payer_virtuel);
                        if (pee.getIdelementpaie().equalsIgnoreCase("PRUNI")) {
                            sBrut = pee.getRetenues();
                            continue;
                        }
                        if (pee.getIdelementpaie().equalsIgnoreCase("PR000210A")) {
                            setNet_a_payer( pee.getDroits());
                            System.out.println("NET A PAYER =====> "+pee.getDroits() );
                            continue;
                        }
                        if( pee.getAfficher() < 1 )continue;
                        if (pee.getIdelementpaie().equalsIgnoreCase(ConstantePaie.id_irsa_nature)) {
                            if(pee.getDroits()>0){
                                pee.setElement( pee.getElement() +" ( " + pee.getDroits()+ " )" );
                                pee.setDroits(0);
                                ls_paie_en_nature.add(pee);
                            }
                        } else {
//                            sG += pee.getDroits();
//                            sR += pee.getRetenues();
                            ls_paie.add(pee);
                        }
                    }
                }
                for( int i =  ls_paie.size() + ls_paie_en_nature.size() ; i <  8 ; i++ ){
                    ls_paie.add( new PaieEditionEltpaie() );
                }
                for (PaieEditionEltpaie pee : ls_paie_en_nature) {
                    ls_paie.add( pee );
                }
                PaieEditionEltpaie bi = new PaieEditionEltpaie();
                bi.setElement("Brut imposable ( "+ utilitaire.Utilitaire.formaterAr(  ( (int)(  sBrut / 100 )) *100  ) +" )");
                ls_paie.add(bi);                
//                setNet_a_payer( sG-sR );
                tmp.setNet_a_payer(getNet_a_payer());
                tmp.setMotif(  utilitaire.ChiffreLettre.convertRealToStringDevise(getNet_a_payer(),"Ariary") );
                tmp.setListeElementPaie(ls_paie);
                tmp.setConger( emp.getConger() );
                ls.add(tmp);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            throw ex;
        } finally {
            if (con != null) {
                con.close();
            }
        }
        return ls;
    }

    public FichePaie getListFichePaieEditionPersonnel(String idedition,String idpers) throws Exception {
        Connection con = null;
        FichePaie fp = new FichePaie();
        try {
            con = new UtilDB().GetConn();
            EmployeCompletPdf[] ls_emp = (EmployeCompletPdf[]) CGenUtil.rechercher(new EmployeCompletPdf(), null, null, con, " and id in ( select idpersonnel from PAIE_EDITION_ELTPAIE  where idedition='"+ idedition +"' and idpersonnel='"+idpers+"' ) order by matricule asc ");
            PaieEditionEltpaie[] ls_elm_paie = (PaieEditionEltpaie[]) CGenUtil.rechercher(new PaieEditionEltpaie(), null, null, con, " and  idedition ='" + idedition + "'   ORDER BY rangbulletin ASC");
            int mois = ls_elm_paie[0].getMois() ,  annee = ls_elm_paie[0].getAnnee() ;
            for (EmployeCompletPdf emp : ls_emp) {
                FichePaie tmp = new FichePaie();
                tmp.setMois(  utilitaire.Utilitaire.nbToMois(mois));
                tmp.setAnnee(annee+"");
                tmp.setMatricule(emp.getMatricule());
                tmp.setNom(emp.getNom()+" "+emp.getPrenom());
                tmp.setFonction(emp.getIdfonction());
                tmp.setNbenfant( emp.getNbenfant() );
                tmp.setCategorie(emp.getEchelon());
                tmp.setMatricule_cnaps(utilitaire.Utilitaire.separerEnMillier(utilitaire.Utilitaire.champNull( emp.getNumero_cnaps())));
                tmp.setMatricule(emp.getMatricule());
                tmp.setIndice(emp.getIndice());
                tmp.setLieuTravail( emp.getCode_dr() );
                List<PaieEditionEltpaie> ls_paie = new ArrayList<PaieEditionEltpaie>();
                List<PaieEditionEltpaie> ls_paie_en_nature = new ArrayList<PaieEditionEltpaie>();
                double sBrut=0;
                for (PaieEditionEltpaie pee : ls_elm_paie) {
                    if (pee.getElement()!= null) {
                        if (pee.getIdpersonnel().compareToIgnoreCase(emp.getId()) == 0) {
                            //                        System.out.println("ID-->" + pee.getIdpersonnel() + " - " + pee.getIdelementpaie()+"--"+ConstantePaie.id_net_a_payer_virtuel);
                            if (pee.getIdelementpaie().equalsIgnoreCase("PRUNI")) {
                                sBrut = pee.getRetenues();
                                continue;
                            }
                            if (pee.getIdelementpaie().equalsIgnoreCase("PR000210A")) {
                                setNet_a_payer(pee.getDroits());
                                System.out.println("NET A PAYER =====> " + pee.getDroits());
                                continue;
                            }
                            if (pee.getAfficher() < 1) continue;
                            if (pee.getIdelementpaie().equalsIgnoreCase(ConstantePaie.id_irsa_nature)) {
                                if (pee.getDroits() > 0) {
                                    pee.setElement(pee.getElement() + " ( " + pee.getDroits() + " )");
                                    pee.setDroits(0);
                                    ls_paie_en_nature.add(pee);
                                }
                            } else {
                                //                            sG += pee.getDroits();
                                //                            sR += pee.getRetenues();
                                ls_paie.add(pee);
                            }
                        }
                    }

                }
                for( int i =  ls_paie.size() + ls_paie_en_nature.size() ; i <  8 ; i++ ){
//                        ls_paie.add(new PaieEditionEltpaie());
                }
                for (PaieEditionEltpaie pee : ls_paie_en_nature) {
                    if (pee.getElement()!= null) {
                        ls_paie.add(pee);
                    }
                }
                PaieEditionEltpaie bi = new PaieEditionEltpaie();
                bi.setElement("Brut imposable ( "+ utilitaire.Utilitaire.formaterAr(  ( (int)(  sBrut / 100 )) *100  ) +" )");
                ls_paie.add(bi);
//                setNet_a_payer( sG-sR );
                tmp.setNet_a_payer(getNet_a_payer());
                tmp.setMotif(  utilitaire.ChiffreLettre.convertRealToStringDevise(getNet_a_payer(),"Ariary") );
                tmp.setListeElementPaie(ls_paie);
                tmp.setConger( emp.getConger() );
                fp=tmp;
                return fp;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            throw ex;
        } finally {
            if (con != null) {
                con.close();
            }
        }
        return fp;
    }
    
    public int getNbenfant() {
        return nbenfant;
    }

    public void setNbenfant(int nbenfant) {
        this.nbenfant = nbenfant;
    }

    public double getNet_a_payer() {
        return net_a_payer;
    }

    public void setNet_a_payer(double net_a_apyer) {
        this.net_a_payer = net_a_apyer;
    }

    public double getConger() {
        return conger;
    }

    public void setConger(double conger) {
        this.conger = conger;
    }

    @Override
    public String toString() {
        return "FichePaie{" +
                "listeElementPaieSize=" + (listeElementPaie != null ? listeElementPaie.size() : 0) +
                ", mois='" + mois + '\'' +
                ", annee='" + annee + '\'' +
                ", nom='" + nom + '\'' +
                ", fonction='" + fonction + '\'' +
                ", section='" + section + '\'' +
                ", categorie='" + categorie + '\'' +
                ", matricule_cnaps='" + matricule_cnaps + '\'' +
                ", cin='" + cin + '\'' +
                ", matricule='" + matricule + '\'' +
                ", classe='" + classe + '\'' +
                ", classification='" + classification + '\'' +
                ", indice='" + indice + '\'' +
                ", txhors='" + txhors + '\'' +
                ", code='" + code + '\'' +
                ", brutImposable='" + brutImposable + '\'' +
                ", lieuTravail='" + lieuTravail + '\'' +
                ", totHeures='" + totHeures + '\'' +
                ", paiement='" + paiement + '\'' +
                ", nbenfant=" + nbenfant +
                ", motif='" + motif + '\'' +
                ", net_a_payer=" + net_a_payer +
                ", conger=" + conger +
                ", modePaiementLib='" + modePaiementLib + '\'' +
                ", departementLib='" + departementLib + '\'' +
                ", categoriePersonnel='" + categoriePersonnel + '\'' +
                ", situationMLib='" + situationMLib + '\'' +
                '}';
    }

    public double getIndice() {
        return indice;
    }

    public void setIndice(double indice) {
        this.indice = indice;
    }
}