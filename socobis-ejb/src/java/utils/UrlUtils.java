package utils;

import java.util.*;
import java.net.*;


public class UrlUtils {
    public static String modifierParametreDansUrl(String urlStr, String nomParam, String nouvelleValeur) {
        try {
            URL url = new URL(urlStr);
            String baseUrl = url.getProtocol() + "://" + url.getHost()
                    + (url.getPort() != -1 ? ":" + url.getPort() : "")
                    + url.getPath();

            // Parse query string
            String query = url.getQuery();
            Map<String, String> params = new LinkedHashMap<>();

            if (query != null) {
                for (String param : query.split("&")) {
                    String[] pair = param.split("=", 2);
                    String key = URLDecoder.decode(pair[0], "UTF-8");
                    String value = pair.length > 1 ? URLDecoder.decode(pair[1], "UTF-8") : "";
                    params.put(key, value);
                }
            }

            // Remplacer ou ajouter le paramètre
            params.put(nomParam, nouvelleValeur);

            // Reconstruire la query string
            StringBuilder newQuery = new StringBuilder();
            for (Map.Entry<String, String> entry : params.entrySet()) {
                if (newQuery.length() > 0) newQuery.append("&");
                newQuery.append(URLEncoder.encode(entry.getKey(), "UTF-8"))
                        .append("=")
                        .append(URLEncoder.encode(entry.getValue(), "UTF-8"));
            }

            // Retourner l’URL modifiée
            return baseUrl + (newQuery.length() > 0 ? "?" + newQuery : "");

        } catch (Exception e) {
            e.printStackTrace();
            return urlStr; // fallback si erreur
        }
    }
}
