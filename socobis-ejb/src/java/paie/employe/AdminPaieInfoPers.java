/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.employe;

import bean.AdminGen;
import bean.CGenUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import configuration.Configuration;
import mg.cnaps.compta.ComptaCompte;
import paie.CategorieQualification;
import paie.edition.Paie_edition;
import paie.edition.PaieEditionmoisannee;
import paie.employe.PaieInfoPersEltPaieComplet;
import paie.employe.PaieRubrique;
import paie.generique.DetFormu;
import utilitaire.Utilitaire;

/**
 *
 * @author tahina
 */
public class AdminPaieInfoPers {
    PaieInfoPersonnel[] listePaieInfo;

    public PaieInfoPersonnel[] getListePaieInfo() {
        return listePaieInfo;
    }
    public AdminPaieInfoPers(String nomTabl,int mois,int annee,String direction,String idPers,Connection c, Date dateOuverture, Date dateFermeture)throws Exception
    {
        getPersValide(nomTabl, mois,annee,direction,idPers,c, dateOuverture, dateFermeture);
    }
    
    public void attacherInfo(Configuration[] listeConfig, DetFormu[] listeFormu, PaieRubrique[] listRub) throws Exception
    {
        if (this.getListePaieInfo().length>0)
        {
            listePaieInfo[0].setListeConfig(listeConfig);
            listePaieInfo[0].setListeFormule(listeFormu);
            listePaieInfo[0].setListRub(listRub);
            for(DetFormu det:listeFormu)
            {
                det.remplacerConfParValeur(listeConfig);
            }
        }
    }
    
    
    public void getPersValide(String nomTable,int mois,int annee,String service,String idPers,Connection c, Date dateOuverture, Date dateFermeture) throws Exception
    {
        PaieInfoPersonnel crt=new PaieInfoPersonnel();
        crt.setNomTable("PAIE_INFO_PERSONNELDIRECT");
        if(nomTable!=null && nomTable.compareToIgnoreCase("")!=0) crt.setNomTable(nomTable);
        String aW=" and ( direction='"+service+"' and etat=11 ";

        String finMois=Utilitaire.formatterDatySql(Utilitaire.getFinDuMoisByMoisAnnee(mois, annee));
        
        aW+=" or id in (select idlogpers from log_personnel_non_valide where dateapplication>='"+"01/"+mois+"/"+annee+"' and dateapplication<='"+finMois+"' ))";

        if(idPers!=null&&idPers.compareToIgnoreCase("")!=0)crt.setId(idPers);
        PaieInfoPersonnel[] liste=(PaieInfoPersonnel[])CGenUtil.rechercher(crt, null, null, c, aW);
        
        
        if(liste.length==0){
            throw new Exception ("Aucun personnel trouvé pour cette direction");
        }

        System.out.println("Liste personne azo");
        for(PaieInfoPersonnel temp : liste){
    
            System.out.println("ID ==> "+temp.getId()); 
            PaieEditionmoisannee paieEdition = new PaieEditionmoisannee();
            paieEdition.setDateOuverture(dateOuverture);
            paieEdition.setDateFermeture(dateFermeture);
            int nbSemaine = paieEdition.getNbSemaine();

            temp.calculSalaire(c,temp.getId(), mois, annee, nbSemaine);

        }
        this.setListePaieInfo(liste);
    }

