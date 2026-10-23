package utils;

public class ConstanteVente {

    public static final String tel = ParametreConstante.getString("PRMS462", "+261 20 85 253 24");
    public static final String fax = ParametreConstante.getString("PRMS463", "22 216 93");
    public static final String tel1 = ParametreConstante.getString("PRMS464", "+261 32 07 253 24");
    public static final String tel2 = ParametreConstante.getString("PRMS465", "+261 33 07 253 24");
    public static final String email = ParametreConstante.getString("PRMS466", "savson@blueline.mg / savtrop@blueline.mg");
    public static final String bni_cl = ParametreConstante.getString("PRMS467", "00005 00001 01462790100 32");
    public static final String boa = ParametreConstante.getString("PRMS468", "00009 07000 10000080000 90");
    public static final String bmoi = ParametreConstante.getString("PRMS469", "00004 00001 01000600000 30");
    public static final String bfv_sg = ParametreConstante.getString("PRMS470", "00008 00008 21010000400 10");
    public static final String cf = ParametreConstante.getString("PRMS471", "0232361/DGI-N DU 12/06/2026");
    public static final String stat = ParametreConstante.getString("PRMS472", "20231111966010003");
    public static final String nif = ParametreConstante.getString("PRMS473", "2 000 005 166");
    public static final String rcs = ParametreConstante.getString("PRMS540", "2003 B 004936");
    public static final String typepiecetraire = ParametreConstante.getString("PRMS474", "TP01");
    public static final String EFFETSARECEVOIRREMISALENCAISSEMENT = ParametreConstante.getString("PRMS475", "CAIS000017");
    public static final String caisseTraite = ParametreConstante.getString("PRMS476", "CAIS00000T00016");
    public static final String typeCheque = ParametreConstante.getString("PRMS477", "TCHQ00001");
    public static final String idtyperistourne = ParametreConstante.getString("PRMS478", "TYA0001");
    public static final String idmdpmttraite = ParametreConstante.getString("PRMS479", "003");
    public static final int etatEncaissee = ParametreConstante.getInt("PRMS480", -2);
    public static final String RAISON_SOCIAL = ParametreConstante.getString("PRMS481", "SAVONNERIE TROPICAL S.A");
    public static final String ADRESSE = ParametreConstante.getString("PRMS482", "ANKORONDRANO - B.P : 535");
    public static final String ADRESSE_CENTRE = ParametreConstante.getString("PRMS483", "ZONE INDUSTRIELLE NORD ANKORONDRANO");
    public static final String CENTRE_FISCAL = ParametreConstante.getString("PRMS484", "101 ANTANANARIVO");
    public static final String clientPersonnelSalarie = ParametreConstante.getString("PRMS541", "TYPE026");
    public static final String idFraisLivraons = ParametreConstante.getString("PRMS542", "DEP0001");
    public static final String pdg = ParametreConstante.getString("PRMS543", "RAMAROSON Thierry Charles Lem");
    public static final String caisseFaux = ParametreConstante.getString("PRMS544", "CAIS001");

    public static final String fichierLogo =
            System.getProperty("jboss.home.dir")
                    + "/standalone/deployments/savonnerie.war/assets/img/logo.png";
}
