package mg.cnaps.compta;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMAPTable;
import com.google.gson.Gson;
import mg.cnaps.compta.utilitaire.UtilitaireFormu;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Vector;

public class BilanCompte  extends ClassMAPTable {

    ComptaSousEcriture [] comptaSousEcriture;
    LigneBilan []  ligneBilan;
    static EtatSortie [] etatSortie;
    boolean sansEcriture = false;

    public boolean isSansEcriture() {
        return sansEcriture;
    }

    public ComptaSousEcriture[] getComptaSousEcriture() {
        return comptaSousEcriture;
    }

    public void setComptaSousEcriture(ComptaSousEcriture[] comptaSousEcriture) {
        this.comptaSousEcriture = comptaSousEcriture;
    }

    public LigneBilan[] getLigneBilan() {
        return ligneBilan;
    }

    public void setLigneBilan(LigneBilan[] ligneBilan) {
        this.ligneBilan = ligneBilan;
    }

    public static EtatSortie[] getEtatSortie() {
        return etatSortie;
    }

    public static void setEtatSortie(EtatSortie[] etatSortie) {
        BilanCompte.etatSortie = etatSortie;
    }

    public BilanCompte(){

    }
    public static String findNomEtat(String typeetat) throws Exception{
        if(typeetat.equals("1")){
            return "Bilan Actif";
        }
        else if(typeetat.equals("2")){
            return "Bilan Capitaux Propres et Passif";
        }
        else if(typeetat.equals("3")){
            return "Compte de resultat";
        }
        throw new Exception("Type d'état invalide pour "+typeetat);
    }
    public BilanCompte(String nomEtat, String annee) throws Exception {
        nomEtat = findNomEtat(nomEtat);
        ComptaSousEcriture comptaSousEcriture = new ComptaSousEcriture();
        comptaSousEcriture.setNomTable("SousEcritureGroupeByUnionVise");
        //comptaSousEcriture.setExercice(Integer.parseInt(annee));
        ComptaSousEcriture[] comptaSousEcritureArray = (ComptaSousEcriture[]) CGenUtil.rechercher(comptaSousEcriture,null,null," and exercice="+annee);
        sansEcriture = (comptaSousEcritureArray.length==0);
        setComptaSousEcriture(comptaSousEcritureArray);

        EtatSortie etat = new EtatSortie();
        etat.setNom(nomEtat);
        System.err.println("===============>"+nomEtat);
        EtatSortie[]  etatSortie = (EtatSortie[]) CGenUtil.rechercher(etat,null,null," and (formule1 is not null or formule2 is not null) order by rang,niveau");
        setEtatSortie(etatSortie);
        makeLigneBilan();
    }
    public void makeLigneBilan() throws Exception {
        ArrayList<LigneBilan> ligneBilan = new ArrayList<LigneBilan>();
        for(EtatSortie etatSortie : getEtatSortie()){
            LigneBilan b = new LigneBilan();
            if(sansEcriture){
                b.setType(etatSortie.getCategorie());
                b.setLibelle(etatSortie.getLibelle());
                ligneBilan.add(b);
                continue;
            }
            if(etatSortie.getFormule1()!=null){
                String form1=UtilitaireFormu.remplacerRubriqueParChiffre(getComptaSousEcriture(),etatSortie.getFormule1());
                System.err.println(etatSortie.getFormule1());
                System.err.println(form1);
                double val1 = UtilitaireFormu.calculerFormule(form1);
                System.err.println("TOTAL = "+val1);
                b.setValeur1(val1);
            }


            if(etatSortie.getFormule2()!=null){
                String form2=UtilitaireFormu.remplacerRubriqueParChiffre(getComptaSousEcriture(),etatSortie.getFormule2());
                double val2 = UtilitaireFormu.calculerFormule(form2);
                b.setValeur2(val2);
            }


            b.setType(etatSortie.getCategorie());
            b.setLibelle(etatSortie.getLibelle());

            ligneBilan.add(b);
        }
        setLigneBilan((LigneBilan[]) ligneBilan.toArray(new LigneBilan[0]));
        for(LigneBilan l : getLigneBilan()){
            System.err.println(l.getLibelle()+"="+l.getValeur1()+"="+l.getValeur2());
        }
    }
    public double findLigneBilan(String libelle,int pos) throws Exception {
        LigneBilan[] lb = (LigneBilan[]) AdminGen.findCast(getLigneBilan(),new String[]{"libelle"},new String[]{libelle});
        if(pos==1){
            if(lb!=null && lb.length>0){
                LigneBilan ligneBilan = lb[0];
                return ligneBilan.getValeur1();
            }
        }
        else if(pos==2){
            if(lb!=null && lb.length>0){
                LigneBilan ligneBilan = lb[0];
                return ligneBilan.getValeur2();
            }
        }
        throw new Exception("Position de colonne invalide pour ligne bilan "+pos);
    }

    @Override
    public String getTuppleID() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public String getAttributIDName() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
}
