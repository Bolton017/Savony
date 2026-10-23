package utils;

import java.util.Objects;

public class ConstanteSavonnerie {

    public static String VEHICULE_ID_CATEGORIEINGREDIENT = ParametreConstante.getString("PRMS487", "CAT010");
    public static String CATEGORIE_PRODUIT_FINIE = ParametreConstante.getString("PRMS488", "CAT008");
    public static String UNITE_CARTON = ParametreConstante.getString("PRMS489", "UNT005042");
    public static String UNITE_PIECE = ParametreConstante.getString("PRMS490", "UNT00010");
    public static String ING_FRAIS_LIVRAISON = ParametreConstante.getString("PRMS491", "DEP0001");
    public static String ING_FORFAIT_LIVRAISON = ParametreConstante.getString("PRMS492", "DEP0002");
    public static String ID_UNITE_SIMPLE = ParametreConstante.getString("PRMS493", "UNT00005");
    public static String CATEGORIE_MATIERE_PREMIERE = ParametreConstante.getString("PRMS494", "CAT004");
    public static String CATEGORIE_SERVICES = ParametreConstante.getString("PRMS495", "CATS000001");
    public static String TYPE_ATELIER_FABRICATION = ParametreConstante.getString("PRMS496", "PHARM003");
    public static String TYPE_ATELIER_PRODUCTION = ParametreConstante.getString("PRMS497", "PHARM008");
    public static String PRIORITE_NORMAL = ParametreConstante.getString("PRMS498", "P000003");
    public static String IngFraislivraison = ParametreConstante.getString("PRMS499", "DEP0001");
    public static String IngForfaitlivraison = ParametreConstante.getString("PRMS500", "DEP0002");
    public static String idCaisse = ParametreConstante.getString("PRMS501", "CAIS001");
    public static final String ID_AVOIR_RISTOURNE = ParametreConstante.getString("PRMS502", "TYA0001");
    public static final String MAGASIN_APPRO = ParametreConstante.getString("PRMS503", "MAGAPPRO1");
    public static final String CLIENT_APPRO_VENTE = ParametreConstante.getString("PRMS504", "CLI00SOCT0141100245");
    public static final String CLIENT_DIVERS = ParametreConstante.getString("PRMS505", "CLI000576");
    public static final String idtyperistourne = ParametreConstante.getString("PRMS506", "TYA0001");
    public static final String magasin = ParametreConstante.getString("PRMS507", "PNT0000004");
    public static final String ID_POINT_AMPEFILOHA = ParametreConstante.getString("PRMS508", "PNT0000004");
    public static String lieuMagasin = ParametreConstante.getString("PRMS509", "Besarety, Antananarivo");
    public static String tel = ParametreConstante.getString("PRMS510", "+261 34 21 567 88");
    public static String tel1 = ParametreConstante.getString("PRMS511", "");
    public static String tel2 = ParametreConstante.getString("PRMS512", "");
    public static String nif = ParametreConstante.getString("PRMS513", "40 00 04 79 35");
    public static String stat = ParametreConstante.getString("PRMS514", "46 10 11 19 10");
    public static String disponibilite1 = ParametreConstante.getString("PRMS515", "Lundi au Samedi : 7h30 - 15h00");
    public static String disponibilite2 = ParametreConstante.getString("PRMS516", "");
    public static String mail = ParametreConstante.getString("PRMS517", "pem.nosybe@gmail.com");
    public static final String ROLE_DG = ParametreConstante.getString("PRMS518", "dg");
    public static final String ROLE_CG = ParametreConstante.getString("PRMS519", "cg");
    public static final String ROLE_RESPACHAT = ParametreConstante.getString("PRMS520", "respachat");
    public static final String ROLE_CHEFFAB = ParametreConstante.getString("PRMS521", "cheffab");
    public static final String ROLE_CHEF_DEP = ParametreConstante.getString("PRMS522", "chef_dep");
    public static final String ROLE_ACHAPPROV = ParametreConstante.getString("PRMS556", "achapprov");
    public static final String COMPTE_VENTE = ParametreConstante.getString("PRMS523", "72004");
    public static final String COMPTE_ACHAT = ParametreConstante.getString("PRMS524", "602100");
    public static final String ID_DEVISE_AR = ParametreConstante.getString("PRMS525", "AR");
    public static final int VALIDERCHEFDEP = ParametreConstante.getInt("PRMS526", 5);
    public static final int VALIDERACHAPPROV = ParametreConstante.getInt("PRMS557", 2);
    public static final int VALIDERDIRSOURCE = ParametreConstante.getInt("PRMS558", 6);
    public static final int VALIDERCHEFDEPCIBLE = ParametreConstante.getInt("PRMS570", 7);
    public static final int VALIDERRSPACHAT = ParametreConstante.getInt("PRMS527", 4);
    public static final int VALIDERCG = ParametreConstante.getInt("PRMS528", 9);
    public static final int VALIDERCHEFFAB = ParametreConstante.getInt("PRMS529", 3);
    public static final String SERVICE_DMT = ParametreConstante.getString("PRMS530", "76");
    public static final String SERVICE_MTE = ParametreConstante.getString("PRMS531", "63");
    public static final String SERVICE_MTM = ParametreConstante.getString("PRMS532", "74");
    public static final String SERVICE_MTCH = ParametreConstante.getString("PRMS533", "75");
    public static final String SERVICE_BMT = ParametreConstante.getString("PRMS534", "77");
    public static final String SERVICE_DTAU = ParametreConstante.getString("PRMS535", "73");
    public static final String ID_TYPE_AVOIR = ParametreConstante.getString("PRMS559", "TYA0002");
    public static final String ID_MTF_AVOIR_RET = ParametreConstante.getString("PRMS560", "MOTIF0001");
    public static final String idPointVente = ParametreConstante.getString("PRMS561", "PNT000084");
    public static final String IDCAISSE_ESPECE_POS = ParametreConstante.getString("PRMS562", "CAIBO002");
    public static final String ROLE_COM = ParametreConstante.getString("PRZ0001", "com");

    public enum TypeRole {
        DG, CG, RESPACHAT, CHEFFAB, CHEF_DEP, ACHAPPROV, INCONNU
    }

    public static TypeRole identifierRole(String role) {
        if (Objects.equals(role, ROLE_DG)) return TypeRole.DG;
        if (Objects.equals(role, ROLE_CG)) return TypeRole.CG;
        if (Objects.equals(role, ROLE_RESPACHAT)) return TypeRole.RESPACHAT;
        if (Objects.equals(role, ROLE_CHEFFAB)) return TypeRole.CHEFFAB;
        if (Objects.equals(role, ROLE_CHEF_DEP)) return TypeRole.CHEF_DEP;
        if (Objects.equals(role, ROLE_ACHAPPROV)) return TypeRole.ACHAPPROV;
        return TypeRole.INCONNU;
    }

    public static String COMPTA_TYPE_COMPTE_GENERAL = ParametreConstante.getString("PRMS563", "1");
    public static String COMPTA_TYPE_COMPTE_AUTRE = ParametreConstante.getString("PRMS564", "TYPC000005");
    public static String COMPTA_TYPE_COMPTE_ANALYTIQUE = ParametreConstante.getString("PRMS565", "3");
    public static String COMPTA_TYPE_COMPTE_AUXILIAIRE = ParametreConstante.getString("PRMS566", "2");
    public static String DEPARTEMENT_DG = ParametreConstante.getString("PRMSD001", "DG");

//    public static final String DEPARTEMENT_DG = "DG";
}
