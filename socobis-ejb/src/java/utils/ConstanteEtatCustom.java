package utils;

public class ConstanteEtatCustom {

    public static int PAYE_LIVRE = ParametreConstante.getInt("PRMS209", 14);

    public static int LIVRE_NON_PAYE = ParametreConstante.getInt("PRMS210", 12);

    public static int PAYE_NON_LIVRE = ParametreConstante.getInt("PRMS211", 13);
}