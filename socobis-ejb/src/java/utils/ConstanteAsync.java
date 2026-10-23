package utils;

import annexe.ProduitLib;
import chatbot.ClassIA;
import fabrication.FabricationFilleCpl2;
import fabrication.OfFilleCpl;
import faturefournisseur.FactureFournisseurDetailsCpl;
import org.krysalis.barcode4j.impl.code128.Code128Bean;
import prevision.PrevisionComplet;
import stock.MvtStockFilleTheorique;
import stock.RapprochementOF;
import vente.BonDeCommande;
import vente.BonDeCommandeFIlleCpl;
import vente.VenteDetailsLib;

public class ConstanteAsync {
    public static Class<? extends ClassIA>[] iaClasses = new Class[]{VenteDetailsLib.class, FactureFournisseurDetailsCpl.class, FabricationFilleCpl2.class, PrevisionComplet.class, ProduitLib.class, OfFilleCpl.class, RapprochementOF.class};
    public static final String API_KEY = ParametreConstante.getString("PRMS072", "AIzaSyDQy1rDRDRwUSmYxITK9AubdkacFX0HXNQ");
    public static final String API_URL = ParametreConstante.getString("PRMS073", "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent");
    public static final String ADK_URL = ParametreConstante.getString("PRMS074", "http://localhost:8000");
    public static final String AI_CONTEXT = ParametreConstante.getString("PRMS075", "C'est une application d'une entreprise de confiserie et biscuiterie, donc tout ce qui est achat, depenses, ventes, bon de commande, fabrication, ordre de fabrication (OF), prevision, etc etc");
    public static final String AI_DEFINITIONS = ParametreConstante.getString("PRMS076", "");
    public static final String[] caisseTypeReport = ParametreConstante.getArray("PRMS077", new String[]{"TCA003", "TCA002"});

    public static final String[] mailRapport = ParametreConstante.getArray("PRMS078", new String[]{"noreplyasync@gmail.com", "lhcp apld qdgt tjqp"});

    public static final String roleChefProduction = ParametreConstante.getString("PRMS079", "cheffab");
    public static final String roleDg = ParametreConstante.getString("PRMS080", "dg");
    public static final String directionTana = ParametreConstante.getString("PRMS081", "DIR00001");

    public static final String POINT_SIEGE = ParametreConstante.getString("PRMS536", "PNT0000004");
    public static final String MAGAGIN = ParametreConstante.getString("PRMS101", "PNT000084");
    public static final String CAISSE_ESPECE = ParametreConstante.getString("PRMS108", "CAI000231");
    public static final String CAISSE_TPE = ParametreConstante.getString("PRMS109", "CAI00023");
    public static final String CAISSE_MVOLA = ParametreConstante.getString("PRMS110", "CAI10");
    public static final String CAISSE_ORANGE = ParametreConstante.getString("PRMS111", "CAI100");
    public static final String CAISSE_AIRTEL = ParametreConstante.getString("PRMS112", "CAI1000");
    public static final String CAISSE_CHEQUE = ParametreConstante.getString("PRMS113", "CAI000240");
    public static final String caisseTypeEspece = ParametreConstante.getString("PRMS114", "TCA003");
    public static final String caisseCategMvola = ParametreConstante.getString("PRMS115", "CTC004");
    public static final String caisseCategAirtel = ParametreConstante.getString("PRMS116", "CTC0012");
    public static final String caisseCategOrange = ParametreConstante.getString("PRMS117", "CTC005");
    public static final String caisseCategTpe = ParametreConstante.getString("PRMS118", "CTC007");
    public static final String caisseCategCheque = ParametreConstante.getString("PRMS119", "CTC002");
    public static final String caisseCategEspeece = ParametreConstante.getString("PRMS120", "CTC003");
    public static final String caisseBonAchat = ParametreConstante.getString("PRMS121", "CTC0011");
    public static final String caisseCadeaux = ParametreConstante.getString("PRMS122", "CTC0010");

    public static final String TYPE_FRAIS_ACCESSOIRE = ParametreConstante.getString("PRMS000494", "TPF0001");
    public static final String FAR = ParametreConstante.getString("PRMS000537", "FAR");

    public static final String pointDefaut = MAGAGIN;

    public static String[] getMailRapport(){
        return mailRapport;
    }

