package paramCompta;

import bean.CGenUtil;
import bean.TypeObjet;
import utilitaire.UtilDB;

import java.sql.Connection;

public class ParamComptaStatique {

    private static TypeObjet[] paramCompta;
    private static TypeObjet[] paramSocobis;

    public static TypeObjet[] getParamCompta(Connection c) throws Exception {
        if (paramCompta == null) {
            reload(c);
        }
        return paramCompta;
    }


    public static TypeObjet[] getParamSocobis(Connection c) throws Exception {
        if (paramSocobis == null) {
            reload(c);
        }
        return paramSocobis;
    }

    public static TypeObjet[] reload(Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            TypeObjet critereCompta = new TypeObjet();
            critereCompta.setNomTable("PARAMCOMPTA");
            TypeObjet critereSocobis = new TypeObjet();
            critereSocobis.setNomTable("paramConstanteSocobis");
            TypeObjet[] nouveauParamCompta = (TypeObjet[]) CGenUtil.rechercher(critereCompta, null, null, c, "");
            TypeObjet[] nouveauParamSocobis = (TypeObjet[]) CGenUtil.rechercher(critereSocobis, null, null, c, "");
            paramCompta = nouveauParamCompta;
            paramSocobis = nouveauParamSocobis;
            return paramCompta;
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    public static TypeObjet[] getParamCompta() throws Exception {
        if (paramCompta == null) {
            getParamCompta(null);
        }
        return paramCompta;
    }


    public static TypeObjet[] getParamSocobis() throws Exception {
        if (paramSocobis == null) {
            getParamSocobis(null);
        }
        return paramSocobis;
    }

    public static void setParamSocobis(TypeObjet[] paramSocobis) {
        ParamComptaStatique.paramSocobis = paramSocobis;
    }

    public static void setParamCompta(TypeObjet[] paramCompta) {
        ParamComptaStatique.paramCompta = paramCompta;
    }


    public static TypeObjet[] filtrer(String id, String val, String desce) throws Exception {
        return TypeObjet.filtrer(id, val, desce, getParamCompta());
    }


    public static TypeObjet getById(String id) throws Exception {
        return TypeObjet.getById(id, getParamCompta());
    }

}