    public void setListePaieInfo(PaieInfoPersonnel[] listePaieInfo) {
        this.listePaieInfo = listePaieInfo;
    }
    public AdminPaieInfoPers(PaieInfoPersonnel[] l)
    {
        this.setListePaieInfo(l);
    }
    public AdminPaieInfoPers(ArrayList<PaieInfoPersEltPaieComplet> l)
    {
        
    }
    public void remplirEltPaie(PaieInfoPersonnel pers, PaieEditionmoisannee idEdition ) throws Exception
    {
        //for(PaieInfoPersonnel pers:this.getListePaieInfo())
        {
            pers.nettoyerDoublons();
            pers.initFormule(idEdition);
            pers.evaluerFormule();
//            pers.calculAppoint();
//            pers.calculerNAP();

        }
        
    }
    public void executeTous(Connection c , PaieEditionmoisannee idEdition, String idPeriode) throws Exception
    {
        PreparedStatement stmt=null;
        try
            {
            String sqlQry = "INSERT INTO paie_edition (ID, IDPERSONNEL , IDELEMENTPAIE, MOIS, ANNEE, GAIN, RETENUE, DATEDEBUT, DATEFIN,IDEDITION,REMARQUE,nbenfant,idfonction,idcategorie,tauxhoraire,salairedebase,temporaire,matricule,direction,service,regroupement,modepaiement,etat,idPeriodePaie) VALUES (";
            sqlQry = sqlQry+ "'ELP' || SEQ_PAIE_EDITION.NEXTVAL";
            sqlQry=sqlQry+ " , ? , ? , ? , ? , ? , ? , ? , ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?";
            sqlQry=sqlQry+ ")";
            stmt=c.prepareStatement(sqlQry);
            System.out.println(" Nombre personnel ------------> "+ this.getListePaieInfo().length );
            System.out.println(sqlQry);
            for(PaieInfoPersonnel pers:this.getListePaieInfo())
            {

               System.out.println(" ID pers d >  " + pers.getId() +"           | Nombre d'element " + pers.getCnaps12()  );
//                System.out.println(" ID pers d a inserer >  " + pers.getId() +" | Nombre d'element " + pers.getListeEltAInserer().size()  );
                remplirEltPaie(pers, idEdition );
//                System.out.println(" ID pers f >  " + pers.getId() +"           | Nombre d'element " + pers.getListeElt().size()  );
//                System.out.println(" ID pers f a inserer >  " + pers.getId() +" | Nombre d'element " + pers.getListeEltAInserer().size()  );
                pers.afficher();
                pers.setIdPeriodePaie(idPeriode);
                pers.getPrepared(stmt);
            }
            stmt.executeBatch();
        }
        catch(Exception e)
        {
            e.printStackTrace();
            c.rollback();
            throw e;
        }
        finally
        {
            if(stmt!=null)
            {
                stmt.clearBatch();
                stmt.close();
            }
            
        }
    }
    public void ajouterElement(ResultSet rst,int moi,int an) throws Exception
    {   
        int size =0;
        while (rst.next()) 
        {                
            PaieInfoPersEltPaieComplet eltPaie = new PaieInfoPersEltPaieComplet();
            {
                System.out.println("Ajout element");
                eltPaie.setId(rst.getString("ID"));
                eltPaie.setCode_rubrique(rst.getString("CODE_RUBRIQUE"));
                eltPaie.setNationalite(rst.getString("NATIONALITE"));
                eltPaie.setDate_debut(rst.getDate("DATE_DEBUT"));
                eltPaie.setDate_fin(rst.getDate("DATE_FIN"));
                eltPaie.setGain(rst.getDouble("GAIN"));
                eltPaie.setRetenue(rst.getDouble("RETENUE"));
                eltPaie.setRemarque(rst.getString("REMARQUE"));
                eltPaie.setIdpersonnel(rst.getString("IDPERSONNEl"));
                eltPaie.setVal(rst.getString("VAL"));
                eltPaie.setDesce(rst.getString("DESCE"));
                eltPaie.setRang(rst.getInt("RANG"));
                eltPaie.setComptepcg(rst.getString("COMPTEPCG"));
                eltPaie.setCode(rst.getString("CODE"));
                eltPaie.setTyperubrique(rst.getString("TYPERUBRIQUE"));
                eltPaie.setImposable(rst.getString("IMPOSABLE"));
                eltPaie.setNature(rst.getString("NATURE"));
                eltPaie.setAvantage(rst.getString("AVANTAGE"));
                eltPaie.setIsrappel(rst.getInt("ISRAPPEL"));
                eltPaie.setIsconfeltfixe(rst.getInt("ISCONFELTFIXE"));
                eltPaie.setMois(moi);
                eltPaie.setAnnee(an);
                eltPaie.setDatesaisie(rst.getDate("DATESAISIE"));
                eltPaie.setMatricule(rst.getString("MATRICULE"));
                eltPaie.setIdfonction(rst.getString("IDFONCTION"));
                eltPaie.setIdgroupefonction(rst.getString("IDGROUPEFONCTION"));
                eltPaie.setIdcategorie(rst.getString("IDCATEGORIE"));
                eltPaie.setClassee(rst.getString("CLASSEE"));
                eltPaie.setIndicegrade(rst.getString("INDICEGRADE"));
                eltPaie.setIndice_fonctionnel(rst.getString("INDICE_FONCTIONNEL"));
                eltPaie.setStatut(rst.getString("STATUT"));
                eltPaie.setDroit_hs(rst.getString("DROIT_HS"));
                eltPaie.setDirection(rst.getString("DIRECTION"));
                eltPaie.setService(rst.getString("SERVICE"));
                eltPaie.setCPT_GEN_CR(rst.getString("CPT_GEN_CR"));
                eltPaie.setCPT_GEN_DB(rst.getString("CPT_GEN_DB"));
                eltPaie.setCPT_ANA_CR(rst.getString("CPT_ANA_CR"));
                eltPaie.setCPT_ANA_DB(rst.getString("CPT_ANA_DB"));
                eltPaie.setNbenfant(rst.getInt("NBENFANT"));
                eltPaie.setId_objet(rst.getString("ID_OBJET"));
                eltPaie.setTemporaire(rst.getInt("TEMPORAIRE"));
                eltPaie.setRemarque(rst.getString("REMARQUE_ELEMENT"));
                eltPaie.setPointindice(rst.getString("POINTINDICE"));
                eltPaie.setBanque_numero_compte(rst.getString("banque_numero_compte"));
                eltPaie.setFormu(rst.getString("formu"));
                eltPaie.setInserted(rst.getInt("inserted"));
                eltPaie.setSommable(rst.getInt("sommable"));
                eltPaie.setBeneficiaire(rst.getString("beneficiaire"));
                eltPaie.setMere(rst.getString("mere"));
                eltPaie.setQteformule(rst.getString("qteformule"));
                eltPaie.setRemarqueformule(rst.getString("remarqueformule"));
                eltPaie.setUniteformule(rst.getString("uniteformule"));
                eltPaie.setIdcategorie_paie(rst.getString("idcategorie_paie"));
                eltPaie.setIdfonction(rst.getString("idfonction"));
                eltPaie.setIdqualification(rst.getString("idqualification"));
                eltPaie.setRegroupement(rst.getInt("regroupement"));
                String[] colFiltre={"id"};
                String[]valFiltre={eltPaie.getIdpersonnel()};
                System.out.println("  --- info pers --- " + listePaieInfo.length +" -- "+ eltPaie.getIdpersonnel() );
                PaieInfoPersonnel[] concerne=(PaieInfoPersonnel[])AdminGen.find(listePaieInfo, colFiltre, valFiltre);
                if (concerne == null || concerne.length == 0) {
                    System.out.println("Element ignoré (personnel non valide) : "+ eltPaie.getIdpersonnel());
                    continue;
                }
                concerne[0].getListeElt().add(eltPaie);     
                PaieInfoPersEltPaieComplet eltPaieInserer=new PaieInfoPersEltPaieComplet();
                eltPaieInserer.copier(eltPaie);
                if(eltPaieInserer.getCode().compareToIgnoreCase("101")!=0)
                {
                    eltPaieInserer.setMois(moi);
                    eltPaieInserer.setAnnee(an);
                }
                concerne[0].setMois(eltPaieInserer.getMois());
                concerne[0].setAnnee(eltPaieInserer.getAnnee());
                System.out.println("Element de pai "+ eltPaie.getCode_rubrique()+ " | " + eltPaieInserer.getCode_rubrique()  + "  Personnel ------" + eltPaie.getIdpersonnel() +"---------->"+ eltPaieInserer.getIdpersonnel() );
                concerne[0].setMois_edition(moi);
                concerne[0].setAnnee_edition(an);
                concerne[0].getListeEltAInserer().add(eltPaieInserer);
                
            }
        }
    }
    
}
