/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.avance;

import bean.CGenUtil;
import bean.ClassEtat;
import java.sql.Connection;
import java.sql.Date;
import paie.elementpaie.PaiePersonnelElementpaie;
import paie.employe.ConstantePaie;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import paie.employe.EmployeComplet2;
/**
 *
 * @author Sambatra Rakotondrainibe
 */
public class Avance extends ClassEtat{
    private String id;
    private String idpersonnel;
    private double montant;
    private int nbremboursement=-1;
    private String remarque;
    private Date daty;
    private Date dateAvance;
    private String idtypeavance;
    private String matricule,idtypeavancelib,etatlib;
    private double interet;


    public void setIdtypeavance(String idtypeavance) throws Exception{

        if(idtypeavance.equalsIgnoreCase("PRU0453") && nbremboursement>-1){
            if(nbremboursement<=1) throw new Exception("Erreur nombre de remboursement Exceptionnelle doit Ãªtre supÃ©rieur Ã  1 : "+nbremboursement);
        } else if (idtypeavance.equalsIgnoreCase("PRU0447")  && nbremboursement>-1 ) {
            if(nbremboursement!=1) throw new Exception("Erreur nombre de remboursement sur salaire diffÃ©rent Ã  1 : "+nbremboursement);
        }
        this.idtypeavance = idtypeavance;
    }

    public String getIdtypeavancelib() {
        return idtypeavancelib;
    }

