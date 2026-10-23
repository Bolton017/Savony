package utils;

public class ConstanteAxelle {

    public static final String SOCIETE_ID_AXELLE = ParametreConstante.getString("PRMS140", "AXL");
    public static final String SOCIETE_ID_CADENCE = ParametreConstante.getString("PRMS141", "CDC");
    public static final String ACTIF_ETAT_CATEGORIE_QUALIFICATION = ParametreConstante.getString("PRMS142", "1");
    public static final String SEQUENCE_MATRICULE_CREATION = ParametreConstante.getString("PRMS143", "GETseq_matricule");
    public static final String IDROLE_UTILISATEUR_dg = ParametreConstante.getString("PRMS144", "dg");
    public static final String IDROLE_UTILISATEUR_admin_rh = ParametreConstante.getString("PRMS145", "admin_rh");
    public static final int ETAT_DT = ParametreConstante.getInt("PRMS146", 3);
    public static int etatDT() {
        return ETAT_DT;
    }

    public static final int DPI = ParametreConstante.getInt("PRMS147", 150);
    public static final String addresse1 = ParametreConstante.getString("PRMS148", "VP 08 ter LAZAINA");
    public static final String addresse2 = ParametreConstante.getString("PRMS149", "ANOSY AVARATRA BP 103");
    public static final String nomEntreprise = ParametreConstante.getString("PRMS150", "AXELLE");
    public static final String email = ParametreConstante.getString("PRMS151", "axelle@gmail.com");
    public static final String telephone = ParametreConstante.getString("PRMS152", "0202222222");
    public static final String page_url = ParametreConstante.getString("PRMS153", "http://localhost:8080/axelle/pages/module.jsp");
    public static final String idMagasinDormant = ParametreConstante.getString("PRMS154", "MAG0002712");
    public static final String idTypeMagasinGots = ParametreConstante.getString("PRMS155", "TYPMAN00001");
    public static final String idModeleGots = ParametreConstante.getString("PRMS156", "MODELAN00001");
    public static final String AES_KEY_B64 = ParametreConstante.getString("PRMS157", "86BP1O9Cg+0J1mN0hIlfncKNtw0/Zy4zj4R59+FxMrw=");
    public static final String ID_TYPE_FRN_FORMATEUR = ParametreConstante.getString("PRMS158", "TYP000004");
    public static final String idModePaiementCheque = ParametreConstante.getString("PRMS159", "0001");
    public static final String idDeviseAr = ParametreConstante.getString("PRMS160", "AR");
    public static final String ID_CATEGORIESTOCK_KO = ParametreConstante.getString("PRMS161", "CATSTOCK003");
    public static final String ID_CATEGORIESTOCK_ATTENTE = ParametreConstante.getString("PRMS162", "CATSTOCK002");
    public static final String IDTYPEFOURNISSEURFORMATEUR = ParametreConstante.getString("PRMS163", "TYP000004");
    public static final String DEFAULT_GRAPH_BACKGROUND_COLOR = ParametreConstante.getString("PRMS164", "#FFF8EB");
    public static final String[] DEFAULT_COLORS = ParametreConstante.getArray("PRMS165", new String[]{"#275ec4", "#4077dd", "#6a95e4", "#95b3ec", "#bfd1f4", "#e9f0fb"});
    public static final String TYPE_COMPTE_AUTRE = ParametreConstante.getString("PRMS166", "2");
    public static final String ROLE_DG = ParametreConstante.getString("PRMS167", "dg");
    public static final String ROLE_DAF = ParametreConstante.getString("PRMS168", "daf");
    public static final String ROLE_DIRCOM = ParametreConstante.getString("PRMS169", "dir_com");
    public static final String ROLE_RESPACHAT = ParametreConstante.getString("PRMS170", "respachat");
    public static final String ROLE_COM = ParametreConstante.getString("PRMS171", "com");
    public static final String ROLE_DIR_PROD = ParametreConstante.getString("PRMS172", "dir_prod");
    public static final String ROLE_PROD = ParametreConstante.getString("PRMS173", "prod");
    public static final String DIR_RATTACHEMENT = ParametreConstante.getString("PRMS174", "dir_rattachement");
    public static final String ROLE_RESP_BU_RAPHIA = ParametreConstante.getString("PRMS175", "resp_bu_raphia");
    public static final int ETAT_VALIDE_DEMANDEUR = ParametreConstante.getInt("PRMS176", 2);
    public static final int ETAT_VALIDE_DAF_DIRCOM = ParametreConstante.getInt("PRMS177", 4);
    public static final int ETAT_VALIDE_RESPACHAT = ParametreConstante.getInt("PRMS178", 10);
    public static final int ETAT_VALIDE_DIRCOM = ParametreConstante.getInt("PRMS179", 5);
    public static final int ETAT_VALIDE_DIRCOM_DMDACHAT = ParametreConstante.getInt("PRMS180", 4);
    public static final int ETAT_VALIDE_COM = ParametreConstante.getInt("PRMS181", 3);
    public static final int ETAT_VALIDE_PROD = ParametreConstante.getInt("PRMS182", 5);
    public static final int ETAT_VALIDE_DIR_PROD = ParametreConstante.getInt("PRMS183", 6);
    public static final int ETAT_VALIDE_RESP_BU_RAPHIA = ParametreConstante.getInt("PRMS184", 7);
    public static final int ETAT_VALIDE_DIR_RATTACHEMENT = ParametreConstante.getInt("PRMS185", 9);
    public static final String MAGASIN_RAPHIA = ParametreConstante.getString("PRMS186", "PNT000084");
    public static final String MAG_RECEPTION = ParametreConstante.getString("PRMS187", "PNT00000049");
    public static final String ATTENTE_DECISION = ParametreConstante.getString("PRMS188", "CATSTOCK002");
    public static final String ROLE_RSPQLT = ParametreConstante.getString("PRMS189", "respqualite");
    public static final String EN_ATTENTE = ParametreConstante.getString("PRMS190", "CATSTOCK002");
    public static final String NC = ParametreConstante.getString("PRMS191", "CATSTOCK004");
    public static final String CATING_TISSU = ParametreConstante.getString("PRMS192", "CATAN001");
    public static final String UNITE_M = ParametreConstante.getString("PRMS193", "UNT000071");
    public static final String CATING_ACCESSOIRE = ParametreConstante.getString("PRMS194", "CATING000041");
    public static final String CATING_RAPHIA = ParametreConstante.getString("PRMS195", "CATAN002");
    public static final String CATEGORIE_CONFORME = ParametreConstante.getString("PRMS196", "CATSTOCK001");
    public static final String CATEGORIE_REJET = ParametreConstante.getString("PRMS197", "CATSTOCK003");
    public static final String CATEGORIE_NC = ParametreConstante.getString("PRMS198", "CATSTOCK004");
    public static final String adr1 = ParametreConstante.getString("PRMS199", "Lot VP 08 Ter Lazaina");
    public static final String adr2 = ParametreConstante.getString("PRMS200", "nosy Avaratra");
    public static final String adr3 = ParametreConstante.getString("PRMS201", "Antananarivo - Madagascar");
    public static final String tel = ParametreConstante.getString("PRMS202", "320723360-342242812");
    public static final String fax = ParametreConstante.getString("PRMS203", "(00)261202474100");
    public static final String mail = ParametreConstante.getString("PRMS204", "achat@axelle.mg");
    public static final String contact = ParametreConstante.getString("PRMS205", "Miora");
    public static final int decisionNC = ParametreConstante.getInt("PRMS206", 0);
    public static final int decisionConforme = ParametreConstante.getInt("PRMS207", 11);
    public static final int decisionDerogation = ParametreConstante.getInt("PRMS208", 7);

}
