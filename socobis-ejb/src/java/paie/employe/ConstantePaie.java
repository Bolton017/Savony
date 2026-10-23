/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.employe;
import bean.TypeObjet;
/**
 *
 * @author rakotondralambokoto
 */
public class ConstantePaie {
    //    RUB BRUT
    public static final String rub_brut = "PRUNI";
    //    STC
    public static final String rub_ICC = "PR000061ICC";
    public static final String rub_preavis = "PR0000232";
    public static final String rub_indemnite_licenciement = "PR000021LICEN";

    //  Indemnite et Cout repas
    public static final double indemnite_repas_cadre = 1880;
    public static final double indemnite_repas_ouvrier = 1850;
    public static final double cout_repas_cadre = 620;
    public static final double cout_repas_ouvrier = 350;

    //    Rubriques indemnite repas et cout repas
    public static final String rub_indemnite_repas_cadre = "PR0000IDRCADR";
    public static final String rub_indemnite_repas_ouvrier = "PR0000IDROUV";
    public static final String rub_cout_repas_cadre = "PRCNTRET001CADRE";
    public static final String rub_cout_repas_ouvrier = "PRCNTRET001";

    //  ABSENCE HEURE
    public static final String rub_absence_heure = "PR000081RABSMONTH";

    //  ABSENCE CONGE
    public static final String rub_absence_conge = "PR000061ABSCNG";
    //    ABSENCE JOUR
    public static final String rub_absence_jour = "PR000081RABSMONTHDAYS";

    //  MAJORATION DIM 40
    public static final String rub_maj_dim_40 = "PR0000223";

    //  MAJORATION JF 50
    public static final String rub_jf_50 = "PR0000222";

    //  MAJORATION NUIT 50
    public static final String rub_maj_nuit_50 = "PR000NUIT50";

    //  SALAIRE DE BASE (JOURNALIER)
    public static final String rub_sb = "PR000041";

    //  HEURE NORMALE (JOURNALIER)
    public static final String rub_hn = "PR0000220";

    //  HS 30 ET 50
    public static final String rub_hs_50 = "PR0000150HS";
    public static final String rub_hs_30 = "PR0000130HS";
    public static final String rub_hs_50NI = "PR0000150";
    public static final String rub_hs_30NI = "PR0000130";
    public static final String rub_hs_50I = "PR0000150I";
    public static final String rub_hs_30I = "PR0000130I";

    public static final String cnaps = "CONF0001";
    public static final String ostie = "CONF0002";
    public static final String desce_irsa_bareme = "IRSA";
    public static final String irsa_conf = "CONF0008";
    public static final String abbatement_enfant = "CONF0009";
    public static final String CATEGORIE_TEMPORAIRE = "CP0000011";
    public static final String TYPE_PAIEMENT_HEURE_SUP = "TYPEHS001";
    public static final String TYPE_PAIEMENT_AVANCE = "TYPEAVC001";


    public static final String id_sal_base = "PR000041";
    public static final String id_cnaps = "PR000101";
    public static final String id_irsa = "PR000141";
    public static final String id_net_a_payer = "PR000210A";
    public static final String id_net_a_payer_virtuel = "PRUNI";
    public static final String id_abattement = "PR000181";
    public static final String id_irsa_nature = "PR000201";
    public static final double plafondAvance=1;

    public static final String dep_idlicensiement = "TYP0010";
    public static final String dep_iddemission = "TD002";
    public static final String dep_idfincontrat = "TYP001";
    public static final String dep_iddemissionSansPreavis = "TYP0002";

    public static final String idPreavis = "PR0000232";
    public static final String idLicensiement = "PR0000233";
    public static final String idAllocationconge = "PR000061";
    public static final String idPreavisRetenue = "PR0000234";

    public static final String RUBRIQUE_PAR_PIECE = "PRPIECE0001";

    public static final double POINTAGE_CANTINE = 350;
    public static final String RUBRIQUE_POINTAGE_CANTINE = "PRCNTRET001";

    //    TYPE D'ABSENCE
    public static final String TYPE_CONGE = "TYP000004";
    public static final String TYPE_PERMISSION = "TYP000006";
    public static final String TYPE_MATERNITE = "TYP00MAT";
    public static final String idCongeCollectif = "TYPCOL0004";

    public static final String matriculeTemp = "T";
    public static final String idCategoriePaieTemp = "CP0000011";
    public static final String idCrecheprincipale = "CRH000005";

    //Type Mode Paiement
    public static final String TYPE_MP_CHEQUE = "0001";
    public static final String TYPE_MP_ESPECE = "0002";
    public static final String TYPE_MP_VIREMENT = "0003";



    public static final double heuremois=173.33;

    public static final int plafond_avcance = 30;

    public static TypeObjet[] getMoisTous(){
        TypeObjet[] mois = new TypeObjet[12];
        mois[0] = new TypeObjet("1","Janvier","");
        mois[1] = new TypeObjet("2","Fevrier","");
        mois[2] = new TypeObjet("3","Mars","");
        mois[3] = new TypeObjet("4","Avril","");
        mois[4] = new TypeObjet("5","Mai","");
        mois[5] = new TypeObjet("6","Juin","");
        mois[6] = new TypeObjet("7","Juillet","");
        mois[7] = new TypeObjet("8","Aout","");
        mois[8] = new TypeObjet("9","Septembre","");
        mois[9] = new TypeObjet("10","Octobre","");
        mois[10] = new TypeObjet("11","Novembre","");
        mois[11] = new TypeObjet("12","Decembre","");
        return mois;
    }

}