    public static final String[] couleurs = ParametreConstante.getArray("PRMS126", new String[]{"#FF5733", "#33FF57", "#3357FF", "#F1C40F", "#8E44AD", "#1ABC9C", "#E74C3C", "#2ECC71", "#3498DB", "#9B59B6", "#34495E", "#16A085", "#27AE60", "#2980B9", "#D35400", "#C0392B", "#BDC3C7", "#7F8C8D", "#FFB6C1", "#00CED1", "#FFD700", "#7FFF00", "#DC143C", "#4B0082", "#FF8C00", "#20B2AA", "#FF69B4", "#FF6347", "#40E0D0", "#6A5ACD", "#00FA9A", "#CD5C5C", "#9370DB", "#48D1CC", "#F08080", "#E9967A", "#8FBC8F", "#4169E1", "#800000", "#191970", "#FFA07A", "#FF4500", "#ADFF2F", "#00BFFF", "#DAA520", "#B22222", "#00FF7F", "#D8BFD8", "#008080", "#BDB76B", "#FF00FF", "#6B8E23", "#FF1493", "#8B0000", "#BC8F8F", "#00FFFF", "#696969", "#8B008B", "#FF7F50", "#A0522D", "#DB7093", "#556B2F", "#9932CC", "#B0E0E6", "#DDA0DD", "#A52A2A", "#2F4F4F", "#708090", "#FA8072", "#F5DEB3", "#DC143C", "#E0FFFF", "#F4A460", "#483D8B", "#6495ED", "#FFDEAD", "#3CB371", "#4682B4", "#C71585", "#F0E68C", "#9ACD32", "#D2691E", "#7B68EE", "#ADD8E6", "#BA55D3"});

    // Code barre
    public static final String PATH_DIR = System.getProperty("jboss.server.base.dir") + "/deployments/dossier.war";
    public static final Code128Bean CODE128_BEAN = new Code128Bean();
    public static final int DPI = ParametreConstante.getInt("PRMS139", 150);

    public static String buildChemin(String id) {
        return PATH_DIR + "/async/codebarre/vente/" + id + ".png";
    }

    static {
        CODE128_BEAN.setModuleWidth(0.4);
        CODE128_BEAN.setBarHeight(15);
        CODE128_BEAN.doQuietZone(true);
    }

    //Miova oany SAVONNERIE
//    public static final String PAIEMENT_ESPECE = "0002";
//    public static final String PAIEMENT_CARTE = "0003";
//    public static final String PAIEMENT_MOBILEMONEY = "0006";
//    public static final String PAIEMENT_CHEQUE = "0001";
//    public static final String PAIEMENT_MULTIPLE = "0005";

    public static final String PAIEMENT_CHEQUE = ParametreConstante.getString("PRMS106", "00025");
    public static final String PAIEMENT_ESPECE = ParametreConstante.getString("PRMS103", "00026");
    public static final String PAIEMENT_MOBILEMONEY = ParametreConstante.getString("PRMS105", "00030");
    public static final String PAIEMENT_CARTE = ParametreConstante.getString("PRMS104", "00027");
    public static final String PAIEMENT_MULTIPLE = ParametreConstante.getString("PRMS107", "00029");


    public static final String PAIEMENT_CARTECADEUAX = ParametreConstante.getString("PRMS124", "MP00023");
    public static final String PAIEMENT_BONACHAT = ParametreConstante.getString("PRMS125", "MP00024");

    public static final String COMPTE_REGROUPEMENT = ParametreConstante.getString("PRMS102", "710011");
    public static final String COMPTE_REGROUPEMENT_ACHAT = "610011";

    public static final String CAISSE_DEFAUT = ParametreConstante.getString("PRMS127", "CAIS001");

    //Ouverture Caisse
    public static final String type_report_ouverture = ParametreConstante.getString("PRMS547", "TYPREP01");
    public static final String type_report_fermeture = ParametreConstante.getString("PRMS548", "TYPREP02");
    public static final String type_report = ParametreConstante.getString("PRMS549", "TYPREP03");
    public static final String MAGAGIN_VENTEDIRECTE = ParametreConstante.getString("PRMS601", "MAGAPPRO1");
    public static final String CATEGORIE_SERVICES = ParametreConstante.getString("PRMS495", "CATS000001");
    public static final String DEVISE_AR = ParametreConstante.getString("PRMS679", "AR");


}