    public void setIdtypeavancelib(String idtypeavancelib){
        this.idtypeavancelib = idtypeavancelib;
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public Avance() {
        super.setNomTable("avance");
    }

    public String getIdtypeavance() {
        return idtypeavance;
    }



    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdpersonnel() {
        return idpersonnel;
    }

    public void setIdpersonnel(String idpersonnel) {
        this.idpersonnel = idpersonnel;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) throws Exception{
        if(montant<0)throw new Exception("Erreur montant negatif : "+montant);
        if(montant==0)throw new Exception("Erreur montant null : "+montant);
        this.montant = montant;
    }

    @Override
    public boolean getEstIndexable() {
        return true;
    }

    public int getNbremboursement() {
        return nbremboursement;
    }

    public void setNbremboursement(int nbremboursement) throws Exception {
        if(this.getMode().compareToIgnoreCase("modif")==0 && nbremboursement<1)throw new Exception("Erreur nombre de remboursement inférieur à  1 : "+nbremboursement);
        if(idtypeavance!=null){
            if(idtypeavance.equalsIgnoreCase("PRU0453")){
                if(nbremboursement<=1) throw new Exception("Erreur nombre de remboursement Exceptionnelle inférieur à  1 : "+nbremboursement);
            } else if (idtypeavance.equalsIgnoreCase("PRU0447")) {
                if(nbremboursement!=1) throw new Exception("Erreur nombre de remboursement sur salaire différent à  1 : "+nbremboursement);
            }
        }


        this.nbremboursement = nbremboursement;
    }
    public void controler(Connection c) throws Exception
    {
        EmployeComplet2 empt=new EmployeComplet2();
        empt.setNomTable("employe_complet_libelle3");
        empt=empt.intialize(this.getIdpersonnel(), c);
        if(empt!=null){
            if((this.getMontant()/nbremboursement)>(empt.getSalairebase()* ConstantePaie.plafondAvance)){
                throw new Exception("Erreur montant de remboursement mensuel supérieur   30 % de la salaire de base "+(Utilitaire.formaterAr(empt.getSalairebase()*ConstantePaie.plafondAvance))+" Ar < "+Utilitaire.formaterAr(this.getMontant()/nbremboursement)+" Ar remboursement");
            }
        }
    }
    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public Date getDateAvance() {
        return dateAvance;
    }

    public void setDateAvance(Date dateAvance) throws Exception {
        if (this.getMode().equals("modif") && dateAvance == null) {
            throw new Exception("La date de demande d'avance ne peut pas etre vide.");
        }
        if (this.getMode().equals("modif") && dateAvance.compareTo(Utilitaire.dateDuJourSql()) < 0) {
            throw new Exception("Date de demande d'avance invalide ! Elle doit etre superieure ou egale a la date du jour.");
        }
        this.dateAvance = dateAvance;
    }


    public void controlerUpdate() throws Exception {
        if( getEtat() >= 11  ) throw new Exception("Erreur de modification, Objet deja vise");
    }

    @Override
    public String getTuppleID() {
        return getId(); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public String getAttributIDName() {
        return "id"; //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("AVC", "GET_SEQ_AVANCE");
        this.setId(makePK(c));
    }
    
    


    //rehefa mi-viser avance dia : manaoupdate etat avance = 11 | update etat plan remboursement  = 11 ary miantso an'ito fonction ito dia avy eo inserena ireo PaiePersonnelElementpaie[] etat 1
    public PaiePersonnelElementpaie[] getElementPaie(String iduser)throws Exception{
        PaiePersonnelElementpaie[] retour = null;
//        String idavance = "PRU000426";
        Connection c = null;
        try{
            c = new UtilDB().GetConn();
            Remboursement[] remboursement = (Remboursement[])CGenUtil.rechercher(new Remboursement(), null, null, c, " and idavance = '"+getId()+"'");
            if(remboursement.length>0){
                retour = new PaiePersonnelElementpaie[remboursement.length];
                for(int i = 0;i<remboursement.length;i++){
                    PaiePersonnelElementpaie temp = new PaiePersonnelElementpaie();
                    temp.setCode_rubrique(getIdtypeavance());
                    temp.setDate_debut(Utilitaire.stringDate("01/"+remboursement[i].getMois()+"/"+remboursement[i].getAnnee()));
                    String date_fin = Utilitaire.getNombreJourMois(String.valueOf(remboursement[i].getMois()),String.valueOf(remboursement[i].getAnnee()))+"/"+remboursement[i].getMois()+"/"+remboursement[i].getAnnee();
                    temp.setDate_fin(Utilitaire.stringDate(date_fin));
                    temp.setGain(0);
                    temp.setRetenue(remboursement[i].getMontant());
//                    temp.setRemarque("Remboursement "+(i+1)+" de l avance : "+Utilitaire.formaterAr(getMontant())+" ("+getId()+")");
                    temp.setRemarque("");
                    temp.setIdpersonnel(getIdpersonnel());
                    temp.setEtat(1);
                    temp.setId_objet(remboursement[i].getId());
                    temp.setIduser(iduser);
                    temp.setMoisregularisation(remboursement[i].getMois()+"");
                    temp.setAnneeregularisation(remboursement[i].getAnnee()+"");

//                    temp.construirePK(c);
                    retour[i] = temp;
                }
            }
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }finally{
            if(c!=null)c.close();
        }
        return retour;
    }

    public void saveToElementPaie(Remboursement pl, Connection c , String mapUser) throws Exception {
        try {
            PaiePersonnelElementpaie temp = new PaiePersonnelElementpaie();
            temp.setCode_rubrique(getIdtypeavance());
            temp.setDate_debut(Utilitaire.stringDate("01/" + pl.getMois() + "/" + pl.getAnnee()));
            String date_fin = Utilitaire.getNombreJourMois(String.valueOf(pl.getMois()), String.valueOf(pl.getAnnee())) + "/" + pl.getMois() + "/" + pl.getAnnee();
            temp.setDate_fin(Utilitaire.stringDate(date_fin));
            temp.setGain(0);
            temp.setRetenue(pl.getMontant());
            temp.setRemarque("");
            temp.setIdpersonnel(getIdpersonnel());
            temp.setEtat(11);
            temp.setId_objet(pl.getRemarque());
            temp.setIduser(getIduser());
            temp.setMoisregularisation(pl.getMois() + "");
            temp.setAnneeregularisation(pl.getAnnee() + "");
            temp.construirePK(c);
            temp.insertToTableWithHisto( mapUser , c);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }

    }

    public void solderAvance( String mapUser , Connection c ) throws Exception {
        int connex = 0 ;
        try{
            if(c==null){
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                connex = 1;
            }
            Avance[] lsa= (Avance[]) CGenUtil.rechercher(this, null, null,c, "");
            if( lsa == null || lsa.length == 0 ){
                throw new Exception(" Avance non trouver");
            }
            if( lsa[0].getEtat() <11 ){
                throw new Exception(" Avance non valider");
            }
            Remboursement p = new Remboursement();
            p.setIdavance( getId() );
            Remboursement[] ls =  p.listPlanRemb( " and etat=1 ", c);
            if(ls == null || ls.length == 0)throw new Exception("Avance deja soldÃ©!");
            double mnt = 0 ;
            for( Remboursement tmp : ls  ){
                mnt+=tmp.getMontant();
                tmp.deleteToTableWithHisto(mapUser, c);
            }
            p.setMois( ls[0].getMois() );
            p.setAnnee( ls[0].getAnnee() );
            p.setMontant( mnt );
            p.setEtat(11);
            p.construirePK(c);
            p.insertToTableWithHisto( mapUser , c);
            lsa[0].saveToElementPaie(p, c, mapUser);
        }catch(Exception e){
            c.rollback();
            e.printStackTrace();
            throw e;
        }finally{
            if( c!=null && connex==1)c.close();
        }

    }


//    public PaieElementManuelle[] getElementPaie(Remboursement[] remboursement,String iduser)throws Exception{
//        PaieElementManuelle[] retour = null;
////        String idavance = "PRU000426";
//        try{
//
//            System.out.println("longeur remboursement = "+remboursement.length);
//            if(remboursement.length>0){
//                retour = new PaieElementManuelle[remboursement.length];
//                for(int i = 0;i<remboursement.length;i++){
//                    PaieElementManuelle temp = new PaieElementManuelle();
////                    temp.setNomTable("paie_element_manuelle");
//                    temp.setCoderubrique(getidtypeavance());
//                    temp.setDatedebut(Utilitaire.stringDate("01/"+remboursement[i].getMois()+"/"+remboursement[i].getAnnee()));
//                    String date_fin = Utilitaire.getNombreJourMois(String.valueOf(remboursement[i].getMois()),String.valueOf(remboursement[i].getAnnee()))+"/"+remboursement[i].getMois()+"/"+remboursement[i].getAnnee();
//                    temp.setDatefin(Utilitaire.stringDate(date_fin));
//                    temp.setGain(0);
//                    temp.setRetenue(remboursement[i].getMontant());
//                    temp.setRemarque("Remboursement "+(i+1)+" de l avance : "+Utilitaire.formaterAr(getMontant())+" ("+getId()+")");
//                    temp.setIdpersonnel(getIdpersonnel());
//                    temp.setEtat(1);
//                    temp.setIdobjet(remboursement[i].getId());
//                    temp.setIduser(iduser);
//                    temp.setMoisregularisation(remboursement[i].getMois()+"");
//                    temp.setAnneeregularisation(remboursement[i].getAnnee()+"");
////                    temp.construirePK(c);
//                    retour[i] = temp;
//                }
//            }
//        }catch(Exception e){
//            e.printStackTrace();
//            throw e;
//        }
//        return retour;
//    }


        public void solderAvance2( String mapUser , Connection c ) throws Exception {
        int connex = 0 ;
        try{
            if(c==null){
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                connex = 1;
            }
            if( this.getEtat()<11 ) throw new Exception(" Avance non valider");
            Remboursement p = new Remboursement();
            p.setIdavance(getId());
            Remboursement[] ls =  p.listPlanRemb( " and etat=1 ", c);

            double mnt = 0 ;
            System.out.println("tonga ato");
            for(int i=0;i<ls.length;i++) saveToElementPaie(ls[i],c,mapUser);
        }catch(Exception e){
            c.rollback();
            e.printStackTrace();
            throw e;
        }finally{
            if( c!=null && connex==1)c.close();
        }

    }


    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            super.validerObject(u, c);
            this.solderAvance2(u, c);

            if(estOuvert==true)c.commit();
            return this;

        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    
    public double getInteret() {
        return interet;
    }

    public void setInteret(double interet) throws Exception {
        if(this.getMode().compareToIgnoreCase("modif")==0 && interet<0)throw new Exception("Erreur Interet inférieur à  0 : votre interet est de ="+ interet);
        this.interet = interet;
    }


    @Override
    public String[] getMotCles() {
        String[] motCles={"id","matricule","montant"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] valMotCles={"id","matricule","montant"};
        return valMotCles;
    }
}
