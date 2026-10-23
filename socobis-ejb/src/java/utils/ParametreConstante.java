package utils;

import bean.TypeObjet;
import paramCompta.ParamComptaStatique;

public final class ParametreConstante {

    private ParametreConstante() {
    }

    static String getString(String id, String defaultValue) {
        try {
            TypeObjet parametre = TypeObjet.getById(
                    id,
                    ParamComptaStatique.getParamSocobis()
            );

            if (parametre == null || parametre.getVal() == null) {
                return defaultValue;
            }

            return parametre.getVal();
        } catch (Exception e) {
            return defaultValue;
        }
    }

    static TypeObjet getTypeObjet(
            String id,
            TypeObjet defaultValue
    ) {
        try {
            TypeObjet parametre = TypeObjet.getById(
                    id,
                    ParamComptaStatique.getParamSocobis()
            );

            if (parametre == null || parametre.getVal() == null) {
                return defaultValue;
            }

            return parametre;
        } catch (Exception e) {
            return defaultValue;
        }
    }

    static int getInt(String id, int defaultValue) {
        String valeur = getString(
                id,
                String.valueOf(defaultValue)
        );

        try {
            return Integer.parseInt(valeur.trim());
        } catch (Exception e) {
            return defaultValue;
        }
    }

    static double getDouble(String id, double defaultValue) {
        String valeur = getString(
                id,
                String.valueOf(defaultValue)
        );

        try {
            return Double.parseDouble(valeur.trim());
        } catch (Exception e) {
            return defaultValue;
        }
    }

    static boolean getBoolean(
            String id,
            boolean defaultValue
    ) {
        String valeur = getString(
                id,
                String.valueOf(defaultValue)
        );

        if ("true".equalsIgnoreCase(valeur.trim())) {
            return true;
        }

        if ("false".equalsIgnoreCase(valeur.trim())) {
            return false;
        }

        return defaultValue;
    }

    static String[] getArray(
            String id,
            String[] defaultValue
    ) {
        String valeurParDefaut = String.join(",", defaultValue);
        String valeur = getString(id, valeurParDefaut);

        if (valeur == null || valeur.trim().isEmpty()) {
            return defaultValue;
        }

        return valeur.split("\\s*,\\s*");
    }
}