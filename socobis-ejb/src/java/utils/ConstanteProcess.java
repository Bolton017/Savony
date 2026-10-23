package utils;

import bean.TypeObjet;
import paramCompta.ParamComptaStatique;

public class ConstanteProcess {


    public static final int entame = ParametreConstante.getInt("PRMS413", 21);

    public static final int bloque = ParametreConstante.getInt("PRMS414", 31);

    public static final int termine = ParametreConstante.getInt("PRMS415", 41);

    public static final String entameLib = ParametreConstante.getString("PRMS416", "entamer");

    public static final String bloqueLib = ParametreConstante.getString("PRMS417", "bloquer");

    public static final String termineLib = ParametreConstante.getString("PRMS418", "terminer");
}