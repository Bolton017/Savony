package affichage;

public class ChampCompteIng extends Champ {

    public ChampCompteIng() {
        this.setPageAppelComplete(this.getAc_classeMapping(), this.getAc_valeur(), this.getAc_nomTable());
    }

    public ChampCompteIng(String nomChamp, Formulaire f) throws Exception {
        super(nomChamp);
        this.setFormulaire(f);
        if (f.isEstFille()) {
            Champ.setPageAppelCompletePropre(f.getChampFille(nomChamp), "mg.cnaps.compta.ComptaCompteIngredients", nomChamp, "COMPTA_COMPTE_INGREDIENTS", "libelle;libelle","intitule;idProduit", "");
        } else {
            this.setPageAppelCompletePropre("mg.cnaps.compta.ComptaCompteIngredients", nomChamp, "COMPTA_COMPTE_INGREDIENTS", "", "", "");
        }

    }

    public ChampCompteIng(String nomChamp, String ac_classeMapping, String ac_valeur, String ac_nomTable) {
        super(nomChamp);
        this.setAc_classeMapping(ac_classeMapping);
        this.setAc_valeur(ac_valeur);
        this.setAc_nomTable(ac_nomTable);
        this.setPageAppelCompletePropre(this.getAc_classeMapping(), this.getAc_valeur(), this.getAc_nomTable(), "", "", "");
    }

    public ChampCompteIng(String nomChamp, String ac_classeMapping, String ac_valeur, String ac_nomTable, String aWhere) {
        super(nomChamp);
        this.setAc_classeMapping(ac_classeMapping);
        this.setAc_valeur(ac_valeur);
        this.setAc_nomTable(ac_nomTable);
        this.setPageAppelCompletePropre(this.getAc_classeMapping(), this.getAc_valeur(), this.getAc_nomTable(), "", "", aWhere);
    }
}
