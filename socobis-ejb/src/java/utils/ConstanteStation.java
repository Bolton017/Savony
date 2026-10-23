package utils;

import java.io.IOException;

public class ConstanteStation {

    public static final int nombreJourScindeDefaut = ParametreConstante.getInt("PRMS419", 7);
    public static final String idTypeReservoir = ParametreConstante.getString("PRMS420", "TYPMG000001");
    public static final String idTypeCarburant = ParametreConstante.getString("PRMS421", "TPRD001");
    public static final String idTypeNormal = ParametreConstante.getString("PRMS422", "TYPMG000002");
    private static String fichierCentre = ParametreConstante.getString("PRMS423", "Z:\\git\\gestion-socobis\\fichierCentre.txt");
    public static final String idTypeMagasinIlot = ParametreConstante.getString("PRMS424", "TYPMG000023");
    public static final String TypeProduitLubrifiant = ParametreConstante.getString("PRMS425", "TPR000021");
    public static final String TYPEMVTSTOCKENTREE = ParametreConstante.getString("PRMS426", "TPMVST000001");
    public static final String TYPEMVTSTOCKSORTIE = ParametreConstante.getString("PRMS427", "TPMVST000022");
    public static final String TYPEMVTSTOCKINVENTAIRE = ParametreConstante.getString("PRMS428", "TPMVST000023");
    public static final String idMagasinProduitfini = ParametreConstante.getString("PRMS539", "PHARM005");
    public static final String CAISSETYPEBANQUE = ParametreConstante.getString("PRMS429", "TCA001");
    public static final String CAISSETYPEMOBILEMONEY = ParametreConstante.getString("PRMS430", "TCA002");
    public static final String CAISSETYPEPHYSIQUE = ParametreConstante.getString("PRMS431", "TCA003");
    public static final String CAISSETYPEVIRTUELLE = ParametreConstante.getString("PRMS432", "TCA004");
    public static final String CATEGORIECAISSEMVOLA = ParametreConstante.getString("PRMS433", "CTC004");
    public static final String CATEGORIECAISSEESPECES = ParametreConstante.getString("PRMS434", "CTC003");
    public static final String CATEGORIECAISSEORANGEMONEY = ParametreConstante.getString("PRMS435", "CTC005");
    public static final String CATEGORIECAISSEFANILO = ParametreConstante.getString("PRMS436", "CTC006");
    public static final String CATEGORIECAISSETPE = ParametreConstante.getString("PRMS437", "CTC007");
    public static final String CARTEVISA = ParametreConstante.getString("PRMS438", "CTC008");
    public static final String CATEGORIECAISSEBON = ParametreConstante.getString("PRMS439", "CTC001");
    public static final String CATEGORIECAISSECHEQUE = ParametreConstante.getString("PRMS440", "CTC002");
    public static String JOURNALVENTE = ParametreConstante.getString("PRMS441", "COMP000039");
    public static String JOURNAL_OPERATION_DIVERS = ParametreConstante.getString("PRMS442", "COMP000042");
    public static String comptaOriginefactureClient = ParametreConstante.getString("PRMS443", "FC");
    public static String comptaOriginevente = ParametreConstante.getString("PRMS444", "VNT");
    public static String journalAchat = ParametreConstante.getString("PRMS445", "COMP000067");
    public static final String journalCaisse = ParametreConstante.getString("PRMS446", "COMP000036");
    public static String comptaOriginefactureFournisseur = ParametreConstante.getString("PRMS447", "FF");
    public static String compteFournisseurDivers = ParametreConstante.getString("PRMS448", "401000");
    public static String compteTVACollecte = ParametreConstante.getString("PRMS449", "44571");
    public static String compteTVADeductible = ParametreConstante.getString("PRMS450", "44566");
    public static String TYPE_ENCAISSEMENT_SORTIE = ParametreConstante.getString("PRMS451", "TE002");
    public static String TYPE_ENCAISSEMENT_ENTREE = ParametreConstante.getString("PRMS452", "TE001");
    public static String idCaisse = ParametreConstante.getString("PRMS453", "CAI000237");
    public static final String idClientDivers = ParametreConstante.getString("PRMS454", "CLI000054");
    public static final String idFournisseurDivers = ParametreConstante.getString("PRMS455", "FRNDIV01");
    public static final String idMagasin = ParametreConstante.getString("PRMS456", "PHARM0044");
    public static final String idProduitAutre = ParametreConstante.getString("PRMS457", "CATING000041");
    public static final String idProduitService = ParametreConstante.getString("PRMS458", "CATS000001");
    public static final String point_par_defaut = ParametreConstante.getString("PRMS460", "defaut");
    private static final String POINT_CENTRE_DEFAUT = ParametreConstante.getString("PRMS461", "PNT000084");

    public static String getFichierCentre() throws IOException {
        return POINT_CENTRE_DEFAUT;
    }
}

