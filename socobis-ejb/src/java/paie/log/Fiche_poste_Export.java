package paie.log;


import bean.CGenUtil;
import bean.TypeObjet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Axel
 */
public class Fiche_poste_Export extends Fiche_poste {
    private List ls_tache1,ls_tache2,ls_tache3,ls_tache4,ls_tache5,ls_idorganigramme,ls_condition_travail,ls_competence,ls_idformation_diplome,ls_idfonction;
    
    public List getLs_tache1() {
        return castToList( getTache1() );
    }

    public void setLs_tache1(List ls_tache1) {
        this.ls_tache1 = ls_tache1;
    }

    public List getLs_tache2() {
        return castToList(  getTache2() );
    }

    public void setLs_tache2(List ls_tache2) {
        this.ls_tache2 = ls_tache2;
    }

    public List getLs_tache3() {
        return castToList(  getTache3() );
    }

    public void setLs_tache3(List ls_tache3) {
        this.ls_tache3 = ls_tache3;
    }

    public List getLs_tache4() {
        return castToList(  getTache4() );
    }

    public void setLs_tache4(List ls_tache4) {
        this.ls_tache4 = ls_tache4;
    }

    public List getLs_tache5() {
        return castToList(  getTache5() );
    }

    public void setLs_tache5(List ls_tache5) {
        this.ls_tache5 = ls_tache5;
    }

    public List getLs_idorganigramme() {
//        return ls_idorganigramme;
        return castToList(  getIdorganigramme() );
    }

    public void setLs_idorganigramme(List ls_idorganigramme) {
        this.ls_idorganigramme = ls_idorganigramme;
    }

    public List getLs_condition_travail() {
        return castToList(  getCondition_travail() );
//        return ls_condition_travail;
    }

    public void setLs_condition_travail(List ls_condition_travail) {
        this.ls_condition_travail = ls_condition_travail;
    }

    public List getLs_competence() {
//        return ls_competence;
        return castToList(  getCompetence() );        
    }

    public void setLs_competence(List ls_competence) {
        this.ls_competence = ls_competence;
    }

    public List getLs_idformation_diplome() {
//        return ls_idformation_diplome;
        return castToList(  getIdformation_diplome() );                
    }

    public void setLs_idformation_diplome(List ls_idformation_diplome) {
        this.ls_idformation_diplome = ls_idformation_diplome;
    }

    public List getLs_idfonction() {
//        return ls_idfonction;
        return castToList(  getIdfonction() );                
    }

    public void setLs_idfonction(List ls_idfonction) {
        this.ls_idfonction = ls_idfonction;
    }

    public Fiche_poste_Export getFichePost( ) throws Exception{
        Fiche_poste_Export f = ( Fiche_poste_Export ) CGenUtil.rechercher(this, null, null,  " and id='"+ this.getId() +"'")[0];
        return f ;
    }
    public List castToList( String champ ){
        System.out.println("Val ---------->" + champ);
        if( champ == null || champ.compareToIgnoreCase("") == 0 ){
            return null;
        }
        List<TypeObjet> ls = new ArrayList<TypeObjet>();
        String[] tab = champ.split(";");
        if(  tab == null || tab.length == 0  ){
            ls = null ;
        }else{
            for( String t : tab ){
                TypeObjet to = new TypeObjet();
                to.setVal( t );
                ls.add( to );
            }
        }
        return ls;
    }
    
}
