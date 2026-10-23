package affichage;

public class ChampCompteAux extends Champ {
    public ChampCompteAux()
    {
        this.setPageAppelComplete(this.getAc_classeMapping(),this.getAc_valeur(),this.getAc_nomTable());
    }
    public ChampCompteAux(String nomChamp,Formulaire f) throws Exception
    {
        super(nomChamp);
        this.setFormulaire(f);
        if(f.isEstFille()==true)
        {
            affichage.Champ.setPageAppelCompletePropre(f.getChampFille(nomChamp),"pertegain.Tiers",nomChamp,"TIERS", "", "", "");
        }
        else this.setPageAppelCompletePropre("pertegain.Tiers",nomChamp,"TIERS", "", "", "");
    }
}
