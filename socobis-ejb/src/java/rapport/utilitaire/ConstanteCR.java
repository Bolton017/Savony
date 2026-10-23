package rapport.utilitaire;

public class ConstanteCR {

    public static final String[] mailRapport={"noreplyasync@gmail.com","lhcp apld qdgt tjqp"};
    public static final String PROJECT_NAME = "Savonnerie.war";
    public static final String JAR_NAME = "socobis-ejb.jar";
    public static String BASE_DIR = System.getProperty("jboss.server.base.dir") + "/deployments/dossier.war/";
    public static String IBB_API_KEY = "1297cea4e5b7b73d1df8f44e0c80b2af";

    public static String[] getMailRapport(){
        return mailRapport;
    }

}
